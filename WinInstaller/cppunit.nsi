; CppUnit for Windows installer script (used by NSIS)
;
; Building the binary installer:
; - Install NSIS (if not yet installed)
; - Right-click on this .nsi file from Windows Explorer
; - Select "Compile NSIS Script"
;

!define CppUnitVersion "1.12.1"

Name "CppUnit - A unit testing framework for C++"

!verbose 3
!include "MUI2.nsh"
!include "WinMessages.NSH"
!verbose 4

; Registry key for where system environment variables are stored.
!define RegEnv '"SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

; Installer file name
OutFile "cppunit-msvc-${CppUnitVersion}.exe"

; Default installation folder
InstallDir "$PROGRAMFILES\CppUnit"

; Get previous installation folder from registry if available.
; If it exists (previous version installed), it overrides InstallDir instruction.
InstallDirRegKey HKLM "Software\CppUnit" ""

; Request administrator privileges for Vista/7
RequestExecutionLevel admin

; "Modern User Interface" (MUI) settings
!define MUI_ABORTWARNING

; Installer pages
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
  
; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
  
; Languages
!insertmacro MUI_LANGUAGE "English"


;===============================================================================
; CppUnit installation section
;===============================================================================

Section "CppUnit"

  ; Header files
  CreateDirectory "$INSTDIR\Include"
  SetOutPath "$INSTDIR\Include"
  File /r /x Makefile* /x *-mac.h /x *-evc*.h /x *-bcb*.h "..\include\cppunit"

  ; Libraries (32 bits)
  CreateDirectory "$INSTDIR\Lib\Release-Win32"
  SetOutPath "$INSTDIR\Lib\Release-Win32"
  File "..\msvc2015\Release-Win32\cppunit.lib"
  CreateDirectory "$INSTDIR\Lib\Debug-Win32"
  SetOutPath "$INSTDIR\Lib\Debug-Win32"
  File "..\msvc2015\Debug-Win32\cppunit.lib"
  File "..\msvc2015\Debug-Win32\cppunit.pdb"

  ; Libraries (32 bits), using "x86" as platform name.
  CreateDirectory "$INSTDIR\Lib\Release-x86"
  SetOutPath "$INSTDIR\Lib\Release-x86"
  File "..\msvc2015\Release-Win32\cppunit.lib"
  CreateDirectory "$INSTDIR\Lib\Debug-x86"
  SetOutPath "$INSTDIR\Lib\Debug-x86"
  File "..\msvc2015\Debug-Win32\cppunit.lib"
  File "..\msvc2015\Debug-Win32\cppunit.pdb"

  ; Libraries (64 bits)
  CreateDirectory "$INSTDIR\Lib\Release-x64"
  SetOutPath "$INSTDIR\Lib\Release-x64"
  File "..\msvc2015\Release-x64\cppunit.lib"
  CreateDirectory "$INSTDIR\Lib\Debug-x64"
  SetOutPath "$INSTDIR\Lib\Debug-x64"
  File "..\msvc2015\Debug-x64\cppunit.lib"
  File "..\msvc2015\Debug-x64\cppunit.pdb"

  ; Visual Studio property file for applications
  SetOutPath "$INSTDIR"
  File "CppUnit.props"

; Add an environment variable to CppUnit root installation
  WriteRegStr HKLM ${RegEnv} "CppUnitRoot" $INSTDIR

  ; Store installation folder in registry
  WriteRegStr HKLM "Software\CppUnit" "" $INSTDIR
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\CppUnitUninstall.exe"
  
  ; Declare uninstaller in Add/Remove control panel
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CppUnit" "DisplayName" "CppUnit Unit Testing Framework for C++"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CppUnit" "UninstallString" "$INSTDIR\CppUnitUninstall.exe"

  ; Notify applications of environment modifications
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

SectionEnd


;===============================================================================
; CppUnit uninstallation section
;===============================================================================

Section "Uninstall"

  ; Uninstaller is in $INSTDIR
  ; Get installation folder from registry
  ReadRegStr $0 HKLM "Software\CppUnit" ""
  SetOutPath "$0\.."

  ; Delete files
  RMDir /r "$0\Include"
  RMDir /r "$0\Lib"
  Delete "$0\CppUnit.props"
  Delete "$0\CppUnitUninstall.exe"
  RMDir "$0"

  ; Delete registry entries
  DeleteRegKey HKLM "Software\CppUnit"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CppUnit"
  DeleteRegValue HKLM ${RegEnv} "CppUnitRoot"

  ; Notify applications of environment modifications
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

SectionEnd
