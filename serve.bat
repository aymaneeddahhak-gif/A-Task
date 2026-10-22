@echo off
echo ============================================================
echo   Serving A-Task Web Production Build on http://localhost:4000
echo ============================================================
python -m http.server 4000 --directory build/web
