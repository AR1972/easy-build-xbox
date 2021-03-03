@echo off
mode con:cols=98 lines=32
REM Load the config file
set "_EBConf=%_NTDRIVE%%_NTROOT%\public\tools\easybuild.conf"

set "_BVT_ADDRESS="
for /F "skip=5 delims=" %%i in (%_EBConf%) do if not defined _BVT_ADDRESS set "_BVT_ADDRESS=%%i"
echo %_BVT_ADDRESS%
echo.
set "_BVT_KERNEL_ONLY="
for /F "skip=7 delims=" %%i in (%_EBConf%) do if not defined _BVT_KERNEL_ONLY set "_BVT_KERNEL_ONLY=%%i"
echo %_BVT_KERNEL_ONLY%
echo. 
set "_XBOX_TITLE_IP="
for /F "skip=11 delims=" %%i in (%_EBConf%) do if not defined _XBOX_TITLE_IP set "_XBOX_TITLE_IP=%%i"
echo %_XBOX_TITLE_IP%
echo. 
set "_XBOX_DEBUG_IP="
for /F "skip=9 delims=" %%i in (%_EBConf%) do if not defined _XBOX_DEBUG_IP set "_XBOX_DEBUG_IP=%%i"
echo %_XBOX_DEBUG_IP%
echo. 
cls
rem Here we set some variables that are not set by Easy-build-xinit.cmd/razzle during load, so we just load them
set Easy-Build-Version=v0.3
set _BUILDVER=4400
set COMPUTERNAME=XBuilds
set "_Yelo_Nbh_Path=%_NTDRIVE%%_NTROOT%\public\tools\Yelo"
if /i "%NTDEBUG%" == "" set NTDEBUG=ntsdnodbg
if /i "%COMPLEX%" == "" set COMPLEX=1 
if /i "%FOCUS%" == "" set FOCUS=1
if /i "%_BINPLACE_SUBDIR%" == "" call setfre.cmd
if /i "%1" == "" call setfre.cmd
if /i "%1" == "free" call setfre.cmd
if /i "%1" == "fre" call setfre.cmd
if /i "%1" == "chk" call setchk.cmd
if /i "%1" == "chk" if NOT exist "%_NT386TREE%\dump\xpacker.exe" copy "%_NTDRIVE%%_NTROOT%\private\setup\packer\obj\i386\xpacker.exe" "%_NT386TREE%\dump"
if /i "%1" == "XM3" call setfre.cmd
if /i "%1" == "XM3P" call setfre.cmd
if /i "%1" == "XM3" set RETAILXM3=1
if /i "%1" == "XM3" set OFFICIAL_BUILD=1
if /i "%1" == "XM3P" set RETAILXM3P=1
if /i "%1" == "XM3P" set OFFICIAL_BUILD=1
if /i "%2" == "XM3" set RETAILXM3=1
if /i "%2" == "XM3" set OFFICIAL_BUILD=1
if /i "%2" == "XM3P" set RETAILXM3P=1
if /i "%2" == "XM3P" set OFFICIAL_BUILD=1
if NOT exist "%_NTDRIVE%%_NTROOT%\private\ntos\inc\nv_ref_2a.h" cp "%_NTDRIVE%%_NTROOT%\private\ntos\av\nv_ref_2a.h" "%_NTDRIVE%%_NTROOT%\private\ntos\inc\"
if exist "%_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def.new" goto applychkpatch
REM FTP Test and settings.conf test
goto eb-xbox-mainmenu


:applychkpatch
echo Applying CHK fixes..
if exist %_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def.old goto eb-xbox-mainmenu
copy "%_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def" "%_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def.old"
del "%_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def"
copy "%_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def.new" "%_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def"
del "%_NTDRIVE%%_NTROOT%\public\oak\bin\makefile.def.new"
goto eb-xbox-mainmenu


:eb-xbox-mainmenu
cls
Title Easy-Build XBOX Build Environment %Easy-Build-Version%
set ebbuildoptions=%Build_Default%
set ebdrive=%_NTDrive%
set ebntroot=%_NTBINDIR%
set ebxbbins=%_BINPLACE_DIR%
set ebxbtype=%_BINPLACE_SUBDIR%
if /i "%1" == "XM3" set ebxm3build=RETAILXM3 Defined
if /i "%1" == "XM3P" set ebxm3build=RETAILXM3P Defined
if /i "%2" == "XM3" set ebxm3build=RETAILXM3 Defined
if /i "%2" == "XM3P" set ebxm3build=RETAILXM3P Defined
if /i "%_BINPLACE_SUBDIR%" == "fre" set ErrorLogsEB=%ebntroot%\private\build.err
if /i "%_BINPLACE_SUBDIR%" == "chk" set ErrorLogsEB=%ebntroot%\private\buildd.err
if /i "%_BINPLACE_SUBDIR%" == "fre" set WarningLogsEB=%ebntroot%\private\build.wrn
if /i "%_BINPLACE_SUBDIR%" == "chk" set WarningLogsEB=%ebntroot%\private\buildd.wrn
cd /d %ebntroot%
color 2F

