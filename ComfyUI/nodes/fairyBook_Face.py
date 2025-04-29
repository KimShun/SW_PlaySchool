import os
import random
import sys
from typing import Sequence, Mapping, Any, Union
import torch


def get_value_at_index(obj: Union[Sequence, Mapping], index: int) -> Any:
    """Returns the value at the given index of a sequence or mapping.

    If the object is a sequence (like list or string), returns the value at the given index.
    If the object is a mapping (like a dictionary), returns the value at the index-th key.

    Some return a dictionary, in these cases, we look for the "results" key

    Args:
        obj (Union[Sequence, Mapping]): The object to retrieve the value from.
        index (int): The index of the value to retrieve.

    Returns:
        Any: The value at the given index.

    Raises:
        IndexError: If the index is out of bounds for the object and the object is not a mapping.
    """
    try:
        return obj[index]
    except KeyError:
        return obj["result"][index]


def find_path(name: str, path: str = None) -> str:
    """
    Recursively looks at parent folders starting from the given path until it finds the given name.
    Returns the path as a Path object if found, or None otherwise.
    """
    # If no path is given, use the current working directory
    if path is None:
        path = os.getcwd()

    # Check if the current directory contains the name
    if name in os.listdir(path):
        path_name = os.path.join(path, name)
        print(f"{name} found: {path_name}")
        return path_name

    # Get the parent directory
    parent_directory = os.path.dirname(path)

    # If the parent directory is the same as the current directory, we've reached the root and stop the search
    if parent_directory == path:
        return None

    # Recursively call the function with the parent directory
    return find_path(name, parent_directory)


def add_comfyui_directory_to_sys_path() -> None:
    """
    Add 'ComfyUI' to the sys.path
    """
    comfyui_path = find_path("ComfyUI")
    if comfyui_path is not None and os.path.isdir(comfyui_path):
        sys.path.append(comfyui_path)
        print(f"'{comfyui_path}' added to sys.path")


def add_extra_model_paths() -> None:
    """
    Parse the optional extra_model_paths.yaml file and add the parsed paths to the sys.path.
    """
    try:
        from main import load_extra_path_config
    except ImportError:
        print(
            "Could not import load_extra_path_config from main.py. Looking in utils.extra_config instead."
        )
        from utils.extra_config import load_extra_path_config

    extra_model_paths = find_path("extra_model_paths.yaml")

    if extra_model_paths is not None:
        load_extra_path_config(extra_model_paths)
    else:
        print("Could not find the extra_model_paths config file.")


add_comfyui_directory_to_sys_path()
add_extra_model_paths()


def import_custom_nodes() -> None:
    """Find all custom nodes in the custom_nodes folder and add those node objects to NODE_CLASS_MAPPINGS

    This function sets up a new asyncio event loop, initializes the PromptServer,
    creates a PromptQueue, and initializes the custom nodes.
    """
    import asyncio
    import execution
    from nodes import init_extra_nodes
    import server

    # Creating a new event loop and setting it as the default loop
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    # Creating an instance of PromptServer with the loop
    server_instance = server.PromptServer(loop)
    execution.PromptQueue(server_instance)

    # Initializing custom nodes
    init_extra_nodes()


from nodes import CLIPVisionLoader, SaveImage, LoadImage, NODE_CLASS_MAPPINGS


