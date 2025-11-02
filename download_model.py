"""
下載 Qwen3 VL 模型到本地
"""
import os
from transformers import Qwen2VLForConditionalGeneration, AutoProcessor

def download_model():
    # 設定模型儲存路徑
    model_dir = "./qwen3_vl_model"

    # 使用 Qwen3-VL-8B-Instruct 模型
    model_name = "Qwen/Qwen3-VL-8B-Instruct"

    print(f"開始下載模型: {model_name}")
    print(f"儲存位置: {model_dir}")

    # 下載並儲存模型
    print("\n下載模型權重...")
    model = Qwen2VLForConditionalGeneration.from_pretrained(
        model_name,
        trust_remote_code=True,
        cache_dir=model_dir
    )

    # 下載並儲存處理器
    print("\n下載處理器...")
    processor = AutoProcessor.from_pretrained(
        model_name,
        trust_remote_code=True,
        cache_dir=model_dir
    )

    print(f"\n✓ 模型下載完成！儲存於: {os.path.abspath(model_dir)}")
    print("\n注意：實際模型檔案會儲存在 cache_dir 的子目錄中")
    print("下次執行 app.py 時會自動使用快取的模型")

if __name__ == "__main__":
    download_model()
