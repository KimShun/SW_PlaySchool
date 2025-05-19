from fastapi import FastAPI, Form, HTTPException, Request, UploadFile, File
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from openai import OpenAI
from typing import Union

import os
import json
import re
import importlib.util
import asyncio
import httpx
from concurrent.futures import ThreadPoolExecutor

OPENAI_KEY = "API-KEY"
os.environ["KNP_DUPLICATION_LIB_OK"] = "True"

app = FastAPI()

SERVER_HOST = "127.0.0.1"
SERVER_PORT = "8000"

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

INPUT_FOLDER = "./input"
OUTPUT_FOLDER = "./output"

# 정적 파일 폴더 설정
app.mount("/input", StaticFiles(directory=INPUT_FOLDER), name="input")
app.mount("/output", StaticFiles(directory=OUTPUT_FOLDER), name="output")

# 허용할 파일 확장자
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "jfif"}

executor = ThreadPoolExecutor()

# @app.post("/test/chatGPT")
# async def gpt(content: str = Form(...)):
#     response = make_prompt(content)
#     return JSONResponse({"result" : response})

# 일반적인 동화책 만들기
@app.post("/make/fairyBook")
async def createMyFairyBook(
    content_line: str = Form(...), 
    userUID: str = Form(...), 
    img: Union[UploadFile, str, None] = File(default=None)):

    # img가 빈 문자열("")로 들어올 경우 None으로 처리
    if img == "" or img is None:
        img = None

    # img가 UploadFile 객체인지 확인
    if img is not None and not isinstance(img, UploadFile):
        raise HTTPException(status_code=400, detail="img 필드에 올바른 파일을 넣어주세요.")

    result_path_list = [
        f"./output/fairyBook_{userUID}_00001_.png",
        f"./output/fairyBook_{userUID}_00002_.png",
        f"./output/fairyBook_{userUID}_00003_.png",
        f"./output/fairyBook_{userUID}_00004_.png",
    ]

    for path in result_path_list:
        if os.path.exists(path):
            os.remove(path)

    try:
        prompt_result = make_prompt(content_line)
        # print(prompt_result)
        positive_prompt = ""; negative_prompt = ""

        content_list = []
        for res in prompt_result:
            positive_prompt += res["Positive Prompt"]; positive_prompt += "\n"
            negative_prompt += res["Negative Prompt"]; negative_prompt += "\n"
            content_list.append(res["description"])

        if img:
            if not allowed_file(img.filename):
                raise HTTPException(status_code=400, detail="지원하지 않는 이미지 형식입니다.")

            image_data = await img.read()
            await call_comfyui_api(positive_prompt, negative_prompt, userUID, image_data)

        else:
            await call_comfyui_api(positive_prompt, negative_prompt, userUID)

        return {
            "message": "성공적으로 동화책이 완성되었습니다.!",
            "content" : content_list,
            "imgs" : result_path_list,
        }

    except Exception as e:
        import traceback
        traceback.print_exc()
        return JSONResponse({"error": str(e)}, status_code=500)

async def call_comfyui_api(positive_prompt, negative_prompt, userUID, image_data=None):
    if (image_data == None):
        url = "http://127.0.0.1:8188/prompt"

        with open("./fairyBook.json", "r") as f:
            workflow = json.load(f)

        workflow["45"]["inputs"]["text"] = positive_prompt
        workflow["46"]["inputs"]["text"] = negative_prompt
        workflow["32"]["inputs"]["filename_prefix"] = f"fairyBook_{userUID}"
    
    else:
        url = "http://127.0.0.1:8188/prompt"

        with open("./fairyBook_Face.json", "r") as f:
            workflow = json.load(f)

        workflow["45"]["inputs"]["text"] = positive_prompt
        workflow["46"]["inputs"]["text"] = negative_prompt
        workflow["26"]["inputs"]["filename_prefix"] = f"fairyBook_{userUID}"

        import tempfile
        tmp_path = f"./input/{userUID}_input.png"
        with open(tmp_path, "wb") as f:
            f.write(image_data)

        workflow["10"]["inputs"]["image"] = tmp_path
    
    async with httpx.AsyncClient() as client:
        response = await client.post(url, json={"prompt": workflow})
        response.raise_for_status()
    
    expected_images = [
        f"./output/fairyBook_{userUID}_00001_.png",
        f"./output/fairyBook_{userUID}_00002_.png",
        f"./output/fairyBook_{userUID}_00003_.png",
        f"./output/fairyBook_{userUID}_00004_.png",
    ]

    while True:
        if all(os.path.exists(img) for img in expected_images):
            break
        await asyncio.sleep(1)  # 너무 빠르게 돌지 않게 1초 쉬기

    return {"status": "complete"}
    
