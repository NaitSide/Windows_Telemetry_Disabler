@echo off
chcp 65001 >nul

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo =========================================================
    echo    [ОШИБКА] Требуются права администратора!
    echo =========================================================
    echo.
    echo    Запустите скрипт правой кнопкой мыши
    echo    -^> "Запуск от имени администратора"
    echo.
    echo =========================================================
    echo.
    pause
    exit /b
)

:MENU
cls
echo =========================================================
echo   Отключение телеметрии Windows
echo   NaitSide Privacy Tools
echo =========================================================
echo.
echo Выберите действие:
echo.
echo  [1] - Применить настройки приватности
echo  [2] - Проверить текущие настройки
echo  [0] - Выход
echo.
echo =========================================================
echo    GitHub: github.com/NaitSide
echo =========================================================
echo.
set /p choice="Ваш выбор: "

if "%choice%"=="1" goto APPLY
if "%choice%"=="2" goto CHECK
if "%choice%"=="0" exit
goto MENU

:APPLY
cls
echo ============================================
echo   ПРИМЕНЕНИЕ НАСТРОЕК ПРИВАТНОСТИ
echo ============================================
echo.
echo Объяснение каждого блока:
echo.
echo 1. Телеметрия
echo    Что делает: Останавливает службы сбора данных
echo    Зачем: Windows не отправляет информацию о том, как ты её используешь
echo.
echo 2. Реклама
echo    Что делает: Убирает рекламу из меню Пуск и экрана блокировки
echo    Зачем: Чтобы не видеть "Попробуйте Office 365!" и подобное
echo.
echo 3. Сбор данных ввода
echo    Что делает: Отключает сбор того, что ты печатаешь
echo    Зачем: Windows не анализирует твой набор текста и рукописный ввод
echo.
echo 4. Отчёты об ошибках
echo    Что делает: Не отправляет отчёты о сбоях программ
echo    Зачем: При зависании программ данные не уходят в Microsoft
echo.
echo 5. Программа улучшения качества (CEIP)
echo    Что делает: Отключает программу улучшения качества
echo    Зачем: Не отправляет статистику использования функций Windows
echo.
echo 6. Лента активности (Activity Feed)
echo    Что делает: Отключает хронологию действий
echo    Зачем: Windows не записывает что ты открывал и когда
echo.
echo 7. Местоположение
echo    Что делает: Отключает GPS и определение местоположения
echo    Зачем: Приложения не узнают где ты находишься
echo.
echo 8. Рекламный ID
echo    Что делает: Удаляет твой уникальный ID для рекламы
echo    Зачем: Реклама не персонализируется под тебя
echo.
echo 9. Запросы обратной связи (Windows Feedback)
echo    Что делает: Убирает запросы "Оцените Windows!"
echo    Зачем: Чтобы не раздражали всплывающие окна с опросами
echo.
echo 10. Автоустановка приложений
echo     Что делает: Запрещает Windows устанавливать Candy Crush автоматически
echo     Зачем: Чтобы не появлялись приложения, которые ты не просил
echo.
echo 11. Веб-поиск Bing в меню Пуск
echo     Что делает: Убирает веб-результаты из меню Пуск
echo     Зачем: При поиске показываются только файлы на компьютере
echo.
echo 12. Облачный буфер обмена
echo     Что делает: Отключает синхронизацию скопированного текста
echo     Зачем: То что ты копируешь не уходит в OneDrive
echo.
echo ============================================
echo.
pause
cls

echo Отключение телеметрии и функций слежки Windows...
echo.

REM ============================================
REM 1. ТЕЛЕМЕТРИЯ И ДИАГНОСТИКА
REM ============================================
echo [1/12] Отключение телеметрии...

REM Установить минимальный уровень телеметрии (0 = только безопасность)
REM Отправляет только критические данные безопасности
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul

REM Остановить и отключить службу DiagTrack (Connected User Experiences and Telemetry)
REM Эта служба собирает и отправляет данные в Microsoft
sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1

REM Остановить и отключить dmwappushservice (WAP Push Message Routing Service)
REM Служба для push-уведомлений телеметрии
sc stop "dmwappushservice" >nul 2>&1
sc config "dmwappushservice" start= disabled >nul 2>&1

echo   ^> Службы DiagTrack и dmwappushservice остановлены
echo   ^> Windows не отправляет статистику использования в Microsoft

REM ============================================
REM 2. РЕКЛАМА В МЕНЮ ПУСК И НА ЭКРАНЕ БЛОКИРОВКИ
REM ============================================
echo [2/12] Отключение рекламы и советов...

