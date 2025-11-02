# Alternative model download using PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Downloading Qwen3-VL-8B Model" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will download about 16GB of model files" -ForegroundColor Yellow
Write-Host "Model will be saved to: qwen3_vl_model" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Continue? (Y/N)"

if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Download cancelled" -ForegroundColor Yellow
    exit 0
}

# Find Python
$pythonCmd = $null
$pythonCommands = @("python", "python3", "py")

foreach ($cmd in $pythonCommands) {
    try {
        $version = & $cmd --version 2>&1
        if ($version -match "Python") {
            $pythonCmd = $cmd
            break
        }
    }
    catch {
        continue
    }
}

if (-not $pythonCmd) {
    Write-Host "[ERROR] Python not found!" -ForegroundColor Red
    Write-Host "Please run alternative_install.ps1 first" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Downloading model..." -ForegroundColor Cyan
& $pythonCmd download_model.py

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Model Download Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next: Run alternative_run.ps1 to start the app" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "[ERROR] Download failed!" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"
