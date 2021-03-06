@echo off
echo %cd%

echo.
echo \033[97;44mBuild Options:|cmdcolor.exe
set opt

echo.
echo \033[97;44mBuild Selection:|cmdcolor.exe
type "%_WB_TMP_DIR%\_patches_selected.txt"
echo.

rem Dism /Get-Packages /Image:"%_WB_MNT_DIR%"

cd /d "%~dp0"


set opt[build.wim]=customed
if "%WB_BASE%"=="winre.wim" (
  set opt[build.wim]=winre
)
if "x%opt[build.adk]%"=="xtrue" (
  set opt[build.wim]=winpe
)

if "x%opt[build.wow64support]%"=="xtrue" (
  if not "x%WB_PE_ARCH%"=="xx64" set opt[build.wow64support]=false
)

set opt[support.wow64]=%opt[build.wow64support]%
if "%opt[support.wow64]%"=="true" (
  set ADDFILES_SYSWOW64=1
)

rem call CheckPatch "01-Components\02-Network"
rem set opt[support.network]=%HasPatch%

call CheckPatch "01-Components\03-Audio"
set opt[support.audio]=%HasPatch%

call shared\InitCodePage.bat

echo.
echo \033[97;44mAvailable Environment Variables\033[97;45m(For Developer):|cmdcolor.exe
set WB_
set VER[3]
echo.
echo X=%X%
set X_
echo.
set _CUSTOMFILES_
set _USER_
echo V=%V%
echo %%V%%\%%APP_CACHE%%=%V%\%APP_CACHE%
echo.
set APP_
echo.
set _V
echo.
echo Mounted KEYs of %WB_SRC%'s HIVEs
echo   - HKEY_LOCAL_MACHINE\Src_DEFAULT
echo   - HKEY_LOCAL_MACHINE\Src_DRIVERS
echo   - HKEY_LOCAL_MACHINE\Src_SOFTWARE
echo   - HKEY_LOCAL_MACHINE\Src_SYSTEM
echo.
echo Mounted KEYs of %WB_BASE%'s HIVEs
echo   - HKEY_LOCAL_MACHINE\Tmp_DEFAULT
echo   - HKEY_LOCAL_MACHINE\Tmp_DRIVERS
echo   - HKEY_LOCAL_MACHINE\Tmp_SOFTWARE
echo   - HKEY_LOCAL_MACHINE\Tmp_SYSTEM
echo.

if "x%opt[build.main_filereg_disabled]%"=="xtrue" goto :EOF

call CheckPatch "za-Slim"
if "x%HasPatch%"=="xtrue" (
  pushd za-Slim
  call Slim_Extra.bat
  popd
)

 call X2X

