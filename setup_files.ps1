# PowerShell script to create batch files with correct encoding

$check = @'
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
'@

$install = @'
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
'@

$download = @'
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
'@

$run = @'
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
'@

# Write files with Windows encoding
$check | Out-File -FilePath "0_check_python.bat" -Encoding ASCII
$install | Out-File -FilePath "1_install.bat" -Encoding ASCII
$download | Out-File -FilePath "2_download_model.bat" -Encoding ASCII
$run | Out-File -FilePath "3_run_app.bat" -Encoding ASCII

Write-Host "Batch files created successfully!"
Write-Host "Created: 0_check_python.bat"
Write-Host "Created: 1_install.bat"
Write-Host "Created: 2_download_model.bat"
Write-Host "Created: 3_run_app.bat"
