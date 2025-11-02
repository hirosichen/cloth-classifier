# Alternative installation using PowerShell
# Run this if batch files cannot find Python

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Alternative Python Package Installation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Try to find Python
$pythonCmd = $null

# Check common Python commands
$pythonCommands = @("python", "python3", "py")

foreach ($cmd in $pythonCommands) {
    try {
        $version = & $cmd --version 2>&1
        if ($version -match "Python") {
            $pythonCmd = $cmd
            Write-Host "[OK] Found Python using command: $cmd" -ForegroundColor Green
            Write-Host "Version: $version" -ForegroundColor Green
            break
        }
    }
    catch {
        continue
    }
}

if (-not $pythonCmd) {
    Write-Host "[ERROR] Python not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Python from:" -ForegroundColor Yellow
    Write-Host "https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or install from Microsoft Store:" -ForegroundColor Yellow
    Write-Host "1. Open Microsoft Store" -ForegroundColor Yellow
    Write-Host "2. Search for 'Python 3.10' or newer" -ForegroundColor Yellow
    Write-Host "3. Install it" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "[1/3] Upgrading pip..." -ForegroundColor Cyan
& $pythonCmd -m pip install --upgrade pip

Write-Host ""
Write-Host "[2/3] Installing PyTorch (GPU version)..." -ForegroundColor Cyan
Write-Host "If you don't have NVIDIA GPU, this will still work but use CPU" -ForegroundColor Yellow
& $pythonCmd -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

Write-Host ""
Write-Host "[3/3] Installing other dependencies..." -ForegroundColor Cyan
& $pythonCmd -m pip install -r requirements.txt

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next step: Run download_model.ps1 to download the model" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