echo -------------------------------------------------------------------------------------------------
echo  Empyreal's Easy-Build for XBOX ORIGINAL (WIP)
echo -------------------------------------------------------------------------------------------------
echo  Build User: %_NTUSER%	          Build Machine: %COMPUTERNAME%            BVT Address: %_BVT_ADDRESS%
echo  Build Root: %ebntroot%    Razzle Tool Path: %ebntroot%\public\tools
echo  Postbuild Dir: %ebxbbins%                              XBOX IP Address: %_XBOX_DEBUG_IP%
echo -------------------------------------------------------------------------------------------------
echo  Release Type: %ebxbtype%  -  NT Ver: XBOX %BUILD_PRODUCT% %BUILD_PRODUCT_VER%  -  Xbox Ver: %_BUILDVER%  -  %ebxm3build%
echo -------------------------------------------------------------------------------------------------
echo  Here you can start the build for the XBOX source (with Team Complex's source patch). 
echo (WIP.. Suggestions are needed)
echo.
echo        THIS KERNEL CURRENTLY IS BROKEN FOR 1.6 XBOXES!! DO NOT FLASH ON A 1.6!!
echo -------------------------------------------------------------------------------------------------
echo  options) Modify Some Build Options.
echo  BVT) Start BVT Build Process   
echo -------------------------------------------------------------------------------------------------
echo  1) Clean Build (Full err path, delete object files)
echo  2) 'Dirty' Build (Full err path, no checks)
echo  3) Build Specific Directory Only
echo  b/w) Open Build Error or Warning Logs
echo -------------------------------------------------------------------------------------------------
echo  4) Binplace Kernel files       # 8) Build Xbox SDK Setup
echo  5) Build BIOS ROM              # 9) Place 'HVS Launcher'
echo  6) Build EEPROM                # 10) ISO Building Menu
echo  7) Binplace Debugging Symbols  # 11) Devkit Main Menu (WIP)
echo  r) Drop to Razzle Prompt       # x) Extras (Not so important)
echo.
echo _________________________________________________________________________________________________
set /p NTMMENU=Select:
echo _________________________________________________________________________________________________
if /i "%NTMMENU%"=="1" goto cleanbuild
if /i "%NTMMENU%"=="2" goto DirtyBuild
if /i "%NTMMENU%"=="BVT" goto InitBVTTestrun
REM Opens the most recent builds error logs in Notepad
if /i "%NTMMENU%"=="b" cmd.exe /c notepad %ErrorLogsEB%
if /i "%NTMMENU%"=="w" cmd.exe /c notepad %WarningLogsEB%
if /i "%NTMMENU%"=="3" goto SpecificBLD
if /i "%NTMMENU%"=="4" goto postbuild-placeholder
if /i "%NTMMENU%"=="5" goto BIOSPack_Barnabus
if /i "%NTMMENU%"=="6" goto EEPROMmenu
if /i "%NTMMENU%"=="7" goto DebugCopySym
if /i "%NTMMENU%"=="8" goto SetupSDK
if /i "%NTMMENU%"=="9" goto HVSLaunchtest
if /i "%NTMMENU%"=="10" goto eb-ISO-menu
if /i "%NTMMENU%"=="11" goto eb-devkit-mainmenu
if /i "%NTMMENU%"=="x" goto eb-extras-menu
if /i "%NTMMENU%"=="r" exit /b
if /i "%NTMMENU%"=="var" set && pause && goto eb-xbox-mainmenu
if /i "%NTMMENU%"=="options" goto BuildOptions
goto eb-xbox-mainmenu

:eb-ISO-menu
Title Easy-Build XBOX Build Environment - ISO Menu
cls
echo --------------------------------------------------------------------------------------------
echo  Empyreal's Easy-Build for XBOX ORIGINAL (Very limited features currently, WIP)
echo --------------------------------------------------------------------------------------------
echo.
echo Here are a list of various ISO Images you can create.
echo NOTE: I personally havent tested these yet in an XBOX or XEMU
echo.
echo --------------------------------------------------------------------------------------------
echo 1) XDK Sample CD
echo 2) Hardware Test Recovery ISO
echo 3) 'Retail' Recvery ISO 
echo b) Main Menu
echo.
echo ____________________________________________________________________________________________
set /p ISONTMMENU=Select:
echo ____________________________________________________________________________________________
if /i "%ISONTMMENU%"=="1" goto XDKSampleCD
if /i "%ISONTMMENU%"=="2" goto XBRecovery
if /i "%ISONTMMENU%"=="3" goto RecoveryImage
if /i "%ISONTMMENU%"=="b" goto eb-xbox-mainmenu
goto eb-extras-menu


:eb-extras-menu
Title Easy-Build XBOX Build Environment - Extras
cls
echo --------------------------------------------------------------------------------------------
echo  Empyreal's Easy-Build for XBOX ORIGINAL (Very limited features currently, WIP)
echo --------------------------------------------------------------------------------------------
echo.
echo Here are the options that are I feel aren't priority, but could still be worth building.
echo.
echo --------------------------------------------------------------------------------------------
echo 1) Build Xbox Shell Extension for Windows Setup
echo 2) Attempt Bios Build Using ROMBLD (ADV.. NOT WORKING YET) 
echo b) Main Menu
echo.
echo ____________________________________________________________________________________________
set /p EXNTMMENU=Select:
echo ____________________________________________________________________________________________
if /i "%EXNTMMENU%"=="1" goto xbsebuild
if /i "%EXNTMMENU%"=="2" goto BuildBiosImage
if /i "%EXNTMMENU%"=="b" goto eb-xbox-mainmenu
goto eb-extras-menu

:BuildInfo
echo still working this out..
pause
goto eb-xbox-mainmenu
:cleanbuild
Title Easy-Build XBOX Build Environment - Clean Building
cls
cd /d %ebntroot%\private
build -bcDeFZP
pause
goto eb-xbox-mainmenu
:DirtyBuild
Title Easy-Build XBOX Build Environment - Rebuilding
cls
cd /d %ebntroot%\private
build -bDeFZP
pause
goto eb-xbox-mainmenu

:HVSLaunchtest
Title Easy-Build XBOX Build Environment - HVS Launcher Test
CLS
cd /d %ebntroot%
echo.
echo This creates the appropriate directory structure for
echo the HVS Launcher and all of its tests.  This will allow these
echo programs to be compiled in to an Xbox disc image, or simply
echo copied over to an Xbox to be executed from the XDK Launcher.
echo.
echo Location: %ebxbbins%\xboxtest
echo.
pause
cmd /c %ebntroot%\private\test\hvs\createdirs.cmd | tee %_NT386TREE%\HVTestBinplace.log&& pause && goto eb-xbox-mainmenu