REM Отключить советы Windows в меню Пуск
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul

REM Отключить "мягкую посадку" (подсказки для новых функций)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul

REM Отключить рекламу приложений на экране блокировки
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f >nul

REM Отключить советы и трюки на экране блокировки
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f >nul

REM Отключить рекламу приложений в настройках
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f >nul

REM Отключить предлагаемые приложения в меню Пуск
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f >nul

REM Отключить автоматический показ приложений
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul

echo   ^> Реклама и советы в меню Пуск отключены
echo   ^> Экран блокировки больше не показывает рекламу приложений

REM ============================================
REM 3. СБОР ДАННЫХ О ВВОДЕ И РУКОПИСНОМ ВВОДЕ
REM ============================================
echo [3/12] Отключение сбора данных о вводе...

REM Запретить сбор данных о наборе текста
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f >nul

REM Запретить сбор данных о рукописном вводе
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f >nul

REM Запретить сбор контактов для улучшения распознавания
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f >nul

echo   ^> Сбор данных о наборе текста и рукописном вводе отключён
echo   ^> Windows не анализирует что ты печатаешь и пишешь

REM ============================================
REM 4. ОТЧЁТЫ ОБ ОШИБКАХ
REM ============================================
echo [4/12] Отключение отчётов об ошибках...

REM Отключить Windows Error Reporting
REM Прекращает отправку отчётов о сбоях в Microsoft
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul

echo   ^> Отчёты об ошибках отключены
echo   ^> При сбоях программ данные не отправляются в Microsoft

REM ============================================
REM 5. ПРОГРАММА УЛУЧШЕНИЯ КАЧЕСТВА ПО
REM ============================================
echo [5/12] Отключение программы улучшения качества...

REM Отключить Customer Experience Improvement Program (CEIP)
REM Программа сбора данных об использовании Windows
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul

echo   ^> Программа улучшения качества отключена
echo   ^> Не отправляет статистику использования функций Windows

REM ============================================
REM 6. ACTIVITY FEED И TIMELINE
REM ============================================
echo [6/12] Отключение ленты активности и Timeline...

REM Отключить ленту активности (Activity Feed)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul

REM Отключить публикацию активности пользователя
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul

REM Отключить загрузку активности в облако
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul

REM Очистить существующую базу Timeline
del /f /q "%LOCALAPPDATA%\ConnectedDevicesPlatform\L.%USERNAME%\ActivitiesCache.db" 2>nul

echo   ^> Лента активности и Timeline отключены
echo   ^> Windows не записывает историю открытых файлов и приложений

REM ============================================
REM 7. ОТСЛЕЖИВАНИЕ МЕСТОПОЛОЖЕНИЯ
REM ============================================
echo [7/12] Отключение отслеживания местоположения...

REM Отключить службы определения местоположения
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul

echo   ^> Отслеживание местоположения отключено
echo   ^> Приложения не узнают где ты находишься

REM ============================================
REM 8. РЕКЛАМНЫЙ ID
REM ============================================
echo [8/12] Отключение рекламного ID...

REM Отключить рекламный ID для текущего пользователя
REM Используется для персонализированной рекламы
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul

REM Отключить рекламный ID через групповую политику
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisableAdvertisingId" /t REG_DWORD /d 1 /f >nul

echo   ^> Рекламный ID отключён
echo   ^> Реклама не персонализируется под твои интересы

REM ============================================
REM 9. WINDOWS FEEDBACK
REM ============================================
echo [9/12] Отключение обратной связи Windows...

REM Отключить запросы обратной связи Windows
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f >nul

REM Отключить уведомления Windows Feedback
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f >nul

echo   ^> Запросы обратной связи отключены
echo   ^> Больше не появятся окна "Оцените Windows!"

REM ============================================
REM 10. АВТОУСТАНОВКА РЕКЛАМНЫХ ПРИЛОЖЕНИЙ
REM ============================================
echo [10/12] Отключение автоустановки приложений...

REM Отключить тихую установку предлагаемых приложений
REM Останавливает автоматическую установку Candy Crush и подобных игр
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul

REM Отключить предложения контента в настройках
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul

echo   ^> Автоустановка рекламных приложений отключена
echo   ^> Candy Crush и подобные игры больше не установятся сами

REM ============================================
REM 11. ВЕБ-ПОИСК В МЕНЮ ПУСК (BING)
REM ============================================
echo [11/12] Отключение веб-поиска Bing в меню Пуск...

