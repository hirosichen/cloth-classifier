@echo off
echo ========================================
echo Installing Python Packages
echo ========================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    pause
    exit /b 1
)

echo [1/3] Upgrading pip...
python -m pip install --upgrade pip

echo.
echo [2/3] Installing PyTorch...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

echo.
echo [3/3] Installing dependencies...
pip install -r requirements.txt

echo.
echo Installation Complete!
echo Next: Run 2_download_model.bat
pause