:RecoveryImage
Title Easy-Build XBOX Build Environment - Recovery Image
cls
cd /d %ebntroot%
echo xupdrec (Originally updrec.cmd)
echo.
echo This will run a modified script to setup a 'Recovery' ISO
echo This may not be perfect, some files that were on a server share
echo have been directed to the built ones. dvdkey1d.bin didn't exist
echo but dvdkey1.bin did get build, so we use this for now
echo NOTE: It's likely this wont work, as some files may be different
echo from files originally copied (dvdkey1d.bin, dashboard.xbe from srv share
echo XBOXROM_QT.bin doesn't build either so it's been commented out.
echo.
echo Location: %ebxbbins%\Recovery.iso
echo.
pause
cmd /c xupdrec | tee %_NT386TREE%\xupdrec.log&& pause && goto eb-ISO-menu


:SetupSDK
Title Easy-Build XBOX Build Environment - Xbox SDK Build
cls
echo XDKBuild.bat
echo This will start a modified script to build the XBOX SDK.
echo.
echo.
echo Setup will be located at %_NT386TREE%\XDKSetup\%_BUILDVER%\XDKSetup%_BUILDVER%.exe
pause
cmd /c %_NTDrive%%_NTROOT%\private\setup\xdk\xdkbuild.bat
pause
goto eb-xbox-mainmenu

:DebugCopySym
Title Easy-Build XBOX Build Environment - Copying Debugging Symbols
echo.
echo.
cls
cmd /c %_NTDrive%%_NTROOT%\public\tools\xdbgsym.cmd | tee %_NT386TREE%\xdbgsym.log
pause
goto eb-xbox-mainmenu

:BIOSPack_Barnabus
Title Easy-Build XBOX Build Environment - BIOSPack
cls
echo.
echo  BIOSpack - From Barnabus Kernel Repack
echo.
echo  This is the tool included with the 'Barnabus' Xbox Kernel Repack.
echo  It uses an already made 'Remainder.img' and '2bl.img'
echo.
echo  This method isn't 'Official' as it doesn't pack the bios the same way ROMBLD does
echo  yet for now, This is the only method to produce a 'working' BIOS ROM.
echo.
echo  This will use the built Kernel from %_NT386TREE%\xboxkrnl.exe
pause
echo.
if NOT exist "%_NT386TREE%\xboxkrnl.exe" echo KERNEL NOT FOUND! && pause && goto eb-xbox-mainmenu
if exist "%IDW_DIR%\biospack\boot\xboxkrnl.img" del "%IDW_DIR%\biospack\boot\xboxkrnl.img"
if NOT exist "%IDW_DIR%\biospack\boot\xboxkrnl.img" copy "%_NT386TREE%\xboxkrnl.exe" "%IDW_DIR%\biospack\boot\xboxkrnl.img"
cmd.exe /c %IDW_DIR%\biospack\biospack.exe -t multi -i %IDW_DIR%\biospack\boot\ -o %_NT386TREE%\xboxbios_%ebxbtype%.bin
if exist "%_NT386TREE%\xboxbios_%ebxbtype%.bin" (echo Finished! %_NT386TREE%\xboxbios_%ebxbtype%.bin) else (echo Failed!)
pause
goto eb-xbox-mainmenu


:EEPROMmenu
Title Easy-Build XBOX Build Environment - EEPROM Builder
If NOT exist "%_NTDrive%%_NTROOT%\private\sdktools\mkeeprom\obj\i386\mkeeprom.exe" cd /d "%_NTDrive%%_NTROOT%\private\sdktools\mkeeprom" && build -bcZP
if NOT exist "%IDW_DIR%\mkeeprom.exe" copy "%_NTDrive%%_NTROOT%\private\sdktools\mkeeprom\obj\i386\mkeeprom.exe" "%IDW_DIR%" 
cls
echo.
echo  mkEEPROM
echo.
echo  Here you can create an EEPROM that can, in theory, be used for emulation.
echo  various options are available for testing..
echo <FLASHING TO AN ACTUAL CONSOLE IS UNTESTED AND NOT RECOMMENDED, unless you like the risk>
echo  NOTE I have only tested the 'Rest of World + Zero HDD Key' EEPROM in XEMU
echo.
echo   Origin:
echo   NA) North America     JP) Japan     ROW) Rest of the World
echo.
echo   HDD Status:
echo   ZKey) Zero HDD Key     SeqKey) Sequential HDD Key     DevKey) DevKit HDD Key
echo.
echo   Type to make EEPROM: Build
echo.
echo   Currently Selected: %eb-eeprom-origin%      %eb-eeprom-hddstatus% 
set /p eb-eeprom-userinput=Select:
echo.
if /i "%eb-eeprom-userinput%" == "na" goto EEPROMSetNA
if /i "%eb-eeprom-userinput%" == "jp" goto EEPROMSetJP
if /i "%eb-eeprom-userinput%" == "row" goto EEPROMSetROW
if /i "%eb-eeprom-userinput%" == "ZKey" goto EEPROMSetHDD
if /i "%eb-eeprom-userinput%" == "SeqKey" goto EEPROMSetHDDS
if /i "%eb-eeprom-userinput%" == "DevKey" goto EEPROMSetHDDD
if /i "%eb-eeprom-userinput%" == "build" goto EEPROMBuild
if /i "%eb-eeprom-userinput%" == "b" goto eb-xbox-mainmenu
goto EEPROMmenu

:EEPROMBuild
if /i "%eb-eeprom-origin%" == "north america" set eepromflag1=-na
if /i "%eb-eeprom-origin%" == "japan" set eepromflag1=-ja
if /i "%eb-eeprom-origin%" == "global" set eepromflag1=-row
if /i "%eb-eeprom-origin%" == "" echo Region not set! && pause && goto EEPROMmenu
if /i "%eb-eeprom-hddstatus%" == "Sequential HDD Key" set eepromflag2=-lockhd
if /i "%eb-eeprom-hddstatus%" == "Zero HDD Key" set eepromflag2=-lockhdz
if /i "%eb-eeprom-hddstatus%" == "Devkit HDD Key" set eepromflag2=-defkey
if /i "%eb-eeprom-hddstatus%" == "" echo Key Type not set! && pause && goto EEPROMmenu
echo.
cmd /c %IDW_DIR%\mkeeprom.exe %eepromflag1% %eepromflag2% %_NT386TREE%\boot\eeprom_%ebxbtype%.bin
if NOT exist "%_NT386TREE%\boot\eeprom_%ebxbtype%.bin" echo Build Failed && pause && goto eb-xbox-mainmenu
if exist "%_NT386TREE%\boot\eeprom_%ebxbtype%.bin" echo Build Succeeded at %_NT386TREE%\boot\eeprom_%ebxbtype%.bin && pause
goto eb-xbox-mainmenu

:EEPROMSetNA
set eb-eeprom-origin=North America
goto EEPROMmenu
:EEPROMSetJP
set eb-eeprom-origin=Japan
goto EEPROMmenu
:EEPROMSetROW
set eb-eeprom-origin=Global
goto EEPROMmenu
:EEPROMSetHDD
set eb-eeprom-hddstatus= Zero HDD key
goto EEPROMmenu
:EEPROMSetHDDS
set eb-eeprom-hddstatus=Sequential HDD Key
goto EEPROMmenu
:EEPROMSetHDDD
set eb-eeprom-hddstatus=DevKit HDD Key
goto EEPROMmenu



