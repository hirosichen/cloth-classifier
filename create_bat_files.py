"""
創建 Windows 批次檔（使用正確的 CRLF 換行符號）
"""

def create_bat_file(filename, content):
    """創建具有 CRLF 換行的批次檔"""
    # 將 LF 換成 CRLF
    content_crlf = content.replace('\n', '\r\n')
    with open(filename, 'w', encoding='ascii', newline='') as f:
        f.write(content_crlf)
    print(f"Created: {filename}")

# 1_install.bat
install_bat = """@echo off
echo ========================================
echo Installing Python Packages
echo ========================================
echo.

REM Check Python installation
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found! Please install Python 3.8 or newer
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/3] Upgrading pip...
python -m pip install --upgrade pip

echo.
echo [2/3] Installing PyTorch GPU version...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

echo.
echo [3/3] Installing other dependencies...
pip install -r requirements.txt

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Next: Run 2_download_model.bat
pause
"""

# 2_download_model.bat
download_bat = """@echo off
echo ========================================
echo Downloading Qwen3-VL-8B Model
echo ========================================
echo.
echo This will download about 16GB of model files
echo Please ensure you have enough disk space
echo.
echo Model will be saved to: qwen3_vl_model
echo.
pause

echo.
echo Downloading model...
python download_model.py

if errorlevel 1 (
    echo.
    echo [ERROR] Model download failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Model Download Complete!
echo ========================================
echo.
echo Next: Run 3_run_app.bat
pause
"""

# 3_run_app.bat
run_bat = """@echo off
echo ========================================
echo Starting Clothing Classification System
echo ========================================
echo.
echo Starting Gradio interface...
echo Browser will open automatically
echo.
echo Press Ctrl+C to stop the program
echo ========================================
echo.

python app.py

if errorlevel 1 (
    echo.
    echo [ERROR] Program failed to start!
    echo Please check:
    echo 1. Run 1_install.bat to install packages
    echo 2. Run 2_download_model.bat to download model
    pause
    exit /b 1
)
"""

if __name__ == "__main__":
    create_bat_file("1_install.bat", install_bat)
    create_bat_file("2_download_model.bat", download_bat)
    create_bat_file("3_run_app.bat", run_bat)
    print("\nAll batch files created successfully!")
    print("Files have correct Windows CRLF line endings")
