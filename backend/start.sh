#!/bin/bash
# 🍊 Orange Calculator - Backend Startup Script (macOS/Linux)
# รันสคริปต์นี้ก่อนเปิดแอป Flutter
# ใช้: bash start.sh

echo ""
echo "========================================"
echo "  🍊 Orange Calculator Backend"
echo "========================================"
echo ""

# 1. ตรวจสอบว่ามี Python ไหม
if ! command -v python3 &> /dev/null; then
    echo "❌ ไม่พบ Python! กรุณาติดตั้ง Python 3.11+ ก่อน"
    echo "   https://www.python.org/downloads/"
    exit 1
fi
echo "✅ Python พร้อมใช้งาน"

# 2. ไปที่ backend folder
cd "$(dirname "$0")"

# 3. ติดตั้ง dependencies
echo "📦 ติดตั้ง Python packages..."
pip3 install -r requirements.txt -q
if [ $? -ne 0 ]; then
    echo "❌ ติดตั้ง packages ล้มเหลว ตรวจสอบ requirements.txt"
    exit 1
fi
echo "✅ Dependencies พร้อมแล้ว"

# 4. Kill process เก่าบน port 8001 ถ้ามี
PID=$(lsof -ti:8001)
if [ -n "$PID" ]; then
    kill -9 $PID
    echo "⚡ ปิด process เก่าบน port 8001 แล้ว"
    sleep 1
fi

# 5. Seed database ถ้าว่างเปล่า
echo "🗄️  ตรวจสอบฐานข้อมูล..."
python3 seed_db.py

# 6. Start server
echo ""
echo "🚀 กำลังเริ่ม server ที่ http://localhost:8001"
echo "   กด Ctrl+C เพื่อหยุด"
echo ""
python3 main.py
