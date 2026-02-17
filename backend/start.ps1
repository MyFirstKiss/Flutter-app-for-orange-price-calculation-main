# 🍊 Orange Calculator - Backend Startup Script (Windows)
# รันสคริปต์นี้ก่อนเปิดแอป Flutter
# ใช้: .\start.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  🍊 Orange Calculator Backend" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# 1. ตรวจสอบว่ามี Python ไหม
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "❌ ไม่พบ Python! กรุณาติดตั้ง Python 3.11+ ก่อน" -ForegroundColor Red
    Write-Host "   https://www.python.org/downloads/" -ForegroundColor Gray
    exit 1
}
Write-Host "✅ Python พร้อมใช้งาน" -ForegroundColor Green

# 2. ไปที่ backend folder
Set-Location $PSScriptRoot

# 3. ติดตั้ง dependencies
Write-Host "📦 ติดตั้ง Python packages..." -ForegroundColor Cyan
pip install -r requirements.txt -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ติดตั้ง packages ล้มเหลว ตรวจสอบ requirements.txt" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dependencies พร้อมแล้ว" -ForegroundColor Green

# 4. Kill process เก่าบน port 8001 ถ้ามี
$proc = Get-NetTCPConnection -LocalPort 8001 -ErrorAction SilentlyContinue | Select-Object -First 1
if ($proc) {
    Stop-Process -Id $proc.OwningProcess -Force
    Write-Host "⚡ ปิด process เก่าบน port 8001 แล้ว" -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}

# 5. Seed database ถ้าว่างเปล่า
Write-Host "🗄️  ตรวจสอบฐานข้อมูล..." -ForegroundColor Cyan
python seed_db.py

# 6. Start server
Write-Host ""
Write-Host "🚀 กำลังเริ่ม server ที่ http://localhost:8001" -ForegroundColor Green
Write-Host "   กด Ctrl+C เพื่อหยุด" -ForegroundColor Gray
Write-Host ""
python main.py
