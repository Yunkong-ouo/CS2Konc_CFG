@echo off
chcp 65001 >nul 2>&1

REM 檢查 64 位系統路徑
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0

cd /d "%~dp0"

REM 檢查是否在 CS2Konc_CFG 資料夾中
for %%I in (.) do set CurrDirName=%%~nxI
if /I not "%CurrDirName%"=="CS2Konc_CFG" (
    cls
    color 0C
    echo 請把此資料夾放進 CS2Konc_CFG 資料夾中!!!
    echo 請確保此資料夾在 *\Counter-Strike Global Offensive\game\csgo\cfg\CS2Konc_CFG 目錄當中
    echo.
    echo 請按任意鍵退出。
    pause >nul
    exit /b
)

REM 檢測 CS2Konc_CFG 放置位置
cd /d %~dp0
cd ../../
set "EXPECTED_FOLDER_NAME=csgo"
for %%F in (.) do set "CURRENT_FOLDER_NAME=%%~nxF"
echo 當前資料夾名稱: %CURRENT_FOLDER_NAME%
echo 預期資料夾名稱: %EXPECTED_FOLDER_NAME%
if /I "%CURRENT_FOLDER_NAME%" neq "%EXPECTED_FOLDER_NAME%" (
    cls
    color 0C
    echo 您的 CS2Konc_CFG 放置位置錯誤!!!，請重看使用說明
    echo 請確保此資料夾放在 *\Counter-Strike Global Offensive\game\csgo\cfg 目錄當中
    echo.
    echo 請按任意鍵退出。
    pause >nul
    exit /b
)

cd ./cfg/CS2Konc_CFG/

REM 壓縮 resource 資料夾為 resource.zip
cls
color 0a
set zipFile=resource.zip
set folderToZip=%~dp0\resource
REM 如果已存在同名的 zip 檔案，先刪除
if exist "%zipFile%" del "%zipFile%"
if exist "%folderToZip%" (
    echo 正在壓縮 resource 資料夾...
    powershell.exe -Command "Compress-Archive -Path '%folderToZip%\*' -DestinationPath '%zipFile%' -Force"
    REM 檢查壓縮檔案是否存在
    if exist "%zipFile%" (
        echo 壓縮完成: %zipFile%
    ) else (
        echo 壓縮失敗，停止腳本。
        echo.
        echo 請按任意鍵退出。
        pause >nul
        exit /b
    )
) else (
    echo resource 資料夾不存在，無法壓縮。
    echo.
    echo 請按任意鍵退出。
    pause >nul
    exit /b
)

REM 檢查 "完美世界竞技平台" 進程是否運行
tasklist /FI "IMAGENAME eq 完美世界竞技平台.exe" 2>nul | find /I /N "完美世界竞技平台.exe">nul
if "%ERRORLEVEL%"=="1" (
    cls
    color 0C
    echo 如果你玩完美平台，請按N退出程序，運行完美對戰平台後啟動此檔案!!!
    echo 再次確認
    echo 如果你確定不玩完美平台，按Y繼續
    choice /C YN /N /M "按 Y 繼續，按 N 退出"
    if errorlevel 2 (
        echo 你選擇了退出。
        timeout /t 1 >nul
        cls
        exit /b
    ) else (
        echo 你選擇了繼續。
        timeout /t 1 >nul
        cls
    )
    color 0A
    REM 運行 PowerShell 腳本並在完成後退出
    call powershell.exe -ExecutionPolicy Bypass -File ".\install\CS2Konc_CFG_Install_Resource.ps1"
    exit /b
)

cls
color 0A
REM 執行默認的 PowerShell 腳本
call powershell.exe -ExecutionPolicy Bypass -File ".\install\CS2Konc_CFG_Install_Resource_Perfect.ps1"
