@echo off
SetLocal EnableDelayedExpansion
set FilePath=%~dp0
set "oldVer=1.6.0"
set "newVer=2.0.0"
Title Hdiff Patcher StarRail !oldVer!-!newVer! by Tom
echo Checking if all necessary files to update the game from Patch !oldVer! to !newVer! are present...
timeout /nobreak /t 5 >nul

:SelectionY
set PatchFinished=False
set FileMissing=False
set ChineseInstalled=False
set EnglishInstalled=False
set JapaneseInstalled=False
set KoreanInstalled=False
set CurrentLanguage=None

for /F "usebackq delims=" %%i in ("!FilePath!StarRail_Data\Persistent\AudioLaucherRecord.txt") do (
	if "%%i"=="Chinese" (
		set ChineseInstalled=True
		set CurrentLanguage=Chinese
	)
	if "%%i"=="English(US)" (
		set EnglishInstalled=True
		set CurrentLanguage=English
	)
	if "%%i"=="Japanese" (
		set JapaneseInstalled=True
		set CurrentLanguage=Japanese
	)
	if "%%i"=="Korean" (
		set KoreanInstalled=True
		set CurrentLanguage=Korean
	)
	
	if NOT exist "!FilePath!AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt" (
		echo "AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt" is missing.
		set FileMissing=True
		set CurrentLanguage=None
	)
)
if NOT exist "!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt" (
	echo "AudioPatch_Common_!oldVer!-!newVer!.txt" is missing.
	set FileMissing=True
)

for /F "usebackq delims=" %%i in ("!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt") do (
	if NOT exist "!FilePath!%%i" (
		echo "!FilePath!%%i" is missing.
		set FileMissing=True
	)
	if NOT exist "!FilePath!%%i.hdiff" (
		echo "!FilePath!%%i.hdiff" is missing.
		set FileMissing=True
	)
)

if NOT exist "!FilePath!hpatchz.exe" (
	echo "!FilePath!hpatchz.exe" is missing.
	set FileMissing=True
)

if "%FileMissing%"=="True" (
	goto Retry
) else (
	goto ApplyPatch
)

:Retry
echo.
echo At least one file is missing. Please extract/download the necessary files listed above and try again.

:Query
set /P selection=Retry patch application now? (y / n): 
for %%a in (Y N) do if /i '%selection%'=='%%a' goto :Selection%%a
echo Wrong input. Valid inputs: 'y' for retry and 'n' for abort.
goto Query

:SelectionN
echo Aborted patch application. Exiting after next button press.
echo.
goto End

:ApplyPatch
echo All necessary files are present. Applying patch now...
echo.
timeout /nobreak /t 5 >nul

for /F "usebackq delims=" %%j in ("!FilePath!AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt") do (
	attrib -R "!FilePath!%%j"
	"!FilePath!hpatchz.exe" -f "!FilePath!%%j" "!FilePath!%%j.hdiff" "!FilePath!%%j"
)
for /F "usebackq delims=" %%i in ("!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt") do (
	attrib -R "!FilePath!%%i"
	"!FilePath!hpatchz.exe" -f "!FilePath!%%i" "!FilePath!%%i.hdiff" "!FilePath!%%i"
)
set PatchFinished=True


for /F "usebackq delims=" %%k in ("!FilePath!AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt") do (
	if exist "!FilePath!%%k.hdiff" (
	del "!FilePath!%%k.hdiff"
	)
)

for /F "usebackq delims=" %%i in ("!FilePath!Cleanup_!oldVer!-!newVer!.txt") do (
	if exist "!FilePath!%%i" (
	attrib -R "!FilePath!%%i"
	del "!FilePath!%%i"
	)
)

for /F "usebackq delims=" %%i in ("!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt") do (
	if exist "!FilePath!%%i.hdiff" (
	del "!FilePath!%%i.hdiff"
	)
)

for %%F in (
    deletefiles.txt
	hdifffiles.txt
	hpatchz.exe
    hdiffz.exe
    Cleanup_!oldVer!-!newVer!.txt
    AudioPatch_Common_!oldVer!-!newVer!.txt
    AudioPatch_Chinese_!oldVer!-!newVer!.txt
    AudioPatch_English_!oldVer!-!newVer!.txt
    AudioPatch_Japanese_!oldVer!-!newVer!.txt
    AudioPatch_Korean_!oldVer!-!newVer!.txt
) do (
    if exist "!FilePath!%%F" del "!FilePath!%%F"
)

rd /S /Q "!FilePath!StarRail_Data\SDKCaches\" "!FilePath!StarRail_Data\webCaches\" 2>nul 
echo.
echo Patch application is finished now. Enjoy your game :)
echo.
goto End

:End
pause
if "%PatchFinished%"=="True" (
	if exist "!FilePath!^Start.bat" (
		del "!FilePath!^Start.bat"
	)
)