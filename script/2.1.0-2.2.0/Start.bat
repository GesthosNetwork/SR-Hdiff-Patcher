@echo off
SetLocal EnableDelayedExpansion
chcp 65001 >nul
set "oldVer=2.1.0"
set "newVer=2.2.0"
Title Hdiff Patcher StarRail © 2024 GesthosNetwork

:Extract
choice /C YN /M "Do you want to start extracting all ZIP files?"
if errorlevel 2 echo Extraction skipped. & goto Check
if not exist 7z.exe echo 7z.exe not found. & goto End

for %%f in (*.zip) do (
    echo Extracting "%%f"... Please wait, do not close the console^^!
    "7z.exe" x "%%f" -o"." -y & echo Done extracting "%%f" & echo.
)

:Check
echo Checking if all necessary files to update the game from Patch !oldVer! to !newVer! are present...
timeout /nobreak /t 3 >nul

set "path1=StarRail_Data\Persistent\Audio\AudioPackage\Windows\Chinese(PRC)"
set "path2=StarRail_Data\Persistent\Audio\AudioPackage\Windows\English"
set "path3=StarRail_Data\Persistent\Audio\AudioPackage\Windows\Japanese"
set "path4=StarRail_Data\Persistent\Audio\AudioPackage\Windows\Korean"

set hdiff=0
for %%i in (!path1!, !path2!, !path3!, !path4!) do if exist "%%i\*.hdiff" set hdiff=1
if %hdiff%==0 (echo *.hdiff files not found. You must extract the ZIP files before proceeding. & goto Extract)
for %%i in (!path1!, !path2!, !path3!, !path4!) do if not exist "%%i\*.hdiff" rd /s /q "%%i" 2>nul

set "audio=StarRail_Data\Persistent\AudioLaucherRecord.txt"
set "used_language="
type nul > !audio!

if exist !path1! (
    set /p="Chinese(PRC)" <nul >> !audio!
    set "used_language=Chinese(PRC)"
)
if exist !path2! (
    if defined used_language echo. >> !audio!
    set /p="English" <nul >> !audio!
    set "used_language=English"
)
if exist !path3! (
    if defined used_language echo. >> !audio!
    set /p="Japanese" <nul >> !audio!
    set "used_language=Japanese"
)
if exist !path4! (
    if defined used_language echo. >> !audio!
    set /p="Korean" <nul >> !audio!
    set "used_language=Korean"
)

set PatchFinished=False
set FileMissing=False

for /F "usebackq delims=" %%i in ("AudioPatch_Common_!oldVer!-!newVer!.txt") do (
    if not exist "%%i" (
        echo "%%i" is missing.
        set FileMissing=True
    )
    if not exist "%%i.hdiff" (
        echo "%%i.hdiff" is missing.
        set FileMissing=True
    )
)

for %%l in (Chinese,English,Japanese,Korean) do (
    for %%f in (AudioPatch_%%l_!oldVer!-!newVer!.txt AudioPatch_Common_!oldVer!-!newVer!.txt hpatchz.exe hdiffz.exe) do (
        if NOT exist %%~f (
            echo "%%~f is missing."
            set FileMissing=True
        )
    )

    for /F "usebackq delims=" %%j in ("AudioPatch_%%l_!oldVer!-!newVer!.txt") do (
        if NOT exist "%%j" (
            echo "%%j is missing."
            set FileMissing=True
        )
        if NOT exist "%%j.hdiff" (
            echo "%%j.hdiff is missing."
            set FileMissing=True
        )
    )
)

if "%FileMissing%"=="True" goto End

choice /C YN /M "All necessary files are present. Apply patch now?"
if errorlevel 2 goto End

for %%i in (!path1!, !path2!, !path3!, !path4!) do (
    if "%%i"=="!path1!" set "l=Chinese"
    if "%%i"=="!path2!" set "l=English"
    if "%%i"=="!path3!" set "l=Japanese"
    if "%%i"=="!path4!" set "l=Korean"
    if exist "%%i\*.hdiff" (
        for /F "usebackq delims=" %%j in ("AudioPatch_!l!_!oldVer!-!newVer!.txt") do (
            attrib -R "%%j" && hpatchz.exe -f "%%j" "%%j.hdiff" "%%j"
        )
    )
)

for /F "usebackq delims=" %%i in ("AudioPatch_Common_!oldVer!-!newVer!.txt") do (
    attrib -R "%%i" && "hpatchz.exe" -f "%%i" "%%i.hdiff" "%%i"
)

for %%l in (Chinese,English,Japanese,Korean) do (
    for /F "usebackq delims=" %%i in ("AudioPatch_%%l_!oldVer!-!newVer!.txt") do (
			if exist "%%i.hdiff" echo Deleting "%%i.hdiff" && del "%%i.hdiff"
		)
)

for /F "usebackq delims=" %%i in ("AudioPatch_Common_!oldVer!-!newVer!.txt") do (
    if exist "%%i.hdiff" echo Deleting "%%i.hdiff" && del "%%i.hdiff"
)

for /F "usebackq delims=" %%i in ("Cleanup_!oldVer!-!newVer!.txt") do (
    if exist "%%i" echo Deleting "%%i" & attrib -R "%%i" && del "%%i"
)

:Empty
set "E=0" & for /d /r "StarRail_Data" %%i in (*) do (rd "%%i" 2>nul & if not exist "%%i" set "E=1")
if !E! equ 1 goto Empty

set PatchFinished=True
echo. & echo Patch completed^^!

:End
pause
if "%PatchFinished%"=="True" (
  (
    echo [General]
    echo channel=1
    echo cps=mihoyo
    echo game_version=!newVer!
    echo sub_channel=0
  ) > "config.ini"

  rd /s /q "StarRail_Data\SDKCaches" "StarRail_Data\webCaches" 2>nul
  del *.bat *.zip hpatchz.exe hdiffz.exe 7z.exe *.dmp *.bak *.txt *.log
)