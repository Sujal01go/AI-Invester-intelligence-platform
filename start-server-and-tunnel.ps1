# ==============================================================================
# One-Click Global Deployment Launcher (From Your Laptop)
# Project: InvestIntel AI
# ==============================================================================

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  InvestIntel AI - Laptop Server & Global HTTPS Tunnel    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Stop any existing instances
Get-Process -Name python* -ErrorAction SilentlyContinue | Where-Object { $_.Path -match "AI-investor" } | Stop-Process -Force -ErrorAction SilentlyContinue

# 2. Start Uvicorn background server
Write-Host "[1/2] Starting local FastAPI server on http://localhost:8000..." -ForegroundColor Yellow
$serverProcess = Start-Process -FilePath ".\.venv\Scripts\python.exe" -ArgumentList "-m uvicorn app:app --host 0.0.0.0 --port 8000" -PassThru -NoNewWindow

Start-Sleep -Seconds 4

# 3. Launch Cloudflare Tunnel
Write-Host "[2/2] Connecting to Cloudflare Global Edge Network..." -ForegroundColor Green
Write-Host "      Your public HTTPS URL will appear below:" -ForegroundColor Gray
Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray

& "C:\Users\LENOVO\bin\cloudflared.exe" tunnel --url http://localhost:8000