REM Отключить поиск Bing в меню Пуск
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul

REM Отключить согласие Cortana
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul

REM Отключить веб-поиск через групповую политику
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul

REM Отключить подключённый поиск (использование веба)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul

REM Отключить показ веб-результатов в поиске
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f >nul

echo   ^> Веб-поиск Bing отключён
echo   ^> В меню Пуск показываются только файлы на компьютере

REM ============================================
REM 12. ОБЛАЧНЫЙ БУФЕР ОБМЕНА
REM ============================================
echo [12/12] Отключение облачного буфера обмена...

REM Отключить синхронизацию буфера обмена через облако
reg add "HKCU\Software\Microsoft\Clipboard" /v "EnableClipboardHistory" /t REG_DWORD /d 0 /f >nul

echo   ^> Облачный буфер обмена отключён
echo   ^> Скопированный текст не синхронизируется через OneDrive

REM ============================================
echo.
echo =========================================================
echo   Настройки приватности успешно применены!
echo =========================================================
echo.
echo Применённые изменения:
echo  - Телеметрия отключена (только безопасность)
echo  - Реклама и советы отключены
echo  - Отслеживание местоположения отключено
echo  - Отчёты об ошибках отключены
echo  - Отслеживание активности отключено
echo  - Веб-поиск Bing отключён
echo  - Автоустановка приложений отключена
echo.
echo Рекомендуется перезагрузка для применения всех изменений.
echo =========================================================
echo    NaitSide Custom Build
echo    github.com/NaitSide
echo =========================================================
echo.
pause
goto MENU

REM ============================================
REM ФУНКЦИЯ ПРОВЕРКИ НАСТРОЕК
REM ============================================
:CHECK
cls
echo ============================================
echo   ПРОВЕРКА НАСТРОЕК ПРИВАТНОСТИ
echo ============================================
echo.

REM Функция для проверки значения реестра
setlocal enabledelayedexpansion

echo [1/12] Телеметрия...
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" 2>nul | find "0x0" >nul
if %errorlevel%==0 (echo   [OK] Отключена) else (echo   [!] Включена)

echo [2/12] Служба DiagTrack...
sc query "DiagTrack" | find "STOPPED" >nul
if %errorlevel%==0 (echo   [OK] Остановлена) else (echo   [!] Работает)

echo [3/12] Советы в меню Пуск...
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" 2>nul | find "0x0" >nul
if %errorlevel%==0 (echo   [OK] Отключены) else (echo   [!] Включены)

echo [4/12] Реклама на экране блокировки...
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" 2>nul | find "0x0" >nul
if %errorlevel%==0 (echo   [OK] Отключена) else (echo   [!] Включена)

echo [5/12] Сбор данных о вводе...
reg query "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" 2>nul | find "0x1" >nul
if %errorlevel%==0 (echo   [OK] Запрещён) else (echo   [!] Разрешён)

echo [6/12] Отчёты об ошибках...
reg query "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" 2>nul | find "0x1" >nul
if %errorlevel%==0 (echo   [OK] Отключены) else (echo   [!] Включены)

echo [7/12] Программа улучшения качества...
reg query "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" 2>nul | find "0x0" >nul
if %errorlevel%==0 (echo   [OK] Отключена) else (echo   [!] Включена)

echo [8/12] Лента активности (Activity Feed)...
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" 2>nul | find "0x0" >nul
if %errorlevel%==0 (echo   [OK] Отключена) else (echo   [!] Включена)

echo [9/12] Отслеживание местоположения...
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" 2>nul | find "0x1" >nul
if %errorlevel%==0 (echo   [OK] Отключено) else (echo   [!] Включено)

echo [10/12] Рекламный ID...
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisableAdvertisingId" 2>nul | find "0x1" >nul
if %errorlevel%==0 (echo   [OK] Отключён) else (echo   [!] Включён)

echo [11/12] Запросы обратной связи...
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" 2>nul | find "0x1" >nul
if %errorlevel%==0 (echo   [OK] Отключены) else (echo   [!] Включены)

echo [12/12] Веб-поиск Bing в меню Пуск...
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" 2>nul | find "0x1" >nul
if %errorlevel%==0 (echo   [OK] Отключён) else (echo   [!] Включён)

echo.
echo =========================================================
echo   Проверка завершена!
echo =========================================================
echo    NaitSide Custom Build
echo    github.com/NaitSide
echo =========================================================
echo.
pause
goto MENU