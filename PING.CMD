@echo off
chcp 1251 >nul
SetLocal EnableExtensions

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Запрос прав администратора...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

CLS
SET cloud=1.1.1.1
SET Ya=77.88.8.8

ECHO ################################################################################################
ECHO ###                  ПИНГЕР - УТИЛИТА ДЛЯ ТЕХ КОМУ ВЛОМ ПИНГОВАТЬ РУЧКАМИ                    ###
ECHO ################################################################################################
ECHO.
ECHO Выбери сайт для пинга: Yandex (%Ya%) / Cloudflare (%cloud%) / СВОЙ ДОМЕН
ECHO.
set /p site="Введи YA (или 1) для Yandex, CL (или 2) для Cloudflare, или введи свой домен: "

:: Убираем кавычки, если пользователь их ввел
set site=%site:"=%

if /i "%site%"=="YA" goto yandex
if /i "%site%"=="1" goto yandex
if /i "%site%"=="CL" goto cloudflare
if /i "%site%"=="2" goto cloudflare

:: Если ни одно из условий не сработало - считаем это своим доменом
echo.
echo Пингую свой домен: %site%
ping %site%
echo.
tracert %site%
goto end

:yandex
echo.
echo Пингую Yandex (%Ya%)
ping %Ya%
echo.
tracert %Ya%
goto end

:cloudflare
echo.
echo Пингую Cloudflare (%cloud%)
ping %cloud%
echo.
tracert %cloud%
goto end

:end
pause