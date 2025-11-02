@echo off
echo ======================================
echo Quick Start - Use Existing Environment
echo ======================================
echo.
echo This will use the gradio_app.py from parent directory
echo.

cd /d D:\train
wsl bash -c "cd /mnt/d/train && python3 gradio_app.py"
