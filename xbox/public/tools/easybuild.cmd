@echo off
cls
rem Here we set some variables that are not set by Easy-build-xbox.cmd/razzle during load, so we just load them
set _BUILDVER=4400
set COMPLEX=1 
set NODEVKIT=
set FOCUS=1
if /i "%_BINPLACE_SUBDIR%" == "" call setfre.cmd
:eb-xbox-mainmenu
cls
set ebdrive=%_NTDrive%
set ebntroot=%_NTBINDIR%
set ebxbbins=%_BINPLACE_DIR%
set ebxbtype=%_BINPLACE_SUBDIR%
cd /d %ebntroot%
color 2F
echo --------------------------------------------------------------------------------------------
echo  Empyreal's Easy-Build for XBOX ORIGINAL (Very limited features currently, WIP)
echo --------------------------------------------------------------------------------------------
echo  Build User: %_NTUSER%	Build Machine: %COMPUTERNAME%
echo  Build Root: %ebntroot% 	Razzle Tool Path: %ebntroot%\public\tools
echo  Postbuild Dir: %ebxbbins%
echo --------------------------------------------------------------------------------------------
echo - Release Type: %ebxbtype%  - NT Tree: XBOX %BUILD_PRODUCT% %BUILD_PRODUCT_VER% - Xbox Ver: %_BUILDVER%
echo --------------------------------------------------------------------------------------------
echo  Here you can start the build for the XBOX source (with Team Complex's source patch). 
echo (Very limited features currently, WIP.. Suggestions are needed)
echo.
echo ------------------------------------------------------------------------------
echo  options) Modify Some Build Options.
echo --------------------------------------------------------------------------------------------
echo  1) Clean Build (Full err path, delete object files, no checks)
echo  2) 'Dirty' Build (Full err path, no checks)
echo  3) Build Specific Directory Only
echo  b/w) Open Build Error or Warning Logs
echo --------------------------------------------------------------------------------------------
echo  4) Binplace built files to %ebxbbins%\release (VERY WIP)
echo  5) Build XDK Samples CD
echo  6) Drop to Razzle Prompt
echo.
echo ____________________________________________________________________________________________
set /p NTMMENU=Select:
echo ____________________________________________________________________________________________
if /i "%NTMMENU%"=="1" goto cleanbuild
if /i "%NTMMENU%"=="2" goto DirtyBuild
REM Opens the most recent builds error logs in Notepad
if /i "%NTMMENU%"=="b" notepad %ebntroot%\private\build.err & goto eb-xbox-mainmenu
if /i "%NTMMENU%"=="w" notepad %ebntroot%\private\build.wrn & goto eb-xbox-mainmenu
if /i "%NTMMENU%"=="3" goto SpecificBLD
if /i "%NTMMENU%"=="4" goto postbuild-placeholder
if /i "%NTMMENU%"=="p" notepad %_NTPOSTBLD%\build_logs\postbuild.err & goto eb-xbox-mainmenu
if /i "%NTMMENU%"=="w" notepad %_NTPOSTBLD%\build_logs\postbuild.wrn & goto eb-xbox-mainmenu
if /i "%NTMMENU%"=="5" goto XDKSampleCD
if /i "%NTMMENU%"=="6" exit /b
if /i "%NTMMENU%"=="var" set && pause
if /i "%NTMMENU%"=="options" goto BuildOptions
goto eb-xbox-mainmenu


:BuildInfo
echo still working this out..
pause
goto eb-xbox-mainmenu
:cleanbuild
cls
cd /d %ebntroot%\private
build -bcDeFZP
pause
goto eb-xbox-mainmenu
:DirtyBuild
cls
cd /d %ebntroot%\private
build -bDeFZP
pause
goto eb-xbox-mainmenu



:SpecificBLD
cls
echo ----------------------------------------------------------------------
echo This section we can clean build certain components of the source
echo So if you want to rebuild the Kernel you would type:
echo.
echo F:\xbox\private\ntos
echo ----------------------------------------------------------------------
echo.
echo Type full path to folder or type back to return:
echo.
set /p userinput=:
if "%userinput%"=="back" goto eb-xbox-mainmenu
cd /d %userinput%
echo BUILD: %CD% STARTED
echo.
build -bcDeFZP
pause
goto eb-xbox-mainmenu

:postbuild-placeholder
cls
echo This is a 'Postbuild' script I made from 'copybins.cmd' and 'copytest.cmd' to
echo place files in %_NT386TREE% instead of an Xbox Dev Kit.. THIS IS NOT AN 'OFFICIAL' SCRIPT
echo This script needs your love! Know how to binplace something? Let me know!
echo.
echo xcopybins
pause
cmd /c xcopybins.cmd&& goto eb-xbox-mainmenu

:XDKSampleCD
cls 
echo.
echo Here the XDK Sample CD will be copied and built for Xboxes
echo These are only Xbox Direct Media Samples of:
echo Graphics, Sound and other stuff
echo.
echo The .iso will be placed in %_BINPLACE_ROOT%\XDKSamples%_BUILDVER%.iso
echo.
pause
cmd /c xmakesamples.cmd&& goto eb-xbox-mainmenu
:BuildOptions

REM Over time I will add more features, first I need to find what to change and how
REM Suggestions and improvements greatly welcomed here.
REM
REM
if "%COMPLEX%" == "1" set ebcomplex=On
if "%COMPLEX%" == "" set ebcomplex=Off
if "%FOCUS%" == "1" set ebfocus=On
if "%FOCUS%" == "" set ebfocus=Off
if "%NODEVKIT%" == "1" set ebdevkit=Retail
if "%NODEVKIT%" == "" set ebdevkit=DevKit
cls
echo ----------------------------------------------------------------------
echo This section we can use to modify various parts of the build process
echo for example changing Release type, Build type etc
echo To switch, type the option after the Value:
echo ----------------------------------------------------------------------
echo.
echo (Current:%ebdevkit%) Release: devkit - retail
echo (Current:%ebxbtype%) Build Type: fre - chk
echo (Current:%ebcomplex%) Complex Patches: con - coff
echo (Current:%ebfocus%) Focus Video Tuner: fon - foff
echo.
echo I will slowly add more here over time
echo ----------------------------------------------------------------------
echo back) Return
echo.
set /p bldopt=:
if /i "%bldopt%"=="devkit" set NODEVKIT=""
if /i "%bldopt%"=="retail" set NODEVKIT="1"
if /i "%bldopt%"=="fre" SETFRE && goto BuildOptions
if /i "%bldopt%"=="chk" SETCHK && goto BuildOptions
if /i "%bldopt%"=="con" CPXON && goto BuildOptions
if /i "%bldopt%"=="coff CPXOFF && goto BuildOptions
if /i "%bldopt%"=="fon" FOCUSON && goto BuildOptions
if /i "%bldopt%"=="foff" FOCUSOFF && goto BuildOptions
if /i "%bldopt%"=="showopt" showopt && goto BuildOptions
if /i "%bldopt%"=="back" goto eb-xbox-mainmenu
goto BuildOptions

REM
