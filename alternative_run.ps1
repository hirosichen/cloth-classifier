# Alternative run using PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Clothing Classification System" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Find Python
$pythonCmd = $null
$pythonCommands = @("python", "python3", "py")

foreach ($cmd in $pythonCommands) {
    try {
        $version = & $cmd --version 2>&1
        if ($version -match "Python") {
            $pythonCmd = $cmd
            Write-Host "Using: $cmd" -ForegroundColor Green
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
    Write-Host "Please run alternative_install.ps1 first" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Starting Gradio interface..." -ForegroundColor Cyan
Write-Host "Browser will open automatically" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the program" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

& $pythonCmd app.py

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Program failed to start!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check:" -ForegroundColor Yellow
    Write-Host "1. Run alternative_install.ps1 to install packages" -ForegroundColor Yellow
    Write-Host "2. Run alternative_download.ps1 to download model" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
}