:BuildBiosImage
Title Easy-Build XBOX Build Environment - RomBld Bios Maker
cls
echo This will try to use 'rombld' to build the Xbox BIOS image.
echo.
echo THIS WILL MOST LIKELY NOT BE BOOTABLE, I HAVE INCLUDED THIS JUST
echo AS A TEST AND EXAMPLE, TO EDIT WHAT SETTINGS ARE USED HERE, EDIT
echo 'EASYBUILD.CMD', GOTO LABLE :BuildBiosImage TO CHANGE OPTIONS THERE.
echo.
echo This will be targeted as an XDK Xbox bios, retail 'XM3' Bioses fails
echo to build due to incorrect 'preloader' size currently.
echo.
echo NOTE: If any files are missing Easy-Build will attempt to rebuild
echo.
echo From what I know built Bios roms from source aren't bootable, 
echo if this is bootable please let me know!
echo. 
pause
if not exist "%_NT386TREE%\boot\xboxbldr.bin" set ebromerror=xboxbldr.bin && goto RombldError
if not exist "%_NT386TREE%\boot\xpreldr.bin" set ebromerror=xpreldr.bin && goto RombldError
if not exist "%_NT386TREE%\xboxkrnl.exe" set ebromerror=xboxkrnl.exe && goto RombldError
if not exist "%_NT386TREE%\boot\inittbl_ret.bin" set ebromerror=inittbl_ret.bin && goto RombldError
if not exist "%_NT386TREE%\boot\romdec32.bin" set ebromerror=romdec32.bin && goto RombldError
if exist "%_NT386TREE%\xboxbios_eb-rombld.bin" rename %_NT386TREE%\xboxbios_eb-rombld.bin xboxbios_eb-rombld-old.bin

cmd /c %_NTDrive%%_NTROOT%\private\sdktools\rombld\obj\i386\rombld.exe /OUT:%_NT386TREE%\xboxbios_%ebxbtype%-rombld.bin /BLDR:%_NT386TREE%\boot\xboxbldr.bin /PRELDR:%_NT386TREE%\boot\xpreldr.bin /KERNEL:%_NT386TREE%\xboxkrnl.exe /INITTBL:%_NT386TREE%\boot\inittbl_ret.bin /SYS:XDK /ROMDEC:%_NT386TREE%\boot\romdec32.bin | tee %_NT386TREE%\rombld.log
echo.
if NOT exist "%_NT386TREE%\xboxbios_%ebxbtype%-rombld.bin" echo Failed!
if exist "%_NT386TREE%\xboxbios_%ebxbtype%-rombld.bin" echo File created at "%_NT386TREE%\xboxbios_%ebxbtype%-rombld.bin"
pause
goto eb-xbox-mainmenu


:RombldError
echo.
echo %ebromerror% is missing.. 
echo Attempting to Rebuild NTOS\BOOTX
pause
REM Rebuild private\ntos to ensure bios ROM files get built (mainly xpreldr.bin)
cd /d %ebntroot%\private\ntos\bootx
build -bcDeFZP
goto BuildBiosImage


:SpecificBLD
Title Easy-Build XBOX Build Environment - Build Specific Folder
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
Title Easy-Build XBOX Build Environment - Copying Kernel Files
cls
echo This is a 'Postbuild' script I made from 'copybins.cmd' and 'copytest.cmd' to
echo place files in %_NT386TREE% instead of an Xbox Dev Kit.. THIS IS NOT AN 'OFFICIAL' SCRIPT
echo This script needs your love! Know how to binplace something? Let me know!
echo.
echo xcopybins
pause
cmd /c xcopybins.cmd | tee %_NT386TREE%\xcopybins.log&& goto eb-xbox-mainmenu

:XDKSampleCD
Title Easy-Build XBOX Build Environment - XDK Sample CD
cls 
echo.
echo Here the XDK Sample CD will be copied and built for Xboxes
echo These are only Xbox Direct Media Samples of:
echo Graphics, Sound and other stuff
echo.
echo The .iso will be placed in %_BINPLACE_ROOT%\XDKSamples%_BUILDVER%.iso
echo.
pause
cmd /c xmakesamples.cmd | tee %_NT386TREE%\xdksamples.log&& goto eb-xbox-mainmenu

:XBRecovery
Title Easy-Build XBOX Build Environment - Recovery Image
cls
echo.
echo This will initiate building the Recovery iso.
echo This is still WIP and will need modifying to complete successfully
echo for now its ran to build what it can, users can look into the script:
echo "xbox\public\tools\hwtrec.cmd" 
echo If they wish to try apply a fix
echo.
pause
start hwtrec -all | tee %_NT386TREE%\hwtrec.log
echo Done you can find the output in %_NT386TREE%\rec_hwtest.iso
pause
goto eb-xbox-mainmenu

:xbsebuild
Title Easy-Build XBOX Build Environment - XBSE Builder
cls
cmd /c xbsebuild.bat
pause
goto eb-extras-menu

:BuildOptions
Title Easy-Build XBOX Build Environment - Build Options
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
if /i "%bldopt%"=="devkit" set NODEVKIT=
if /i "%bldopt%"=="retail" set NODEVKIT=1 && goto BuildOptions
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
REM
REM BVTMONITOR SECTION OF EASYBUILD
REM
REM
REM
REM


:InitBVTTestrun
if defined _BVT_ADDRESS set _BVTUNCSAVEDPATH=%_BVT_ADDRESS%
rem if exist "%_NTDRIVE%%_NTROOT%\public\tools\SavedBVTAddress.txt" for /F "delims=" %%i in (%_NTDRIVE%%_NTROOT%\public\tools\SavedBVTAddress.txt) do set "_BVTUNCSAVEDPATH=%%i"
cls
echo --------------------------------------------------------------------------------------------
echo  Build Verification Testing Setup.                  Last Saved Address:%_BVT_ADDRESS%
echo --------------------------------------------------------------------------------------------
echo.
echo  Providing you have already read the instructions shown in 'BVTMonitor.cmd' we will attempt
echo  to connect to the Shared Folder, then go through the build process 
echo.
echo  The Virtual BVT Will boot up when the files have been placed. 
echo  The network path CAN be used locally i.e No VM needed
echo.
echo  YOU MUST KNOW THE SHARE POINT'S ADDRESS.. TYPE IN THIS FORMAT: \\tsclient\D 
echo.
echo 'easybuild.conf' will now open so you can set your share point, if no changes are needed,
echo just close Notepad and continue to init the BVT session.
echo.
pause
notepad %_EBConf%
echo.
echo Refreshing Config and initilising connection.
pause
set "_BVT_ADDRESS="
for /F "skip=5 delims=" %%i in (%_EBConf%) do if not defined _BVT_ADDRESS set "_BVT_ADDRESS=%%i"
echo %_BVT_ADDRESS%
goto InitBVTConnection