def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

def make_prompt(content_line):
    client = OpenAI(api_key = OPENAI_KEY)
    response = client.responses.create(
        model = "gpt-4o",
        input = [
            {
                "role": "system",
                "content": [
                    {
                        "type": "input_text",
                        "text": """## Role
                                    - 너는 ComfyUI Prompt 전문가이면서, 동화책 소설 작가야.
                                    - 등장인물들의 생김새, 옷차림, 색상, 특징을 모든 컷에 정확히 동일하게 반복해서 묘사해줘.
                                    - 등장인물 외형(헤어스타일, 눈 색, 옷, 표정 등)은 컷마다 다시 써주고 절대 변형되지 않도록 고정해줘.

                                    ## Task
                                    - 사용자가 전달한 주제를 바탕으로 자연스럽게 4컷 분량의 동화 이야기를 만들어줘.
                                    - 각 컷마다 다음 4개의 항목을 반드시 포함해줘:  
                                    "scene", "description", "Positive Prompt", "Negative Prompt"
                                    - Positive Prompt에는 LoRA에 적합한 표현 사용하고, 반드시 sketch, watercolor, storybook, colorful, soft light을 포함해줘.
                                    - Negative Prompt에는 distortions, ugly, low quality, (embedding:easynegative) 등을 반드시 포함해줘.
                                    - 등장인물 외형 정보는 매 컷의 Positive Prompt에 정확히 동일하게 반복해서 작성해줘.
                                    - 동작이나 배경은 단순하게 유지해줘 (ComfyUI 한계 고려).

                                    ## Output Format
                                    - 결과물은 반드시 **JSON 배열** 형태로 출력해줘.  
                                    - 예를 들어:

                                    [
                                    {
                                        "scene": 1,
                                        "description": "...",
                                        "Positive Prompt": "...",
                                        "Negative Prompt": "..."
                                    },
                                    {
                                        "scene": 2,
                                        "description": "...",
                                        "Positive Prompt": "...",
                                        "Negative Prompt": "..."
                                    },
                                    ...
                                    ]

                                    - JSON 배열 외에는 어떠한 텍스트도 포함하지 마세요.  
                                    - 순수 JSON 문자열만 반환해 주세요.

                                    ## Tip
                                    - 아이들에게 이야기하듯 부드럽고 귀엽게 작성해줘.
                                    - 이미지 왜곡이 없도록 주의해줘.
                                    - 복잡한 동작과 배경은 피하고 단순하고 따뜻한 분위기로 구성해줘.
                                    """
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "input_text",
                        "text": content_line,
                    },
                ],
            },
        ],
        text={
            "format": {
                "type": "text"
            }
        },
        reasoning={},
        tools=[],
        temperature=1,
        max_output_tokens=2048,
        top_p=1,
        store=True
    )

    response_data = response.output[0].content[0].text
    cleaned_text = re.sub(r"^```json\n|```$", "", response_data.strip(), flags=re.MULTILINE)
    return json.loads(cleaned_text)

import uvicorn
if __name__ == "__main__":
    uvicorn.run("fairyBook_run:app", host="192.168.1.60", port=8001)