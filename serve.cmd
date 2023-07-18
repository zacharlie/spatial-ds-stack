@echo off
cd %~dp0docs
cmd /k "%USERPROFILE%/mambaforge/python.exe -m http.server --bind 127.0.0.1 3000"
pause