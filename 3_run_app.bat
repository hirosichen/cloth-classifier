@echo off
echo ========================================
echo Starting Clothing Classifier
echo ========================================
echo.
echo Press Ctrl+C to stop
echo.

python app.py

if errorlevel 1 (
    echo [ERROR] Failed to start!
    pause
    exit /b 1
)