:InitBVTConnection
echo.
if defined _BVT_ADDRESS set "_BVTUNCPATH=%_BVT_ADDRESS%"
net use X: %_BVTUNCPATH%
if exist "X:\BVTMonitor.cmd" echo BVT Shared Drive found >> "X:\xboxbins\NEEDED_BY_BVTMONITOR\BVTConnected.txt" && goto InitBVTConnectSuccess
if NOT exist "X:\BVTMonitor.cmd" echo BVTMONITOR.CMD NOT FOUND, PLEASE REVIEW SETTINGS && pause && goto InitBVTTestrun

:InitBVTConnectSuccess
echo.
echo Connection Succeeded, Checking file paths...
echo.
if not exist "X:\BVT1_XEMU" echo "X:\BVT1_XEMU" Cannot be found! && pause && goto InitBVTTestrun
if not exist "X:\Bldr_Files" echo "X:\Bldr_Files" Cannot be found! && pause && goto InitBVTTestrun
if not exist "X:\xboxbins" echo "X:\xboxbins" Cannot be found! && pause && goto InitBVTTestrun
if exist "X:\BVT1_XEMU\xqemu.exe" echo XQEMU is not supported at this time, please use XEMU && pause && goto InitBVTTestrun
if not exist "X:\BVT1_XEMU\xemuw.exe" echo "X:\BVT1_XEMU\xemuw.exe" Cannot be found! && pause && goto InitBVTTestrun
if not exist "X:\BVT1_XEMU\xbox_hdd.qcow2" echo "X:\BVT1_XEMU\xbox_hdd.qcow2" Cannot be found! && pause && goto InitBVTTestrun
if not exist "X:\Bldr_Files\mcpx.bin" echo "X:\Bldr_Files\mcpx.bin" Cannot be found! && pause && goto InitBVTTestrun
if not exist "X:\xboxbins\NEEDED_BY_BVTMONITOR" echo "X:\xboxbins\NEEDED_BY_BVTMONITOR" Cannot be found! && pause && got InitBVTTestrun
echo Everything seems to be in order!
set _BVTMonSanityChecks=X:\xboxbins\NEEDED_BY_BVTMONITOR
goto StartBVTBuild


:StartBVTBuild
echo Starting Build.
if defined _BVT_KERNEL_ONLY goto StartKernelOnlyBVT
rem if exist "%_NTDRIVE%%_NTROOT%\public\tools\BVTKernelOnly.txt" goto StartKernelOnlyBVT
echo Build Started >> "%_BVTMonSanityChecks%\BuildStarted.txt"
cd /d %_NTDRIVE%%_NTROOT%\private\
if exist "%_NTDRIVE%%_NTROOT%\public\tools\BVTNoCleanBuild.txt" (build -bDeZFP) else (build -bcDeFZP)
if /i "%ebxbtype%" == "fre" copy "%_NTDRIVE%%_NTROOT%\private\build.log" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "fre" copy "%_NTDRIVE%%_NTROOT%\private\build.err" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "fre" copy "%_NTDRIVE%%_NTROOT%\private\build.wrn" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "chk" copy "%_NTDRIVE%%_NTROOT%\private\buildd.log" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "chk" copy "%_NTDRIVE%%_NTROOT%\private\buildd.err" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "chk" copy "%_NTDRIVE%%_NTROOT%\private\buildd.wrn" "%_BVTMonSanityChecks%\"
if exist %_NT386TREE%\xboxkrnl.exe set _BVTKernelBuilt=1
echo PostBuild Finished >> "%_BVTMonSanityChecks%\FinalBuildPrep.txt"
if exist "X:\xboxbins\Release\xboxkrnl.exe" del "X:\xboxbins\Release\xboxkrnl.exe"
if NOT exist "X:\xboxbins\Release\Symbols\" mkdir "X:\xboxbins\Release\Symbols\"
if /i "%_BVTKernelBuilt%" == "1" copy "%_NT386TREE%\xboxkrnl.exe" "X:\xboxbins\Release\xboxkrnl.exe" /Y /V
if /i "%_BVTKernelBuilt%" == "1" copy "%_NT386TREE%\xboxkrnl.pdb" "X:\xboxbins\Release\Symbols\xboxkrnl.pdb" /Y /V
if /i "%_BVTKernelBuilt%" == "1" copy "%_NT386TREE%\xboxkrnl.map" "X:\xboxbins\Release\Symbols\xboxkrnl.map" /Y /V
REM if NOT exist "%_BVTMonSanityChecks%\KernelFound.txt echo Error Detecting Kernel on Network && pause && goto InitBVTTestrun
if exist "X:\xboxbins\Release\xboxkrnl.exe" echo Kernel Successfully Transferred >> %_BVTMonSanityChecks%\KernelRecieved.txt && goto MakeBVTBios
REM if NOT exist "X:\xboxbins\Release\xboxkrnl.exe" echo Xboxkrnl.exe Failed to copy to %_BVTUNCPATH% && goto InitBVTTestrun

