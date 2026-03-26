@echo off
set ADB="ISI_PATH_ADB_DISINI"
set PKG=com.example.finance
set LOCAL_PATH=%~dp0finance_app.db

echo [1/3] Menutup aplikasi (Force Stop)...
%ADB% shell "run-as %PKG% am force-stop %PKG%"

echo [2/3] Mengambil database terbaru dari HP...
%ADB% exec-out "run-as %PKG% cat databases/finance_app.db" > "%LOCAL_PATH%"

echo [3/3] Selesai! Data di VS Code sudah diperbarui.