def main(positive_prompt, negative_prompt, userUID, img):
    import_custom_nodes()
    with torch.inference_mode():
        lora_stacker = NODE_CLASS_MAPPINGS["LoRA Stacker"]()
        lora_stacker_1 = lora_stacker.lora_stacker(
            input_mode="simple",
            lora_count=2,
            lora_name_1="SD1.5/Minute_Sketch_v2_R-16.safetensors",
            lora_wt_1=0.6,
            model_str_1=1,
            clip_str_1=1,
            lora_name_2="SD1.5/watercolor.safetensors",
            lora_wt_2=0.6,
            model_str_2=0.6,
            clip_str_2=1,
        )

        cr_sd15_aspect_ratio = NODE_CLASS_MAPPINGS["CR SD1.5 Aspect Ratio"]()
        cr_sd15_aspect_ratio_3 = cr_sd15_aspect_ratio.Aspect_Ratio(
            width=512,
            height=512,
            aspect_ratio="3:2 landscape 768x512",
            swap_dimensions="Off",
            upscale_factor=1,
            batch_size=1,
        )

        upscalemodelloader = NODE_CLASS_MAPPINGS["UpscaleModelLoader"]()
        upscalemodelloader_8 = upscalemodelloader.load_model(
            model_name="RealESRGAN_x2.pth"
        )

        loadimage = LoadImage()
        loadimage_10 = loadimage.load_image(image=img)

        clipvisionloader = CLIPVisionLoader()
        clipvisionloader_20 = clipvisionloader.load_clip(
            clip_name="CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
        )

        samloader = NODE_CLASS_MAPPINGS["SAMLoader"]()
        samloader_22 = samloader.load_model(
            model_name="sam_vit_b_01ec64.pth", device_mode="AUTO"
        )

        ultralyticsdetectorprovider = NODE_CLASS_MAPPINGS[
            "UltralyticsDetectorProvider"
        ]()
        ultralyticsdetectorprovider_23 = ultralyticsdetectorprovider.doit(
            model_name="bbox/face_yolov8m.pt"
        )

        ultralyticsdetectorprovider_24 = ultralyticsdetectorprovider.doit(
            model_name="segm/person_yolov8m-seg.pt"
        )

        bjornulf_writetext = NODE_CLASS_MAPPINGS["Bjornulf_WriteText"]()
        bjornulf_writetext_45 = bjornulf_writetext.write_text(
            text=positive_prompt
        )

        bjornulf_writetext_46 = bjornulf_writetext.write_text(
            text=negative_prompt
        )

        bjornulf_loopalllines = NODE_CLASS_MAPPINGS["Bjornulf_LoopAllLines"]()
        efficient_loader = NODE_CLASS_MAPPINGS["Efficient Loader"]()
        ksampler_efficient = NODE_CLASS_MAPPINGS["KSampler (Efficient)"]()
        imageupscalewithmodel = NODE_CLASS_MAPPINGS["ImageUpscaleWithModel"]()
        ipadapterunifiedloaderfaceid = NODE_CLASS_MAPPINGS[
            "IPAdapterUnifiedLoaderFaceID"
        ]()
        ipadapterfaceid = NODE_CLASS_MAPPINGS["IPAdapterFaceID"]()
        facedetailer = NODE_CLASS_MAPPINGS["FaceDetailer"]()
        saveimage = SaveImage()

        for q in range(1):
            bjornulf_loopalllines_43 = bjornulf_loopalllines.all_lines(
                text=get_value_at_index(bjornulf_writetext_45, 0)
            )

            bjornulf_loopalllines_47 = bjornulf_loopalllines.all_lines(
                text=get_value_at_index(bjornulf_writetext_46, 0)
            )

            efficient_loader_2 = efficient_loader.efficientloader(
                ckpt_name="SD1.5/disneyPixarCartoon_v10.safetensors",
                vae_name="SD1.5/YOZORA.vae.pt",
                clip_skip=-1,
                lora_name="None",
                lora_model_strength=1,
                lora_clip_strength=1,
                positive=get_value_at_index(bjornulf_loopalllines_43, 0),
                negative=get_value_at_index(bjornulf_loopalllines_47, 0),
                token_normalization="none",
                weight_interpretation="comfy",
                empty_latent_width=get_value_at_index(cr_sd15_aspect_ratio_3, 0),
                empty_latent_height=get_value_at_index(cr_sd15_aspect_ratio_3, 1),
                batch_size=get_value_at_index(cr_sd15_aspect_ratio_3, 3),
                lora_stack=get_value_at_index(lora_stacker_1, 0),
            )

            ksampler_efficient_4 = ksampler_efficient.sample(
                seed=random.randint(1, 2**64),
                steps=30,
                cfg=7,
                sampler_name="euler",
                scheduler="normal",
                denoise=1,
                preview_method="auto",
                vae_decode="true",
                model=get_value_at_index(efficient_loader_2, 0),
                positive=get_value_at_index(efficient_loader_2, 1),
                negative=get_value_at_index(efficient_loader_2, 2),
                latent_image=get_value_at_index(efficient_loader_2, 3),
                optional_vae=get_value_at_index(efficient_loader_2, 4),
            )

            imageupscalewithmodel_9 = imageupscalewithmodel.upscale(
                upscale_model=get_value_at_index(upscalemodelloader_8, 0),
                image=get_value_at_index(ksampler_efficient_4, 5),
            )

            ipadapterunifiedloaderfaceid_19 = ipadapterunifiedloaderfaceid.load_models(
                preset="FACEID PLUS V2",
                lora_strength=0.6,
                provider="CPU",
                model=get_value_at_index(ksampler_efficient_4, 0),
            )

            ipadapterfaceid_11 = ipadapterfaceid.apply_ipadapter(
                weight=1.0000000000000002,
                weight_faceidv2=1,
                weight_type="linear",
                combine_embeds="concat",
                start_at=0,
                end_at=1,
                embeds_scaling="V only",
                model=get_value_at_index(ipadapterunifiedloaderfaceid_19, 0),
                ipadapter=get_value_at_index(ipadapterunifiedloaderfaceid_19, 1),
                image=get_value_at_index(loadimage_10, 0),
                clip_vision=get_value_at_index(clipvisionloader_20, 0),
            )

            facedetailer_21 = facedetailer.doit(
                guide_size=512,
                guide_size_for=True,
                max_size=1024,
                seed=random.randint(1, 2**64),
                steps=20,
                cfg=8,
                sampler_name="euler",
                scheduler="normal",
                denoise=0.5,
                feather=5,
                noise_mask=True,
                force_inpaint=True,
                bbox_threshold=0.5,
                bbox_dilation=10,
                bbox_crop_factor=3,
                sam_detection_hint="center-1",
                sam_dilation=0,
                sam_threshold=0.93,
                sam_bbox_expansion=0,
                sam_mask_hint_threshold=0.7,
                sam_mask_hint_use_negative="False",
                drop_size=10,
                wildcard="",
                cycle=1,
                inpaint_model=False,
                noise_mask_feather=20,
                tiled_encode=False,
                tiled_decode=False,
                image=get_value_at_index(imageupscalewithmodel_9, 0),
                model=get_value_at_index(ipadapterfaceid_11, 0),
                clip=get_value_at_index(efficient_loader_2, 5),
                vae=get_value_at_index(ksampler_efficient_4, 4),
                positive=get_value_at_index(ksampler_efficient_4, 1),
                negative=get_value_at_index(ksampler_efficient_4, 2),
                bbox_detector=get_value_at_index(ultralyticsdetectorprovider_23, 0),
                sam_model_opt=get_value_at_index(samloader_22, 0),
                segm_detector_opt=get_value_at_index(ultralyticsdetectorprovider_24, 1),
            )

            saveimage_26 = saveimage.save_images(
                filename_prefix=f"fairyTale_{userUID}", 
                images=get_value_at_index(facedetailer_21, 0)
            )


if __name__ == "__main__":
    main()