:StartKernelOnlyBVT
echo Kernel Build Started >> "%_BVTMonSanityChecks%\BuildStarted.txt"
cd /d %_NTDRIVE%%_NTROOT%\private\ntos
if exist "%_NTDRIVE%%_NTROOT%\public\tools\BVTNoCleanBuild.txt" (build -bDeZFP) else (build -bcDeFZP)
if /i "%ebxbtype%" == "fre" copy "%_NTDRIVE%%_NTROOT%\private\build.log" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "fre" copy "%_NTDRIVE%%_NTROOT%\private\build.err" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "fre" copy "%_NTDRIVE%%_NTROOT%\private\build.wrn" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "chk" copy "%_NTDRIVE%%_NTROOT%\private\buildd.log" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "chk" copy "%_NTDRIVE%%_NTROOT%\private\buildd.err" "%_BVTMonSanityChecks%\"
if /i "%ebxbtype%" == "chk" copy "%_NTDRIVE%%_NTROOT%\private\buildd.wrn" "%_BVTMonSanityChecks%\"
if exist %_NT386TREE%\xboxkrnl.exe set _BVTKernelBuilt=1
echo PostBuild Finished >> "%_BVTMonSanityChecks%\FinalBuildPrep.txt"
if exist "X:\xboxbins\Release\xboxkrnl.exe" del "X:\xboxbins\Release\xboxkrnl.exe"
if NOT exist "X:\xboxbins\Release\Symbols\" mkdir "X:\xboxbins\Release\Symbols\"
if /i "%_BVTKernelBuilt%" == "1" copy "%_NT386TREE%\xboxkrnl.exe" "X:\xboxbins\Release\xboxkrnl.exe" /Y /V
if /i "%_BVTKernelBuilt%" == "1" copy "%_NT386TREE%\xboxkrnl.pdb" "X:\xboxbins\Release\Symbols\xboxkrnl.pdb" /Y /V
if /i "%_BVTKernelBuilt%" == "1" copy "%_NT386TREE%\xboxkrnl.map" "X:\xboxbins\Release\Symbols\xboxkrnl.map" /Y /V
REM if NOT exist "%_BVTMonSanityChecks%\KernelFound.txt echo Error Detecting Kernel on Network && pause && goto InitBVTTestrun
if exist "X:\xboxbins\Release\xboxkrnl.exe" echo Kernel Successfully Transferred >> %_BVTMonSanityChecks%\KernelRecieved.txt && goto MakeBVTBios
REM if NOT exist "X:\xboxbins\Release\xboxkrnl.exe" echo Xboxkrnl.exe Failed to copy to %_BVTUNCPATH% && goto InitBVTTestrun




:MakeBVTBios
if exist "%IDW_DIR%\biospack\boot\xboxkrnl.img" del "%IDW_DIR%\biospack\boot\xboxkrnl.img"
copy "%_NT386TREE%\xboxkrnl.exe" "%IDW_DIR%\biospack\boot\xboxkrnl.img"
%IDW_DIR%\biospack\biospack.exe -t multi -i %IDW_DIR%\biospack\boot\ -o %_NT386TREE%\xboxbios_BVT.bin
if exist "%_NT386TREE%\xboxbios_BVT.bin" (echo Finished! %_NT386TREE%xboxbios_BVT.bin) else (echo Failed && goto eb-xbox-mainmenu )
if exist "X:\xboxbins\Release\xboxbios.bin" del "X:\xboxbins\Release\xboxbios.bin"
copy "%_NT386TREE%\xboxbios_BVT.bin" "X:\xboxbins\Release\xboxbios.bin"
goto WaitForBVTBiosCheck

:WaitForBVTBiosCheck
echo.
echo Waiting for BVT to find Bios.
if exist "%_BVTMonSanityChecks%\BiosFound.txt" goto BVTWaitForSignal
goto WaitForBVTBiosCheck

:BVTWaitForSignal
echo.
echo Waiting for BVT to start up
if exist "%_BVTMonSanityChecks%\VirtualBVTStarted.txt" goto BVTHasStarted
goto BVTWaitForSignal

:BVTHasStarted
echo BVT Started
if not exist "%_BVTMonSanityChecks%\WaitingOnHost.txt" (
echo Waiting on HOST BVT Machine >> "%_BVTMonSanityChecks%\WaitingOnHost.txt" 
)
echo.
echo The Virtual BVT has now started, you can now test.
echo You will be taken to the Main Menu once the test is done.
echo.
if exist "%_BVTMonSanityChecks%\BVTTestFinished.txt" echo Build VM going to Main Menu >> %_BVTMonSanityChecks%\VMGoneHome.txt && pause && goto eb-xbox-mainmenu
goto BVTHasStarted



rem
rem THIS SECTION IS FOR USE WITH DEVELOPER KIT XBOXES (REAL(maybe)) OR CONVERTED FROM RETAIL
rem
rem


:eb-devkit-mainmenu
Title XBOX Development Kit Menu - Easy-Build
if NOT exist "%_NT386TREE%\Transfer" mkdir "%_NT386TREE%\Transfer"
if NOT exist "%_NT386TREE%\XBBACKUPS" mkdir "%_NT386TREE%\XBBACKUPS"
cls
echo -------------------------------------------------------------------------------------------------
echo  XBOX Development Kit Menu - Easy-Build   !!DO NOT FLASH 4400 KERNEL TO A 1.6(b) CONSOLE!!
echo -------------------------------------------------------------------------------------------------
echo  Build Machine:      %COMPUTERNAME%      
echo  XBOX TITLE Address:   %_XBOX_TITLE_IP%
echo  XBOX DEBUG Address: %_XBOX_DEBUG_IP%                       
echo -------------------------------------------------------------------------------------------------
echo  Xbox Ver: %_BUILDVER%  -  %ebxm3build%
echo -------------------------------------------------------------------------------------------------
echo  Here you can interact with your 'Debug' Xbox!  VERY WIP :)
echo  Note any form of flashing the 'Recovery' Disc will fuck up Retail converted Kits!
echo.
echo  This is in VERY early test stages, Will be improved and linked more with the XDK later on.
echo  YOU ACKNOWLEDGE THE RISKS WHEN MODIFYING XBOX FILE CONTENTS. ALWAYS HAVE A BACKUP AT HAND!
echo.
echo -------------------------------------------------------------------------------------------------
echo Tools:                                          
echo  1) Edit Xbox IP Settings (Opens config)        # r) Cold Reboot Xbox
echo  2) Start Debugging Session (xbWatson)          # b) Launch xbExplorer
echo  3)                                             # x) Launch Xbox Command Console
echo -------------------------------------------------------------------------------------------------
echo Misc:
echo  4) Copy XDK Launcher to Console                # 8) Remove XDK Launcher (NOT RECCOMMENDED)
echo  5) Install XDK4400 (NT6+ may have issues)      # 9) 
echo  6) (Xbox) Yelo Neighborhood                    # 10) 
echo  7) Easy-Build Main Menu                        # 11)
echo.
echo _________________________________________________________________________________________________
set /p NTMMENU=Select:
if /i "%NTMMENU%"=="1" goto edit-xbox-ip
if /i "%NTMMENU%"=="2" goto source-debugger
if /i "%NTMMENU%"=="r" goto xbox-reboot
if /i "%NTMMENU%"=="b" start %IDW_DIR%\xbExplorer.exe && goto eb-devkit-mainmenu
if /i "%NTMMENU%"=="x" start cmd.exe /k %_NTDRIVE%%_NTROOT%\public\tools\xbconsole.cmd
if /i "%NTMMENU%"=="3" goto eb-devkit-mainmenu
if /i "%NTMMENU%"=="4" goto debug-dash-setup
if /i "%NTMMENU%"=="5" goto install4400xdk
if /i "%NTMMENU%"=="6" goto xbox-yelo-transfer
if /i "%NTMMENU%"=="7" goto eb-xbox-mainmenu
if /i "%NTMMENU%"=="8" goto remove-debug-dash
if /i "%NTMMENU%"=="9" goto eb-devkit-mainmenu
if /i "%NTMMENU%"=="10" goto eb-devkit-mainmenu
if /i "%NTMMENU%"=="11" goto eb-devkit-mainmenu
if /i "%NTMMENU%"=="x" goto eb-devkit-mainmenu
if /i "%NTMMENU%"=="r" exit /b
if /i "%NTMMENU%"=="var" set && pause && goto eb-devkit-mainmenu
goto eb-devkit-mainmenu


