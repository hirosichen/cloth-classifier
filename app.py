import gradio as gr
import torch
from transformers import AutoModelForVision2Seq, AutoProcessor
from qwen_vl_utils import process_vision_info
from PIL import Image
import os

# 服飾分類提示詞
CLOTHING_CATEGORIES = """這個屬於何者：

洋裝類 (Dresses):
- A Line Dresses
- Above The Knee Dresses
- Babydoll Dresses
- Below The Knee Dresses
- Bishop Sleeve Dresses
- Bodycon Dresses
- Bubble Hem Dress
- Camisole Dresses
- Cowl Neck Dresses
- Flare Sleeve Dresses
- Halter-Neck Dresses
- Midi Dresses
- Mini Dresses
- Mock Neck Dresses
- Off-Shoulder Dresses
- Puff Sleeve Dresses
- Scoop Neck Dresses
- Shift Dresses
- Shirt-Collar Dresses
- Square-Neck Dresses
- Strapless Dresses
- Sweetheart Dresses
- Tube Dresses

裙子類 (Skirts):
- Below The Knee Skirts
- Bubble Hem Skirt
- High-Waisted Skirts
- Knife Pleated Skirts
- Midi Skirts
- Mini Skirts
- Pleated Skirts
- Short Skirts
- Tube Skirts
- Wrapped Skirts

褲子類 (Pants):
- Ankle-Length Pants
- Baggy Pants
- Below The Knee Pants
- Bootcut Pants
- Cargo Pants
- Fit and Flare Pants
- Flare Pants
- Full-Length Pants
- High Waist Pants
- Mid-Calf Length Pants
- Palazzo Pants
- Skinny Pants
- Slim Pants
- Sweat Pants
- Tailored Pants
- Track Pants
- Wide-Leg Pants

短褲類 (Shorts):
- Above The Knee Shorts
- Cycling Shorts
- High Waist Shorts
- Mini Cycling Shorts
- Running Shorts
- Straight Shorts
- Sweat Shorts
- Tailored Shorts

上衣類 (Tops):
- Blouses
- Camisole Tops
- Cowl Neck Tops
- Cropped Tops
- Halter Neck Tops
- Mock Neck Tops
- Muscle Tank Top
- Off-Shoulder Tops
- Oversized Tops
- Poloshirts
- Scoop Neck Tops
- Shirts
- Sports Bras
- Sweatshirts
- T-Shirts
- Tank Sleeve Tops
- Turtle Neck Tops

外套類 (Outerwear):
- Biker Jackets
- Bomber Jackets
- Boxy Jackets
- Cardigans
- Denim Jackets
- Fitted Outerwear
- Hip Length Outerwear
- Jackets
- Maxi-Length Outerwear
- Mid Length Outerwear
- Oversized Outerwear
- Parka Coats
- Shearling Coats
- Trench Coats
- Varsity Jackets
- Windbreakers

褲襪類 (Leggings):
- Capri Legging
- Flare Legging
- Joggers
- Leggings"""

# 全域變數儲存模型和處理器
model = None
processor = None

def load_model():
    """載入 Qwen3 VL 8B 模型"""
    global model, processor

    print("正在載入 Qwen3 VL 8B 模型...")
    model_name = "Qwen/Qwen3-VL-8B-Instruct"  # 使用 Qwen3-VL-8B-Instruct 模型
    cache_dir = "./qwen3_vl_model"  # 使用本地快取目錄

    # 載入模型
    model = AutoModelForVision2Seq.from_pretrained(
        model_name,
        torch_dtype=torch.float16,
        device_map="auto",
        trust_remote_code=True,
        cache_dir=cache_dir  # 使用本地快取
    )

    # 載入處理器
    processor = AutoProcessor.from_pretrained(
        model_name,
        trust_remote_code=True,
        cache_dir=cache_dir  # 使用本地快取
    )

    print("模型載入完成！")
    return "模型載入成功"

def classify_images(images):
    """分類多張圖片"""
    global model, processor

    if model is None or processor is None:
        return "請先載入模型！"

    if not images:
        return "請上傳至少一張圖片！"

    results = []

    for idx, image_data in enumerate(images, 1):
        try:
            # 處理 Gradio Gallery 的不同返回格式
            if isinstance(image_data, tuple):
                # Gallery 返回 (image, caption) 格式
                image = image_data[0]
            elif isinstance(image_data, dict):
                # Gallery 返回字典格式
                image = image_data.get('name') or image_data.get('path') or image_data
            else:
                # 直接是 PIL Image
                image = image_data

            # 如果是路徑字符串，載入圖片
            if isinstance(image, str):
                image = Image.open(image)

            # 準備訊息格式
            messages = [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "image",
                            "image": image,
                        },
                        {"type": "text", "text": CLOTHING_CATEGORIES},
                    ],
                }
            ]

            # 準備輸入
            text = processor.apply_chat_template(
                messages, tokenize=False, add_generation_prompt=True
            )

            image_inputs, video_inputs = process_vision_info(messages)

            inputs = processor(
                text=[text],
                images=image_inputs,
                videos=video_inputs,
                padding=True,
                return_tensors="pt",
            )
            inputs = inputs.to("cuda" if torch.cuda.is_available() else "cpu")

            # 生成預測
            with torch.no_grad():
                generated_ids = model.generate(
                    **inputs,
                    max_new_tokens=128
                )

            generated_ids_trimmed = [
                out_ids[len(in_ids):] for in_ids, out_ids in zip(inputs.input_ids, generated_ids)
            ]

            output_text = processor.batch_decode(
                generated_ids_trimmed,
                skip_special_tokens=True,
                clean_up_tokenization_spaces=False
            )

            results.append(f"圖片 {idx}: {output_text[0]}")

        except Exception as e:
            results.append(f"圖片 {idx} 處理失敗: {str(e)}")

    return "\n\n".join(results)

# 建立 Gradio 界面
def create_interface():
    with gr.Blocks(title="服飾分類系統 - Qwen3 VL 8B") as demo:
        gr.Markdown("# 服飾分類系統")
        gr.Markdown("使用 Qwen3 VL 8B 模型進行服飾圖片分類")

        with gr.Row():
            with gr.Column():
                load_btn = gr.Button("載入模型", variant="primary")
                load_status = gr.Textbox(label="模型狀態", interactive=False)

        with gr.Row():
            with gr.Column():
                image_input = gr.Gallery(label="上傳圖片（可多選）", type="pil")
                classify_btn = gr.Button("開始分類", variant="primary")

            with gr.Column():
                output = gr.Textbox(label="分類結果", lines=20, interactive=False)

        # 按鈕事件
        load_btn.click(fn=load_model, outputs=load_status)
        classify_btn.click(fn=classify_images, inputs=image_input, outputs=output)

        gr.Markdown("""
        ### 使用說明
        1. 點擊「載入模型」按鈕等待模型載入完成
        2. 上傳一張或多張服飾圖片
        3. 點擊「開始分類」進行分類
        4. 查看分類結果
        """)

    return demo

if __name__ == "__main__":
    demo = create_interface()
    demo.launch(share=False, server_name="0.0.0.0", server_port=7860)
