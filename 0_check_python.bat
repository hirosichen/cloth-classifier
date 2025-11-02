@echo off
echo ========================================
echo Checking Python Installation
echo ========================================
echo.

where python >nul 2>&1
if errorlevel 1 (
    echo [X] Python not found
    echo.
    echo Install Python from: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
) else (
    echo [OK] Python found!
    python --version
    echo.
    where python
    echo.
    python -m pip --version
)

echo.
pause
