## ComfyUI 작업
### 동화책 만들기 기능

### 모델은 다음과 같이 두 개로 나뉨
- FairyTaleBook : 간단하게 동화책 만들기
- FairyTaleBookFace : 사용자가 직접 주인공이 되어 동화책 만들기

### 실험 환경
- iMac M3 VRAM 8GB (MPS)
- Python 3.12.9

### 사용방법
- ComfyUI Github에 들어가서 다운
- requirements.txt 참고하여 필요한 라이브러리 설치
- 다음과 같은 Custom_nodes 설치할 것.
    - bjornulf_custom_nodes
    - ComfyUI_Comfytoll_CustomNodes
    - comfyui_ipadapter_plus
    - comfyui_impact_pack
    - comfyui_impact_subpack
    - comfyui_manager
    - efficiency_nodes_comfyui
    - sdxl_prompt_styler
    - comfyui_to_python_extension
- 해당 링크에 접속하여 모델을 다운 받을 것.
    - https://drive.google.com/file/d/1H4_z_jgtfewYvine8I0JizAs9egdakK1/view?usp=sharing

### 테스트환경에서의 실행방법
- python main.py --use-split-cross-attention