:edit-xbox-ip
cls
echo.
echo Here you can edit the IP Addresses used to connect.
echo.
echo Change the addresses under [XBOX_TITLE_IP] and [XBOX_DEBUG_IP]
echo to match your consoles settings.
echo.
notepad %_EBConf%
echo.
echo When finished, continue to load the new config, then return to the menu.
pause
set "_XBOX_TITLE_IP="
for /F "skip=11 delims=" %%i in (%_EBConf%) do if not defined _XBOX_TITLE_IP set "_XBOX_TITLE_IP=%%i"
echo %_XBOX_TITLE_IP%
echo. 
set "_XBOX_DEBUG_IP="
for /F "skip=9 delims=" %%i in (%_EBConf%) do if not defined _XBOX_DEBUG_IP set "_XBOX_DEBUG_IP=%%i"
echo %_XBOX_DEBUG_IP%
goto eb-devkit-mainmenu


:debug-dash-setup
cls
echo This part still needs work, it copies files to "%_NT386TREE%\Transfer\XDKLauncher"
echo for Users refrence, backs up old files to "%_NT386TREE%\XBBACKUPS" before removing,
echo then copies new files in place.
echo.
echo There seems to be some issues but overall it works and the XDK Launcher is bootable
echo NOTE: This (for now) requires a console with an XDK Launcher already installed.
echo.
echo Type 'back' without quotes to return, or press 'Enter' to continue.
set /p userinput=
if /i "%userinput%" == "back" goto eb-devkit-mainmenu
echo Starting..
if exist "%_NT386TREE%\Transfer\XDKLauncher" del %_NT386TREE%\Transfer\XDKLauncher\*.* /Q 
if not exist "%_NT386TREE%\Transfer\XDKLauncher" mkdir "%_NT386TREE%\Transfer\XDKLauncher"
if not exist "%_NT386TREE%\Transfer\XDKLauncher\devkit" mkdir "%_NT386TREE%\Transfer\XDKLauncher\devkit" 
REM
REM Copy files to placeholder location
REM
xcopy "%_NTBINDIR%\private\test\ui\xshell\tdata\*.*" "%_NT386TREE%\Transfer\XDKLauncher\" /F /E /V
if exist "%_NT386TREE%\Transfer\XDKLauncher\obj" del "%_NT386TREE%\Transfer\XDKLauncher\obj" /Q
if exist "%_NT386TREE%\Transfer\XDKLauncher\objd" del "%_NT386TREE%\Transfer\XDKLauncher\objd" /Q
xcopy "%_NT386TREE%\dump\xshell.xbe" "%_NT386TREE%\Transfer\XDKLauncher\" /F /E /V
xcopy "%_NTBINDIR%\private\test\ui\xshell\DASHBOARD.XBX" "%_NT386TREE%\Transfer\XDKLauncher\" /F /E /V
xcopy "%_NT386TREE%\devkit\xbdm.dll" "%_NT386TREE%\Transfer\XDKLauncher\"
xcopy "%_NT386TREE%\devkit\cydrive.exe" "%_NT386TREE%\Transfer\XDKLauncher\devkit"
echo.
goto debug-copy-dash

:debug-copy-dash
if NOT exist "%_NT386TREE%\dump\xshell.xbe" echo Please build the Xbox Tree first! && pause && goto eb-devkit-mainmenu
echo.
echo.
echo We will now Connect to your Console and place the new files.
echo THIS WILL BACKUP AND REMOVE ANY FILES OF THE SAME NAME.
echo BACKUPS WILL BE STORED AT "%_NT386TREE%\XBBACKUPS"
pause
goto debug-backup-dash

:debug-backup-dash
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xy:\3dinfo %_NT386TREE%\XBBACKUPS\C\
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xy:\data %_NT386TREE%\XBBACKUPS\C\
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xy:\images %_NT386TREE%\XBBACKUPS\C\
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xy:\media %_NT386TREE%\XBBACKUPS\C\
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xy:\menus %_NT386TREE%\XBBACKUPS\C\
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xy:\sounds %_NT386TREE%\XBBACKUPS\C\
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xy:\xshell.xbe %_NT386TREE%\XBBACKUPS\C\
xbcp -x %_XBOX_DEBUG_IP% /y /f /t /r xc:\xbdm.dll %_NT386TREE%\XBBACKUPS\xbdm.dll
if exist "%_NT386TREE%\XBBACKUPS\C\xshell.xbe" goto debug-placing-dash
if NOT exist "%_NT386TREE%\XBBACKUPS\C\xshell.xbe" echo Error backing up files && pause && goto eb-devkit-mainmenu

:debug-placing-dash
xbattrib -x %_XBOX_DEBUG_IP% /r /s /h -ro -hid xy:\
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\3dinfo\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\data\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\images\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\media\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\menus\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\sounds\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\3dinfo
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\data
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\images
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\media
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\menus
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\sounds
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\xshell.xbe
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xc:\xbdm.dll

