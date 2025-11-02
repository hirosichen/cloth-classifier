@echo off
echo ========================================
echo Downloading Qwen3-VL-8B Model
echo ========================================
echo.
echo This downloads about 16GB
echo Model saved to: qwen3_vl_model
echo.
pause

python download_model.py

if errorlevel 1 (
    echo [ERROR] Download failed!
    pause
    exit /b 1
)

echo.
echo Download Complete!
echo Next: Run 3_run_app.bat
pause
