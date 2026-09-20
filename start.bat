@echo off
setlocal EnableExtensions
title Top-250 Tracker
cd /d "%~dp0"

rem --- Кириллица в консоли ---
chcp 65001 >nul 2>&1

set "APP_NAME=Top-250 Tracker"
set "HOST=127.0.0.1"
set "PORT=5173"
set "URL=http://%HOST%:%PORT%"

echo.
echo   ============================================
echo     %APP_NAME%
echo     Локальный трекер Top-250 Кинопоиска
echo   ============================================
echo.

rem --- 1. Проверка Node.js ---
where node >nul 2>&1
if errorlevel 1 goto :no_node

for /f "delims=" %%v in ('node -v') do set "NODE_VERSION=%%v"
echo   [ok] Node.js %NODE_VERSION%

rem --- 2. Проверка npm ---
where npm >nul 2>&1
if errorlevel 1 goto :no_npm

rem --- 3. Установка зависимостей, если node_modules отсутствует ---
if not exist "node_modules\" goto :install
if not exist "node_modules\vite\" goto :install
goto :run

:install
echo.
echo   Зависимости не найдены. Устанавливаю (npm install)...
echo   Это может занять 1-3 минуты при первом запуске.
echo.
call npm install --no-audit --no-fund
if errorlevel 1 goto :install_failed
echo.
echo   [ok] Зависимости установлены.

:run
echo.
echo   --------------------------------------------
echo   %APP_NAME%
echo   Local: %URL%
echo   --------------------------------------------
echo.
echo   Остановка сервера: Ctrl+C
echo.

rem --- 4. Браузер откроется, когда Vite поднимет сервер ---
start "" cmd /c "timeout /t 4 /nobreak >nul & start "" %URL%"

call npm run dev -- --host %HOST% --port %PORT%
goto :eof

:no_node
echo   [Ошибка] Node.js не найден в PATH.
echo.
echo   Установите Node.js LTS ^(версия 18 или новее^):
echo       https://nodejs.org/ru/download
echo.
echo   После установки перезапустите этот файл.
echo.
pause
exit /b 1

:no_npm
echo   [Ошибка] npm не найден. Обычно он ставится вместе с Node.js.
echo   Переустановите Node.js: https://nodejs.org/ru/download
echo.
pause
exit /b 1

:install_failed
echo.
echo   [Ошибка] npm install завершился с ошибкой.
echo   Проверьте интернет-соединение и повторите запуск.
echo.
pause
exit /b 1