REM Copy the new files over
xbattrib -x %_XBOX_DEBUG_IP% /r /s /h -ro -hid xy:\
xbcp -x %_XBOX_DEBUG_IP% /r /y /d /t /f %_NTBINDIR%\private\test\ui\xshell\tdata\*.* xy:\
xbcp -x %_XBOX_DEBUG_IP% /y /f %_NT386TREE%\dump\xshell.xbe xy:\xshell.xbe
xbcp -x %_XBOX_DEBUG_IP% /y /f %_NT386TREE%\devkit\xbdm.dll xc:\xbdm.dll
xbattrib -x %_XBOX_DEBUG_IP% /r /s /h -ro -hid xy:\
echo.
echo Dashboard placed. Reboot console to test.
pause
goto eb-devkit-mainmenu

:remove-debug-dash
cls.
echo This will remove all files relating to the XDK Launcher from your console.
echo THIS IS NOT RECOMENDED UNLESS YOU HAVE A BACKUP DASH OR A PLAN OF ACTION.
echo.
echo type 'back' to return or press 'Enter' to continue.
set /p userinput=
if /i "%userinput%" == "back" goto eb-devkit-mainmenu
echo.
echo.
echo Now removing files.
echo. 
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\3dinfo\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\data\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\images\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\media\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\menus\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\sounds\*.*
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\3dinfo
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\data
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\images
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\media
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\menus
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\sounds
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xy:\xshell.xbe
xbdel -x %_XBOX_DEBUG_IP% /r /s /h /f xc:\xbdm.dll
echo.
echo Done! Please Cold Boot your Console.
pause
goto eb-devkit-mainmenu
:debugging-menu
cls
echo.
echo Debugging messages will be handled by 'xbWatson.exe' which is taken from
echo %_NTDRIVE%%_NTROOT%\private\xdktools\watson\xbwatson\
echo.
rem set /p NTMMENU=Select:
rem if /i "%NTMMENU%"=="xbdbg" goto source-debugger
rem if /i "%NTMMENU%"=="2" goto external-debugger
rem if /i "%NTMMENU%"=="home" goto eb-devkit-mainmenu
rem goto debugging-menu
pause
goto source-debugger
:source-debugger
if exist "%_NTDRIVE%%_NTROOT%\private\xdktools\watson\xbwatson\obj\i386\xbwatson.exe" copy "%_NTDRIVE%%_NTROOT%\private\xdktools\watson\xbwatson\obj\i386\xbwatson.exe" "%IDW_DIR%\"
cls
echo.
echo Easy-Build is starting Xbox Debug Message Monitor..
echo.
start %IDW_DIR%\xbwatson.exe
rem start cmd.exe /k %IDW_DIR%\xbdbsmon.exe -x %_XBOX_DEBUG_IP%
echo.
echo.
pause
goto eb-devkit-mainmenu

:external-debugger
cls.
echo We will presume Windbg.
echo Plan to make user place a link to the debugger of choice in public\tools\debugger\
pause
goto eb-devkit-mainmenu

:install4400xdk
cls
echo.
echo  We will attempt to start installation of the XDK 4400,
echo  I know that Easy-Build targets Windows 10 but the XDK is
echo  best supported on Windows XP.
echo  (Windows XP is 'in theory' supported by Easybuild)
echo.
echo  if the setup cnnot be found, it will be built.
echo  VC++ Processor Pack will also be installed.
echo.
ECHO  REQUIRED: The Visual Studio 6, SP5 HAS TO BE INTALLED!
echo  Visual Studio 6: https://archive.org/details/vsp600enu
echo  Visual Studio 6 SP5: https://archive.org/download/vcpp5/vs6sp5.exe
echo.
echo.
echo  The setup will now load:
pause
if /i "%1" == "chk" call setfre.cmd
if not exist "%ProgramFiles%\Microsoft Visual Studio\VC98" echo Visual Studio 6 Not Found && pause && goto eb-devkit-mainmenu
%_NTDrive%%_NTROOT%\Private\SDK\sdkfiles\visualstudio\sp5\vcpp.exe
if NOT exist "%_NT386TREE%\XDKSetup\%_BUILDVER%\XDKSetup%_BUILDVER%.exe" cmd /c %_NTDrive%%_NTROOT%\private\setup\xdk\xdkbuild.bat
if exist "%_NT386TREE%\XDKSetup\%_BUILDVER%\XDKSetup%_BUILDVER%.exe" %_NT386TREE%\XDKSetup\%_BUILDVER%\XDKSetup%_BUILDVER%.exe
if exist "%_NT386TREE%\XDKSetup\%_BUILDVER%\XBSESetup.exe" %_NT386TREE%\XDKSetup\%_BUILDVER%\XBSESetup.exe
if /i "%1" == "chk" call setchk.cmd
goto eb-devkit-mainmenu


:xbox-yelo-transfer
cls
echo.
echo Here you can connect to your Debug Xbox.
echo.
echo NOTE: As 'Xbox Neighborhood' does NOT work on NT6+ we use the 
echo Open Source alternative 'Yelo Neighborhood'.
echo.
echo.
echo Yelo Neighborhood will try to automatically find your XBOX
echo It uses different config to Easy-Buld. Success with this tool varies.
echo If it throws an error, try manually entering your Xbox IP: %_XBOX_DEBUG_IP%
echo.
echo Make sure XBDM.dll is present and you have setup the XDK Launcher.
echo.
echo Continue to start.
pause
cd /d %_NTDRIVE%%_NTROOT%\public\tools\Yelo
"%_Yelo_Nbh_Path%\Yelo Neighborhood.exe"
cd /d %_NTBINDIR%
goto eb-devkit-mainmenu

:debug-perfmon
cls
echo This will load the Xbox Performance Monitor
echo.
%IDW_DIR%\xbperfmon.exe -x %_XBOX_DEBUG_IP%
pause
goto eb-devkit-mainmenu

:xbox-reboot
cls
echo Rebooting XBOX..
%IDW_DIR%\xbreboot -x %_XBOX_DEBUG_IP% -c
rem 
rem usage: xbreboot.exe [/x xboxname] [options] [xbe]
rem         -w      wait for debugger connection after reboot
rem         -c      cold reboot (slow)
rem         -p      prevent debugging after reboot
rem Specify Xbox files as xE:\..., xD:\..., etc.

rem %IDW_DIR%\xbreboot.exe -x
pause
goto eb-devkit-mainmenu
