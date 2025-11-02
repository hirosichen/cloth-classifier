#!/bin/bash
# WSL 啟動腳本 - 服飾分類系統

set -e  # Exit on error

echo "========================================"
echo "服飾分類系統 - WSL 啟動腳本"
echo "========================================"
echo ""

# 檢查虛擬環境
if [ ! -d "venv_wsl" ]; then
    echo "錯誤：找不到虛擬環境！"
    echo "請先執行安裝腳本"
    exit 1
fi

# 啟動虛擬環境
echo "啟動虛擬環境..."
source venv_wsl/bin/activate

# 檢查套件是否已安裝
echo "檢查依賴套件..."
python3 -c "import torch; import gradio; import transformers" 2>/dev/null || {
    echo "安裝必要套件..."
    pip install -r requirements.txt
}

# 啟動 Gradio 應用
echo ""
echo "========================================  "
echo "啟動 Gradio 服飾分類系統..."
echo "界面將在 http://localhost:7860 啟動"
echo "按 Ctrl+C 停止程式"
echo "========================================"
echo ""

python3 app.py
