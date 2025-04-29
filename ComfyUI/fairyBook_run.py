from fastapi import FastAPI, Form, HTTPException, Request, UploadFile, File
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from openai import OpenAI
from typing import Optional

import os
import json
import re
import importlib.util

from dotenv import load_dotenv
OPENAI_KEY = os.getenv("OPENAI_API_KEY")

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

# fairyBook 모델 불러오기
module_name = "fairyBook"
module_path = os.path.join("custom_nodes", "ComfyUI-to-Python-Extension", "nodes", "fairyBook.py")
spec = importlib.util.spec_from_file_location(module_name, module_path)
fairyBook_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fairyBook_module)

# fairyBook_Face 모델 불러오기
module_name = "fairyBookFace"
module_path = os.path.join("custom_nodes", "ComfyUI-to-Python-Extension", "nodes", "fairyBook_Face.py")
spec = importlib.util.spec_from_file_location(module_name, module_path)
fairyBookFace_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fairyBookFace_module)

# @app.post("/test/chatGPT")
# async def gpt(content: str = Form(...)):
#     response = make_prompt(content)
#     return JSONResponse({"result" : response})

# 일반적인 동화책 만들기
@app.post("/make/fairyBook")
async def createMyFairyBook(content_line: str = Form(...), userUID: str = Form(...), img: Optional[UploadFile] = File(None)):
    result_path_list = [
        f"./output/fairyBook_{userUID}_00001_.jpg",
        f"./output/fairyBook_{userUID}_00002_.jpg",
        f"./output/fairyBook_{userUID}_00003_.jpg",
        f"./output/fairyBook_{userUID}_00004_.jpg",
    ]

    for path in result_path_list:
        if os.path.exists(path):
            os.remove(path)

    try:
        prompt_result = make_prompt(content_line)
        positive_prompt = "", negative_prompt = ""

        content_list = []
        for res in prompt_result:
            positive_prompt += res["Positive Prompt"]; positive_prompt += "\n"
            negative_prompt += res["Negative Prompt"]; negative_prompt += "\n"
            content_list.append(res["description"])


        if img:
            if not allowed_file(img.filename):
                raise HTTPException(status_code=400, detail="지원하지 않는 이미지 형식입니다.")

            fairyBookFace_module.main(positive_prompt, negative_prompt, userUID, await img.read())

        else:
            fairyBook_module.main(positive_prompt, negative_prompt, userUID)

        return {
            "message": "성공적으로 동화책이 완성되었습니다.!",
            "content" : content_list,
            "imgs" : result_path_list,
        }

    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)
    

    
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
                        "text": "## Role\n- 너는 ComfyUI Prompt 전문가이면서, 동화책 소설 작가야.\n- SD1.5와 LoRA 등의 기술을 잘 활용해 동화풍 일러스트를 만드는 데 특화되어 있어.\n- 등장인물들의 생김새, 옷차림, 색상, 특징을 **모든 컷에 정확히 동일하게 반복해서 묘사해줘**.\n- 등장인물의 외형(예: 헤어스타일, 눈 색, 옷, 표정 등)은 **컷마다 다시 써주고, 절대 변형되지 않도록 고정**해줘.\n\n## Task\n- 사용자가 전달한 주제를 바탕으로 자연스럽게 4컷 분량의 동화 이야기를 만들어줘.\n- 각 컷마다 이야기와 함께 이야기를 표현하기 위한 Positive Prompt와 Negative Prompt를 만들어줘.\n- 등장인물(예: 주인공, 동물 등)의 외형 정보는 **매 컷의 Positive Prompt에 정확히 동일하게 반복해서 작성해줘야 해**.\n- 표현이 가능한 범위 내에서 동작이나 배경은 단순하게 유지해줘. (ComfyUI의 한계 고려)\n- 결과물은 반드시 JSON 형식으로 출력하고, 각 컷에는 다음 4개의 항목을 포함해야 해:\n\n예시)\n\"scene\" : 1  \n\"description\" : ~~~~~  \n\"Positive Prompt\" : ~~~~~  \n\"Negative Prompt\" : ~~~~~  \n\n## TIP\n- 동화 내용을 아이들에게 말하는 것처럼 대화형식 처럼 만들어줘.\n- 이미지 왜곡이 없도록 신경 써줘.\n- 아이들 동화책 느낌을 살려, 따뜻하고 귀여운 분위기로 구성해줘.\n- Positive Prompt에는 LoRA에 적합한 표현 사용해주고, sketch, watercolor, storybook, colorful, soft light 은 반드시 포함해줘.\n- Negative Prompt에는 distortions, ugly, low quality, (embedding:easynegative) 등을 반드시 포함해줘.\n- 복잡한 동작이나 배경은 피하고, ComfyUI에서 표현이 쉬운 요소로 제한해줘.\n\n## WARNING\n- 등장인물의 옷이나 외형이 컷마다 달라지지 않도록 해. 컷마다 반복 안 하면 안 돼.\n- 프롬프트에서 인물 외형을 생략하거나 축약해서 쓰지 마. 항상 완전하게 써줘."
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