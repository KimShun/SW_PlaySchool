from fastapi import FastAPI, Request, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware

import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

from fastdtw import fastdtw
from scipy.spatial.distance import euclidean

import cv2 as cv
import tempfile
import numpy as np
import os

app = FastAPI()

@app.middleware("http")
async def detect_server_info(request: Request, call_next):
    global SERVER_HOST, SERVER_PORT
    server = request.scope.get("server", None)
    if server:
        SERVER_HOST = server[0]
        SERVER_PORT = server[1]
    response = await call_next(request)
    return response

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/exercise/dance/assessment")
async def assessmentDance(original: UploadFile = File(...), follow: UploadFile = File(...)):
    BaseOptions = mp.tasks.BaseOptions
    PoseLandmarker = mp.tasks.vision.PoseLandmarker
    PoseLandmarkerOptions = mp.tasks.vision.PoseLandmarkerOptions
    VisionRunningMode = mp.tasks.vision.RunningMode

    model_path = "./model/pose_landmarker_full.task"

    # 원본 동영상 분석하기 위한 MediaPipe 모델 구성
    options_original = PoseLandmarkerOptions(
        base_options=BaseOptions(model_asset_path=model_path),
        running_mode=VisionRunningMode.VIDEO
    )

    detector_original = vision.PoseLandmarker.create_from_options(options_original)

    # 원본 동영상 시스템에 임시저장
    data = await original.read()
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as f:
        f.write(data)
        original_path = f.name

    # 원본 동영상 분석 시작
    original_landmarks = extract_pose_landmarks(original_path, detector_original)
    detector_original.close() # 분석 종료
    
    # 따라한 동영상 분석하기 위한 MediaPipe 모델 구성
    options_follow = PoseLandmarkerOptions(
        base_options=BaseOptions(model_asset_path=model_path),
        running_mode=VisionRunningMode.VIDEO
    )

    detector_follow = vision.PoseLandmarker.create_from_options(options_follow)
    
    # 따라한 동영상 시스템에 임시저장
    data = await follow.read()
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as f:
        f.write(data)
        follow_path = f.name

    # 따라한 동영상 분석 시작
    follow_landmarks = extract_pose_landmarks(follow_path, detector_follow)
    detector_follow.close() # 분석 종료

    similarity = calculate_similarity(original_landmarks, follow_landmarks) # 유사도 검사
    movement = calculate_movement_range(follow_landmarks) # 움직임 범위 검사

    # 임시로 저장한 동영상 파일 삭제
    os.remove(original_path)
    os.remove(follow_path)

    return {
        "similarity_score" : similarity,
        "movement_range" : movement
    }

# 관절 포인트
KEY_LANDMARKS = [
    0,   # nose (머리 기준점)
    11, 12,  # left, right shoulder
    13, 14,  # left, right elbow
    15, 16,  # left, right wrist
    23, 24,  # left, right hip
    25, 26,  # left, right knee
    27, 28,  # left, right ankle
]

# 모델에 적합한 사이즈로 변경 함수
def resize_frame_with_padding(frame, target_size=(256, 256)):
    h, w, _ = frame.shape

    scale = min(target_size[0] / h, target_size[1] / w)
    new_w = int(w * scale)
    new_h = int(h * scale)

    resized_frame = cv.resize(frame, (new_w, new_h))

    top = (target_size[1] - new_h) // 2
    bottom = target_size[1] - new_h - top
    left = (target_size[0] - new_w) // 2
    right = target_size[0] - new_w - left

    padded_frame = cv.copyMakeBorder(resized_frame, top, bottom, left, right, cv.BORDER_CONSTANT, value=(0, 0, 0))
    return padded_frame

# 포즈 추출 함수
def extract_pose_landmarks(video_path, landmarker):
    cap = cv.VideoCapture(video_path)
    pose_list = []
    
    # 해당 영상의 프레임 추출
    fps = cap.get(cv.CAP_PROP_FPS)
    total_frames = int(cap.get(cv.CAP_PROP_FRAME_COUNT))

    if fps <= 0:
        print(f"Warning: Could not get FPS for {video_path}. Assuming 30 FPS.")
        fps = 30.0

    frame_index = 0
    last_timestamp_ms_used = 0

    while frame_index < total_frames:
        ret, frame = cap.read()
        if not ret: break
    
        calculated_timestamp_ms = int((frame_index / fps) * 1000)
        timestamp_for_mediapipe = max(calculated_timestamp_ms, last_timestamp_ms_used + 1.0)

        padded_frame = resize_frame_with_padding(frame, target_size=(256, 256))
        rgb_frame = cv.cvtColor(padded_frame, cv.COLOR_BGR2RGB)
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb_frame)

        print(frame_index, calculated_timestamp_ms, last_timestamp_ms_used)

        try:
            result = landmarker.detect_for_video(mp_image, int(timestamp_for_mediapipe))
            if result.pose_landmarks:   
                landmarks = result.pose_landmarks[0]
                pose = [(landmarks[i].x, landmarks[i].y, landmarks[i].z) for i in KEY_LANDMARKS]
                pose_list.append(pose)

        except Exception as e:
            print(f"Error processing frame at timestamp {timestamp_for_mediapipe}ms (index {frame_index}): {e}")
            continue

        last_timestamp_ms_used = timestamp_for_mediapipe
        frame_index += 1

    cap.release()
    return pose_list

# fastDTW를 적용한 유사도 검사
def calculate_similarity(pose_seq1, pose_seq2):
    if not pose_seq1 or not pose_seq2:
        return 0.0
    
    seq1 = [np.array(pose).flatten() for pose in pose_seq1]
    seq2 = [np.array(pose).flatten() for pose in pose_seq2]

    distance, _ = fastdtw(seq1, seq2, dist=euclidean)

    avg_distance = distance / max(len(seq1), len(seq2))
    score = max(0.0, 100 - avg_distance * 10)

    return round(score, 2)

# 움직인 범위 검사
def calculate_movement_range(pose_sequence):
    if not pose_sequence:
        return 0.0
    
    pose_array = np.array(pose_sequence)
    movement_per_joint = np.ptp(pose_array, axis=0)

    mean_movement = np.mean(movement_per_joint)
    return round(mean_movement, 4)