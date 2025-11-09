@ECHO off


REM  Menu Map
REM
REM  StartMenu ==
REM  StartMenuOpt0_Settings ==
REM  StartMenuOpt0_SettingsOpt1_WorkDir ==
REM  StartMenuOpt0_SettingsOpt1_WorkDirOpt1 --
REM  StartMenuOpt0_SettingsOpt1_WorkDirOpt2 --
REM  StartMenuOpt0_SettingsOpt1_WorkDirOpt3 --
REM  StartMenuOpt0_SettingsOpt1_WorkDirOpt4 --
REM  StartMenuOpt1_FoldersFilesManage ==
REM  StartMenuOpt1_FoldersFilesManageOpt1_Delete ==
REM  StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt1 --
REM  StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt2 --
REM  StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt3 --
REM  StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt4 --
REM  StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt5 --
REM  StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt6 --
REM  StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt7 --
REM  StartMenuOpt1_FoldersFilesManageOpt2_Backup ==
REM  StartMenuOpt1_FoldersFilesManageOpt2_BackupOpt1 --
REM  StartMenuOpt1_FoldersFilesManageOpt2_BackupOpt2 --
REM  StartMenuOpt2_WindowsHelpers ==
REM  StartMenuOpt2_WindowsHelpersOpt1_Firewall ==
REM  StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt1 --
REM  StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt2 --
REM  StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt3 --
REM  StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt4 --
REM  StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt5 --
REM  StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt6 --
REM  StartMenuOpt2_WindowsHelpersOpt2_WinEnv ==
REM  StartMenuOpt3_GitMenu ==
REM  StartMenuOpt3_GitMenuOpt1_GitSettings ==
REM  StartMenuOpt3_GitMenuOpt1_GitSettingsOpt1 --
REM  StartMenuOpt3_GitMenuOpt1_GitSettingsOpt2 --
REM  StartMenuOpt3_GitMenuOpt2_GitSingleRepo ==
REM  StartMenuOpt3_GitMenuOpt2_GitSingleRepo_PleaseRunOutsideRepo --
REM  StartMenuOpt3_GitMenuOpt2_GitSingleRepo_RepoSelected ==
REM  StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt1_Clean --
REM  StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Combos --
REM  StartMenuOpt3_GitMenuOpt3_GitMultiRepo ==
REM  StartMenuOpt4_Placeholder ==
REM


REM  Subroutines
REM  
REM  --general
REM  CALL :Clear
REM  CALL :Goodbye
REM  CALL :EndAllSetLocal
REM  --validations
REM  CALL :ValidateNumber 1 5   -> %result% : 0 nok / 1 ok
REM  CALL :ValidateString_NoWildcards "myStringToValidate"
REM  CALL :ValidateString_WindowsFolderName "myStringToValidate"
REM  CALL :ValidateString_GitRepoName "someGitRepoName"
REM  CALL :ValidateString_NoSpacesOrSymbols "someName"
REM  -- string handeling
REM  CALL :TrimString "myVar"
REM  CALL :RemoveAllSpaces "myVar"
REM  -- other
REM  CALL :DeleteFolderRecurs obj
REM  CALL :FirewallAddBlockRules *.exe *.dll "FireWallMenu"
REM  CALL :FirewallRemoveBlockRules *.exe *.dll








REM =======================================================================================================================
REM Status Check - Set global vars
REM =======================================================================================================================

REM ============ General vars ============
REM Set working directory and original to restore to
SET "originalWorkDir=%cd%"
IF DEFINED originalWorkDir IF "%originalWorkDir:~-1%"=="\" SET "originalWorkDir=%originalWorkDir:~0,-1%"
SET "currentDir=%originalWorkDir%"
REM Check if running with administrator privileges
SET "isAdmin=0"
net session >nul 2>&1
IF %errorlevel%==0 ( SET "isAdmin=1" )

REM User input
SET "input="
REM Some subroutines boolean result: 0 false 1 true
SET "result=0"

REM ============== GIT vars ================
REM Check if Git tool is available and get version
SET "isGitAvailable=0"
SET "gitVersion="
FOR /F "tokens=3" %%G IN ('git --version 2^>nul') DO ( SET "gitVersion=%%G" & SET "isGitAvailable=1" )
REM Default git repo name
SET "defaultGitRepo=develop"

REM ============== Nuget vars ==============
REM Check if NuGet tool is available and get version
REM Note: nuget.exe may exist on the work dir and not environment.
SET "isNugetAvailable=0"
SET "nugetVersion="
FOR /F "tokens=2 delims= " %%N IN ('nuget help 2^>nul ^| findstr /R "^NuGet"') DO ( SET "nugetVersion=%%N" & SET "isNugetAvailable=1" )

REM ============== npm vars ================
REM Check if npm tool is available and get version
SET "isNpmAvailable=0"
SET "npmVersion="
FOR /F "tokens=1" %%N IN ('npm --version 2^>nul') DO ( SET "npmVersion=%%N" & SET "isNpmAvailable=1" )




REM Start Menu ============================================================================================================
:StartMenu
CALL :Clear
ECHO ===========================================================================================
ECHO                                   THIS IS A BATCH TOOL
ECHO ===========================================================================================
ECHO.
ECHO  Current directory: %currentDir%
ECHO  Please select an option:
ECHO.
ECHO   0. Settings
ECHO   1. Folders and Files Management
ECHO   2. Windows Helpers
IF "%isGitAvailable%"=="1" (
    ECHO   3. Git     
) ELSE (
    ECHO   3. Git        [Unavailable: git tool not installed or not found]
)
ECHO   4. Placeholder
ECHO.
ECHO   x. Exit
ECHO.
SET /p input=Enter your input (0-4, x): 
IF /i "%input%"=="x" CALL :Goodbye
CALL :ValidateNumber 0 4
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Use a number between '0' and '4' or 'x' to quit. & PAUSE & GOTO StartMenu ) 
IF "%input%"=="0" GOTO StartMenuOpt0_Settings
IF "%input%"=="1" GOTO StartMenuOpt1_FoldersFilesManage
IF "%input%"=="2" GOTO StartMenuOpt2_WindowsHelpers
IF "%input%"=="3" ( IF "%isGitAvailable%"=="1" ( GOTO :StartMenuOpt3_GitMenu ) ELSE ( ECHO. & ECHO Option unavailable. Git is not installed or not found. & ECHO. & PAUSE & GOTO StartMenu ) )
IF "%input%"=="4" GOTO StartMenuOpt4_Placeholder
GOTO StartMenu






REM ==========================================================================================================================================================================================================
REM                                                                                          Settings
REM ==========================================================================================================================================================================================================


REM StartMenuOpt0_Settings ================================================================================================
:StartMenuOpt0_Settings
CALL :Clear
ECHO ===========================================================================================
ECHO                                   Settings
ECHO ===========================================================================================
ECHO.
ECHO  Original directory: %originalWorkDir%
ECHO  Current directory:  %currentDir%
IF "%isAdmin%"=="1" (
    ECHO  Running with administrator privileges.
) ELSE (
    ECHO  Not running as administrator.
)
ECHO.
IF "%isGitAvailable%"=="1" (
    ECHO     Git: Version %gitVersion%.
) ELSE (
    ECHO     Git: Not available. 
)
IF "%isNugetAvailable%"=="1" (
    ECHO   Nuget: Version %nugetVersion%.
) ELSE (
    ECHO   Nuget: Not available. 
)
IF "%isNpmAvailable%"=="1" (
    ECHO     npm: Version %npmVersion%.
) ELSE (
    ECHO     npm: Not available. 
)
ECHO.
ECHO ===========================================================================================
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Change Work Directory
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
ECHO.
SET /p input=Enter your input (1, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 1
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select number '1', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt0_Settings ) 
IF "%input%"=="1" GOTO StartMenuOpt0_SettingsOpt1_WorkDir
GOTO StartMenuOpt0_Settings




REM ============================================================================ Working Directory ===============================================================================================


REM StartMenuOpt0_SettingsOpt1_WorkDir - Working Directory ================================================================
:StartMenuOpt0_SettingsOpt1_WorkDir
CALL :Clear
ECHO ===========================================================================================
ECHO                                   Working Directory
ECHO ===========================================================================================
ECHO.
ECHO  Original directory: %originalWorkDir%
ECHO  Current directory:  %currentDir%
ECHO.
ECHO   -- Change working Directory ----
ECHO   1. Move up to parent folder
ECHO   2. Choose a subfolder
ECHO   3. Reset to original directory
ECHO.
ECHO   -- Open directory in explorer --
ECHO   4. Original directory
ECHO   5. Current directory
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
ECHO.
SET /P input=Enter your input (1-5, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt0_Settings
CALL :ValidateNumber 1 5
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Use a number between '1' and '5', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt0_SettingsOpt1_WorkDir ) 
IF "%input%"=="1" GOTO StartMenuOpt0_SettingsOpt1_WorkDirOpt1
IF "%input%"=="2" GOTO StartMenuOpt0_SettingsOpt1_WorkDirOpt2
IF "%input%"=="3" GOTO StartMenuOpt0_SettingsOpt1_WorkDirOpt3
IF "%input%"=="4" GOTO StartMenuOpt0_SettingsOpt1_WorkDirOpt4
IF "%input%"=="5" GOTO StartMenuOpt0_SettingsOpt1_WorkDirOpt5
GOTO StartMenuOpt0_SettingsOpt1_WorkDir


REM StartMenuOpt0_SettingsOpt1_WorkDirOpt1 - Move up to parent folder -----------------------------------------------------
:StartMenuOpt0_SettingsOpt1_WorkDirOpt1
CALL :Clear
FOR %%A IN ("%currentDir%\..") DO SET "parentDir=%%~fA"
IF NOT EXIST "%parentDir%" ( ECHO. & ECHO  ERROR: Parent folder not found. & PAUSE & GOTO StartMenuOpt0_SettingsOpt1_WorkDir )
REM remove backslash if exists for safety
IF "%parentDir:~-1%"=="\" SET "parentDir=%parentDir:~0,-1%"
SET "currentDir=%parentDir%" & CD /D "%currentDir%" & SET "parentDir=" & GOTO StartMenuOpt0_SettingsOpt1_WorkDir


REM StartMenuOpt0_SettingsOpt1_WorkDirOpt2 - Choose a subfolder -----------------------------------------------------------
:StartMenuOpt0_SettingsOpt1_WorkDirOpt2
CALL :Clear
SETLOCAL ENABLEDELAYEDEXPANSION
SET "folderCount=0"
ECHO ===========================================================================================
ECHO                                     Choose a Subfolder
ECHO ===========================================================================================
ECHO.
ECHO Scanning for subfolders in:
ECHO   %currentDir%
ECHO.
REM List only immediate subfolders (non-recursive)
FOR /D %%d IN ("%currentDir%\*") DO ( SET /A folderCount+=1 & SET "folder!folderCount!=%%~fd" )
IF !folderCount! EQU 0 ( ECHO No subfolders found in this directory. & ECHO. & ENDLOCAL & PAUSE & GOTO StartMenuOpt0_SettingsOpt1_WorkDir )

ECHO Found !folderCount! subfolder(s):
ECHO.
FOR /L %%i IN (1,1,!folderCount!) DO ( ECHO   %%i. !folder%%i! )
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /P input=Choose a folder (1-!folderCount!, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" ( ENDLOCAL & GOTO StartMenuOpt0_SettingsOpt1_WorkDir )
CALL :ValidateNumber 1 !folderCount!
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Use a number between '1' and '!folderCount!', 'z' to go back or 'x' to quit. & ENDLOCAL & PAUSE & GOTO StartMenuOpt0_SettingsOpt1_WorkDirOpt2 ) 

SET "selectedFolder=!folder%input%!"
ENDLOCAL & SET "selectedFolder=%selectedFolder%"
REM remove backslash if exists for safety
IF "%selectedFolder:~-1%"=="\" SET "selectedFolder=%selectedFolder:~0,-1%"
CD /D "%selectedFolder%"  & SET "currentDir=%selectedFolder%" & SET "selectedFolder=" & GOTO StartMenuOpt0_SettingsOpt1_WorkDir


REM StartMenuOpt0_SettingsOpt1_WorkDirOpt3 - Reset to original directory --------------------------------------------------
:StartMenuOpt0_SettingsOpt1_WorkDirOpt3
CALL :Clear
ECHO  This will reset the working directory 
ECHO   from: %currentDir%
ECHO   to:   %originalWorkDir%
ECHO.
SET /p input=Are you sure you want to continue? y/n: 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt0_SettingsOpt1_WorkDir
IF /i "%input%"=="n" ( ECHO. & ECHO Backup cancelled. & PAUSE & GOTO StartMenuOpt0_SettingsOpt1_WorkDir )
IF /I NOT "%input%"=="y" ( ECHO. & ECHO That's not a valid option. Select either 'y' or 'n' & PAUSE & GOTO StartMenuOpt0_SettingsOpt1_WorkDirOpt3 )
CD /D "%originalWorkDir%" & SET "currentDir=%originalWorkDir%"
ECHO. & ECHO  Working directory has been reset. & ECHO. & PAUSE & GOTO StartMenuOpt0_SettingsOpt1_WorkDir


REM StartMenuOpt0_SettingsOpt1_WorkDirOpt4 - Open original dir in windows explorer -----------------------------------------
:StartMenuOpt0_SettingsOpt1_WorkDirOpt4
CALL :Clear
ECHO Opening original directory in Windows Explorer... & ECHO.
explorer "%originalWorkDir%"
GOTO StartMenuOpt0_SettingsOpt1_WorkDir

REM StartMenuOpt0_SettingsOpt1_WorkDirOpt5 - Open current dir in windows explorer ----------------------------------------
:StartMenuOpt0_SettingsOpt1_WorkDirOpt5
CALL :Clear
ECHO Opening current directory in Windows Explorer... & ECHO.
explorer "%currentDir%"
GOTO StartMenuOpt0_SettingsOpt1_WorkDir






REM ==========================================================================================================================================================================================================
REM                                                                                     Folder and Files Management
REM ==========================================================================================================================================================================================================


REM StartMenuOpt1_FoldersFilesManage - Manage Directories and Files =======================================================
:StartMenuOpt1_FoldersFilesManage
CALL :Clear
ECHO ===========================================================================================
ECHO                              Folder and Files Management
ECHO ===========================================================================================
ECHO.
ECHO  Current directory:  %currentDir%
ECHO.
ECHO   1. Delete Files or Folders recursively
ECHO   2. Create Backup of current directory
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
ECHO.
SET /P input=Enter your input (1-2, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 2
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Use a number between '1' and '2', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt1_FoldersFilesManage ) 
IF "%input%"=="1" GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete
IF "%input%"=="2" GOTO StartMenuOpt1_FoldersFilesManageOpt2_Backup
GOTO StartMenuOpt1_FoldersFilesManage




REM ============================================================================ Delete Files and Folders ===============================================================================================

REM StartMenuOpt1_FoldersFilesManageOpt1_Delete - Delete Files and Folders ================================================
:StartMenuOpt1_FoldersFilesManageOpt1_Delete
CALL :Clear 
ECHO ===========================================================================================
ECHO                                 Delete Files and Folders
ECHO ===========================================================================================
ECHO  Delete files or folders recursively. This actions cannot be undone.
ECHO  Current directory: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   -- Delete folders recursively --
ECHO   1. Delete obj/bin
ECHO   2. Delete packages
ECHO   3. Delete node_modules
ECHO   4. Delete .vs
ECHO   5. Delete .git
ECHO.
ECHO   -- Delete custom recursively ---
ECHO   6. Delete custom folders
ECHO   7. Delete custom files
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-7, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt1_FoldersFilesManage
CALL :ValidateNumber 1 7
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Use a number between '1' and '7', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete ) 
IF "%input%"=="1" GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt1
IF "%input%"=="2" GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt2
IF "%input%"=="3" GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt3
IF "%input%"=="4" GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt4
IF "%input%"=="5" GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt5
IF "%input%"=="6" GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt6
IF "%input%"=="7" GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt7
GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete




REM StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt1 - Delete obj/bin ------------------------------------------------------
:StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt1
CALL :Clear
CALL :DeleteFolderRecurs bin
CALL :DeleteFolderRecurs obj
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete

REM StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt2 - Delete packages -----------------------------------------------------
:StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt2
CALL :Clear
CALL :DeleteFolderRecurs packages
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete

REM StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt3 - Delete node_modules -------------------------------------------------
:StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt3
CALL :Clear
CALL :DeleteFolderRecurs node_modules
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete

REM StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt4 - Delete .vs ----------------------------------------------------------
:StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt4
CALL :Clear
CALL :DeleteFolderRecurs .vs
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete

REM StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt5 - Delete .git (with confirmation) -------------------------------------
:StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt5
CALL :Clear
SET /p confirm=Are you sure you want to delete ALL .git folders? y/n:
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete
IF /i "%input%"=="n" ( ECHO. & ECHO Delete cancelled. & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete )
IF /I NOT "%input%"=="y" ( ECHO. & ECHO That's not a valid option. Select either 'y' or 'n' & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt5 )
CALL :DeleteFolderRecurs .git
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete

REM StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt6 - Delete custom folder ------------------------------------------------
:StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt6
CALL :Clear
ECHO Delete a custom folder recursively.
ECHO Forbidden characters: \ / : * ? ^< ^> ^| not allowed. Quotes " are ignored.
ECHO Press 'z' to cancel and go back to menu or 'x' to exit.
ECHO.
SET /P input=Enter the folder name to delete (e.g. dist, build, temp): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete
CALL :ValidateString_WindowsFolderName "input"
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid input. Please try again. & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt6 ) 
REM Delete folders recursively, safely handling spaces in folder names
ECHO. & ECHO Cleaning "%input%" folders recursively...
FOR /D /R "%currentDir%" %%p IN (*) DO (
    IF /I "%%~nxp"=="%input%" (
        IF EXIST "%%~fp" (
            RD /S /Q "%%~fp"
            IF EXIST "%%~fp" ( ECHO  -- Error: could not completely delete "%%~fp" ) ELSE ( ECHO  -- Deleted "%%~fp" )
        )
    )
)
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete

REM StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt7 - Delete custom files (no wildcards, supports spaces in user input) ---
:StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt7
CALL :Clear
ECHO Delete a custom file recursively.
ECHO Forbidden characters: \ / : * ? ^< ^> ^| not allowed. Quotes " are ignored.
ECHO Press 'z' to cancel and go back to menu or 'x' to exit.
ECHO.
SET /P input=Enter the file name to delete (e.g. app.log, debug.txt): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete
CALL :ValidateString_NoWildcards "input"
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid input. Please try again. & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_DeleteOpt7 ) 
ECHO. & ECHO Cleaning "%input%" files recursively...
REM Change to script directory so relative names behave as expected
PUSHD "%currentDir%" 2>NUL || ( ECHO Failed to change directory to "%currentDir%". & PAUSE & GOTO StartMenuOpt1_Clear )
REM Use DIR to find matching files (handles spaces & quoted names), iterate with FOR /F "delims="
SETLOCAL
FOR /F "usebackq delims=" %%F IN (`DIR /B /S "%input%" 2^>nul`) DO (
    IF EXIST "%%F" (
        DEL /F /Q "%%F" 2>nul
        IF EXIST "%%F" ( ECHO  -- Error: could not completely delete "%%F" ) ELSE ( ECHO  -- Deleted "%%F" )
    )
)
ENDLOCAL
POPD
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt1_Delete




REM ================================================================================= Backup =================================================================================================

REM StartMenuOpt1_FoldersFilesManageOpt2_Backup - Backup ==================================================================
:StartMenuOpt1_FoldersFilesManageOpt2_Backup
CALL :Clear
ECHO ===========================================================================================
ECHO                                         Backup
ECHO ===========================================================================================
ECHO  Perform a copy of current directory: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Quick backup current folder
ECHO   2. Smart backup current folder
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-2, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt1_FoldersFilesManage
CALL :ValidateNumber 1 2
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '2', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt2_Backup ) 
IF "%input%"=="1" GOTO StartMenuOpt1_FoldersFilesManageOpt2_BackupOpt1
IF "%input%"=="2" GOTO StartMenuOpt1_FoldersFilesManageOpt2_BackupOpt2
GOTO StartMenuOpt1_FoldersFilesManageOpt2_Backup



:StartMenuOpt1_FoldersFilesManageOpt2_BackupOpt1
CALL :Clear
SETLOCAL
ECHO Creating quick backup of current folder... & ECHO.
REM Get source directory (user’s current working directory)
SET "srcDir=%currentDir%"
REM Remove trailing backslash if exists
IF DEFINED srcDir IF "%srcDir:~-1%"=="\" SET "srcDir=%srcDir:~0,-1%"
REM Get folder name of current directory
FOR %%A IN ("%srcDir%") DO SET "baseName=%%~nA"
REM Generate timestamp (YYYY-MM-DD_HH-MM)
SET "timestamp=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%"
SET "timestamp=%timestamp: =0%"
REM Define backup destination in the parent directory of srcDir
FOR %%A IN ("%srcDir%\..") DO SET "parentDir=%%~fA"
SET "backupDir=%parentDir%\%baseName%_Backup_%timestamp%"
REM Display info
ECHO Source:      "%srcDir%" & ECHO Destination: "%backupDir%" & ECHO.
REM Perform backup (exclude .bat itself and destination)
robocopy "%srcDir%" "%backupDir%" /E /XD "%backupDir%" /XF "%~f0"
IF %ERRORLEVEL% LSS 8 ( ECHO. & ECHO Backup completed successfully! ) ELSE ( ECHO. & ECHO ERROR: Backup failed with code %ERRORLEVEL%. )
ECHO. & ENDLOCAL & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt2_Backup


REM BackupOpt2 - Smart recursive backup with full exclusions + logging
REM Summary:
REM   Performs a backup copy of all files in the same directory as the bat to a new directory with timestamp.
REM   Automatically excludes unwanted folders like "bin", "obj", "packages", "node_modules",
REM   and asks the user if ".vs" and ".git" are also to be excluded.
REM   Creates a txt file log in the backup folder.
:StartMenuOpt1_FoldersFilesManageOpt2_BackupOpt2
CALL :Clear
ECHO Backup routine started
SETLOCAL ENABLEDELAYEDEXPANSION
REM Define working directories
SET "WorkDirFull=%currentDir%"
IF "%WorkDirFull:~-1%"=="\" SET "WorkDirFull=%WorkDirFull:~0,-1%"
SET "WorkDirName=%~n0"
REM Build timestamp (YYYYMMDD-HHMM)
FOR /F "tokens=1-4 delims=/-. " %%a IN ("%DATE%") DO ( SET "Day=%%a" & SET "Month=%%b" & SET "Year=%%c" )
FOR /F "tokens=1-2 delims=:." %%a IN ("%TIME%") DO ( SET "Hour=%%a" & SET "Min=%%b" )
SET "Hour=%Hour: =0%" & SET "Min=%Min: =0%"
SET "TimeStamp=%Year%%Month%%Day%-%Hour%%Min%"


REM ---------------------------------------------------------------------------------------------------------------------

REM Build backup directory
SET "BackupDir=%WorkDirFull%_Backup_%TimeStamp%"
ECHO.
ECHO Preparing backup:
ECHO Source: "%WorkDirFull%"
ECHO Destination: "%BackupDir%"
ECHO.
ECHO Excluded from backup:
ECHO Directories named: 'bin', 'obj', 'packages' and 'node_modules'. 
ECHO '.git' and '.vs' are optional.
ECHO Script file "%~nx0" will be excluded.
ECHO. & ECHO.
REM 1. Set excluded dirs ==========================================
SET "ExcludeDirs=bin obj packages node_modules"
REM Search for .git folders
ECHO Searching for .git folders...
DIR /S /B /AD "%WorkDirFull%" | FINDSTR /I "\\.git$" >"%TEMP%\gitlist.txt"
IF EXIST "%TEMP%\gitlist.txt" (
    FOR /F "usebackq delims=" %%G IN ("%TEMP%\gitlist.txt") DO ECHO Found .git: "%%G"
    SET /P "IncludeGit=Include the above .git folders in the backup? y/n: "
) ELSE ( SET "IncludeGit=None" & ECHO No .git folders found. )

IF /I "%IncludeGit%"=="N" ( SET "ExcludeDirs=%ExcludeDirs% .git" )
ECHO. & ECHO.
REM Search for .vs folders
ECHO Searching for .vs folders...
DIR /S /B /AD "%WorkDirFull%" | FINDSTR /I "\\.vs$" >"%TEMP%\vslist.txt"
IF EXIST "%TEMP%\vslist.txt" (
    FOR /F "usebackq delims=" %%V IN ("%TEMP%\vslist.txt") DO ECHO Found .vs: "%%V"
    SET /P "IncludeVs=Include the above .vs folders in the backup? y/n: "
) ELSE ( SET "IncludeVs=None" & ECHO No .vs folders found. )
IF /I "%IncludeVs%"=="N" ( SET "ExcludeDirs=%ExcludeDirs% .vs" )
ECHO. & ECHO.
REM Confirm proceed
SET /P "Confirm=Proceed with the backup? y/n: "
IF /I NOT "%Confirm%"=="y" ( ECHO Backup cancelled. & ENDLOCAL & GOTO StartMenuOpt1_FoldersFilesManageOpt2_Backup )
REM 2. Start backup ===============================================
ECHO. & ECHO Starting copy... & ECHO.
IF NOT EXIST "%BackupDir%" MKDIR "%BackupDir%"
REM Build robocopy exclusion string -------------------------------
SET "ExcludeDirsStr="
FOR %%X IN (%ExcludeDirs%) DO SET "ExcludeDirsStr=!ExcludeDirsStr! %%X"

SET "RoboLog=%BackupDir%\robocopy_temp.log"
ROBOCOPY "%WorkDirFull%" "%BackupDir%" /E /COPY:DAT /R:2 /W:1 /V /NP ^
/LOG:"%RoboLog%" ^
/XD %ExcludeDirsStr% /XF "%~nx0"

SET "Rc=%ERRORLEVEL%"
ECHO.
ECHO ROBOCOPY returned RC: %Rc%

REM 3. Create final log ===========================================
SET "MainLog=%BackupDir%\backup_log_%TimeStamp%.txt"
ECHO Creating log...
(
    ECHO Backup completed on %DATE% %TIME% & ECHO. & ECHO Source: %WorkDirFull% & ECHO Destination: %BackupDir% & ECHO. & ECHO Excluded folders: %ExcludeDirs% & ECHO.
    REM .git folders logging
    IF EXIST "%TEMP%\gitlist.txt" ( IF /I "%IncludeGit%"=="N" ( ECHO .git folders were excluded: & TYPE "%TEMP%\gitlist.txt" ) ELSE IF /I "%IncludeGit%"=="Y" ( ECHO .git folders were included. ) ELSE ( ECHO No .git folders found. ) & ECHO. ) ELSE ( ECHO No .git folders found. & ECHO. )
    REM .vs folders logging
    IF EXIST "%TEMP%\vslist.txt" ( IF /I "%IncludeVs%"=="N" ( ECHO .vs folders were excluded: & TYPE "%TEMP%\vslist.txt" ) ELSE IF /I "%IncludeVs%"=="Y" ( ECHO .vs folders were included. ) ELSE ( ECHO No .vs folders found. ) & ECHO. ) ELSE ( ECHO No .vs folders found. & ECHO. )
	REM Robocopy logging
    ECHO Robocopy details: & ECHO ---------------------------------------------------------------
    IF EXIST "%RoboLog%" TYPE "%RoboLog%"
) > "%MainLog%"

DEL "%RoboLog%" >NUL 2>&1
IF %Rc% GEQ 8 (
    ECHO [ERROR] Robocopy failed. Cleaning up...
    RMDIR /S /Q "%BackupDir%"
    MKDIR "%BackupDir%"
    ECHO Backup failed with RC %Rc% on %DATE% %TIME% > "%MainLog%"
)
ECHO Done! & ECHO Backup log saved: "%MainLog%" & ECHO.
ENDLOCAL & PAUSE & GOTO StartMenuOpt1_FoldersFilesManageOpt2_Backup







REM ==========================================================================================================================================================================================================
REM                                                                                          Windows Helpers
REM ==========================================================================================================================================================================================================


REM StartMenuOpt2_WindowsHelpers - Windows Helpers ========================================================================
:StartMenuOpt2_WindowsHelpers
CALL :Clear
ECHO ===========================================================================================
ECHO                                   Windows Helpers
ECHO ===========================================================================================
ECHO  Some Windows helper commands.
ECHO  Current directory:  %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
IF "%isAdmin%"=="1" (
    ECHO   1. Windows Firewall rules
) ELSE (
    ECHO   1. Windows Firewall rules   [Unavailable: needs administrator privileges]
)
ECHO   2. Windows Environment
ECHO.
ECHO   z. Back 
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-2, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 2
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option.  Select a number between '1' and '2', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt2_WindowsHelpers )
IF "%input%"=="1" ( IF "%isAdmin%"=="1" ( GOTO StartMenuOpt2_WindowsHelpersOpt1_Firewall ) ELSE ( ECHO. & ECHO Option unavailable. Administrator privileges required. & ECHO. & PAUSE & GOTO StartMenuOpt2_WindowsHelpers ) )
IF "%input%"=="2" GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnv
GOTO StartMenuOpt2_WindowsHelpers



REM ================================================================================= Windows Firewall =================================================================================================


REM StartMenuOpt2_WindowsHelpersOpt1_Firewall - Windows Firewall ==========================================================
:StartMenuOpt2_WindowsHelpersOpt1_Firewall
CALL :Clear
ECHO ===========================================================================================
ECHO                                   Windows Firewall
ECHO ===========================================================================================
ECHO  Searches for files recursively and adds/deletes rules on Windows Firewall to block
ECHO  all incoming and outgoing trafic. This option requires Administrator rights.
ECHO  Current directory:  %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   -- Add web trafic block ------------
ECHO   1. EXE and DLL files
ECHO   2. COM, SCR, CPL, OCX and SYS files
ECHO   3. All the above
ECHO.
ECHO   -- Remove web trafic block ---------
ECHO   4. EXE and DLL files
ECHO   5. COM, SCR, CPL, OCX and SYS files
ECHO   6. All the above
ECHO.
ECHO   z. Back 
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-6, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt2_WindowsHelpers
CALL :ValidateNumber 1 6
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '6', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt2_WindowsHelpersOpt1_Firewall )
IF "%input%"=="1" GOTO StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt1
IF "%input%"=="2" GOTO StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt2
IF "%input%"=="3" GOTO StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt3
IF "%input%"=="4" GOTO StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt4
IF "%input%"=="5" GOTO StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt5
IF "%input%"=="6" GOTO StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt6
GOTO StartMenuOpt2_WindowsHelpersOpt1_Firewall


REM StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt1: Block web traffic - Block all EXE and DLL files ---------------------------------------------------------
:StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt1
CALL :Clear
CALL :FirewallAddBlockRules *.exe *.dll
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt2: Block web traffic - COM, SCR, CPL, OCX and SYS files ----------------------------------------------------
:StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt2
CALL :Clear
CALL :FirewallAddBlockRules *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt3: Block web traffic - All the above -----------------------------------------------------------------------
:StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt3
CALL :Clear
CALL :FirewallAddBlockRules *.exe *.dll *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt4: Remove web trafic block - EXE and DLL files -------------------------------------------------------------
:StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt4
CALL :Clear
CALL :FirewallRemoveBlockRules *.exe *.dll
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt5: Remove web trafic block - COM, SCR, CPL, OCX and SYS files ----------------------------------------------
:StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt5
CALL :Clear
CALL :FirewallRemoveBlockRules *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt6: Remove web trafic block -  All the above  ---------------------------------------------------------------
:StartMenuOpt2_WindowsHelpersOpt1_FirewallOpt6
CALL :Clear
CALL :FirewallRemoveBlockRules *.exe *.dll *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall





REM StartMenuOpt2_WindowsHelpersOpt2_WinEnv - Windows Environment =========================================================
:StartMenuOpt2_WindowsHelpersOpt2_WinEnv
CALL :Clear
ECHO ===========================================================================================
ECHO                                  Windows Environment
ECHO ===========================================================================================
ECHO  Windows Environment Variables helper commands.
ECHO  Current directory:  %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   -- List Environment Variables --
ECHO   1. All
ECHO   2. Filtered by current directory
ECHO.
ECHO   -- Set Environment Variables ---
ECHO   3. Set current dir. as env. variable
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-3, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt2_WindowsHelpers
CALL :ValidateNumber 1 3
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '3', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnv )
IF "%input%"=="1" GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt1
IF "%input%"=="2" GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt2
IF "%input%"=="3" GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt3
GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnv


REM StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt1: List all environment variables -------------------------------------------
:StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt1
CALL :Clear
ECHO Listing all environment variables... & ECHO Note that some vars from the current bat session will appear. & ECHO.
set | more
ECHO. & ECHO Done.
PAUSE
GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnv


REM StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt2: List variables containing currentDir -------------------------------------
:StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt2
CALL :Clear
ECHO Listing environment variables that reference the current directory... & ECHO Note that some vars from the current bat session will appear. & ECHO.
ECHO Current directory: %currentDir%
ECHO.
set | find /I "%currentDir%"
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO. & ECHO Done.
) ELSE (
    ECHO. & ECHO No environment variables contain the current directory path.
)
PAUSE
GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnv


REM StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt3: Set current directory as environment variable ----------------------------
:StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt3
CALL :Clear
ECHO This will set the current directory as a Windows environment variable.
ECHO.
ECHO NOTE: This change will not affect the current session.
ECHO       You will need to restart the script or open a new Command Prompt.
ECHO.
SET /p someName=Enter a name for the environment variable (no spaces, e.g. MYWORKDIR): 
CALL :ValidateString_NoSpacesOrSymbols "someName"
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Enter a valid name with no spaces and symbols, or press 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnvOpt3 )
ECHO.
ECHO Setting %someName% = "%currentDir%" ...
setx "%someName%" "%currentDir%"
ECHO.
IF %ERRORLEVEL%==0 ( ECHO Variable set successfully! ) ELSE ( ECHO ERROR: Failed to set the environment variable. Exit code: %ERRORLEVEL% )
SET "someName=" & PAUSE & GOTO StartMenuOpt2_WindowsHelpersOpt2_WinEnv










REM ==========================================================================================================================================================================================================
REM                                                                                                Git
REM ==========================================================================================================================================================================================================



REM StartMenuOpt3_GitMenu - Git Menu ======================================================================================
:StartMenuOpt3_GitMenu
CALL :Clear
ECHO ===========================================================================================
ECHO                                        Git Menu
ECHO ===========================================================================================
ECHO  Perform git commands on repos.
ECHO  Current directory: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Git Settings
ECHO   2. Select a repo on a subfolder
ECHO   3. Perform commands on all subfolder repos
ECHO.
ECHO   z. Back 
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-3, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 3
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '3', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenu )
IF "%input%"=="1" GOTO StartMenuOpt3_GitMenuOpt1_GitSettings
IF "%input%"=="2" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo
IF "%input%"=="3" GOTO StartMenuOpt3_GitMenuOpt3_GitMultiRepo
GOTO StartMenuOpt3_GitMenu




REM ==================================================================================== Git Settings =================================================================================================

REM StartMenuOpt3_GitMenuOpt1_GitSettings: sub menu -----------------------------------------------------------------------
:StartMenuOpt3_GitMenuOpt1_GitSettings
CALL :Clear
ECHO ===========================================================================================
ECHO                                     Git - Settings
ECHO ===========================================================================================
ECHO  Git version: %gitVersion%.
ECHO  Current directory: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Change default repo (currently: '%defaultGitRepo%')
ECHO   2. Reset default repo to 'develop'
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-2, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt3_GitMenu
CALL :ValidateNumber 1 2
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '2', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt1_GitSettings )
IF "%input%"=="1" GOTO StartMenuOpt3_GitMenuOpt1_GitSettingsOpt1
IF "%input%"=="2" GOTO StartMenuOpt3_GitMenuOpt1_GitSettingsOpt2
GOTO StartMenuOpt3_GitMenuOpt1_GitSettings


REM StartMenuOpt3_GitMenuOpt1_GitSettingsOpt1: Change default repo -----------------------------------------
:StartMenuOpt3_GitMenuOpt1_GitSettingsOpt1
CALL :Clear
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO Forbidden characters: \ / : * ? ^< ^> ^|
ECHO Quotes " are removed.
ECHO.
SET /P "tempGitRepo=Enter new default repo name: "
REM Validate repo name
CALL :ValidateString_GitRepoName "tempGitRepo"
IF "%result%"=="0" ( ECHO. & ECHO That's not valid. Try again. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt1_GitSettingsOpt1 )
ENDLOCAL & SET "defaultGitRepo=%tempGitRepo%"
ECHO. & ECHO Default repository changed to: "%defaultGitRepo%" & PAUSE
GOTO StartMenuOpt3_GitMenuOpt1_GitSettings


REM StartMenuOpt3_GitMenuOpt1_GitSettingsOpt2: Reset default repo to 'develop' -----------------------------
:StartMenuOpt3_GitMenuOpt1_GitSettingsOpt2
SET "defaultGitRepo=develop" & ECHO. & ECHO Default repo changed back to 'develop' & PAUSE & GOTO StartMenuOpt3_GitMenuOpt1_GitSettings







REM ==================================================================================== Git Single Repo =================================================================================================


REM StartMenuOpt3_GitMenuOpt2_GitSingleRepo - Choose a subfolder repo =====================================================
:StartMenuOpt3_GitMenuOpt2_GitSingleRepo
CALL :Clear
IF EXIST "%currentDir%\.git" ( IF "%currentDir%"=="%originalWorkDir%" ( GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo_PleaseRunOutsideRepo ) )

SETLOCAL ENABLEDELAYEDEXPANSION
ECHO ===========================================================================================
ECHO                                         Git
ECHO ===========================================================================================
ECHO.
ECHO  Current directory:  %currentDir%

REM If not running in a git repo, search for repositories in subfolders recursively
ECHO Scanning for Git repositories...
SET gitRepoCount=0
FOR /r "%currentDir%" %%d IN (.) DO ( IF EXIST "%%d\.git" ( SET /a gitRepoCount+=1 & SET "repo!gitRepoCount!=%%~fd" ) )
REM If no repositories are found
IF %gitRepoCount%==0 ( ECHO. & ECHO No Git repositories found in this folder or its subfolders. & ECHO. & ENDLOCAL & PAUSE & GOTO StartMenuOpt3_GitMenu )
REM Git repositories menu
ECHO Found %gitRepoCount% repositories:
ECHO. 
FOR /l %%i IN (1,1,%gitRepoCount%) DO ( ECHO   %%i. !repo%%i! )
ECHO. 
ECHO   z. Back
ECHO   x. Exit
ECHO. 
SET /p input=Choose a repository (1-%gitRepoCount%, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt3_GitMenu
CALL :ValidateNumber 1 %gitRepoCount%
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '%gitRepoCount%', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenu )

SET "selectedRepo=!repo%input%!"
ENDLOCAL & SET "selectedRepo=%selectedRepo%"

REM Check if bat in same folder as repo. If it is, don't allow it
IF EXIST "%selectedRepo%\.git" ( 
	REM Normalize path
	FOR %%A IN ("%selectedRepo%") DO SET "selectedRepo=%%~fA"
	IF "%selectedRepo:~-1%"=="\" SET "selectedRepo=%selectedRepo:~0,-1%"
	IF "%selectedRepo%"=="%originalWorkDir%" ( 
		ECHO.
		ECHO Performing git commands in the same directory as the bat is not allowed.
		ECHO Please choose another repository.
		SET "selectedRepo=" & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo
	)
)
SET "currentDir=%selectedRepo%" & SET "selectedRepo="
CD /d "%currentDir%"
GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo_RepoSelected


REM StartMenuOpt3_GitMenuOpt2_GitSingleRepo_PleaseRunOutsideRepo: sub menu ----------------------------------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepo_PleaseRunOutsideRepo
CALL :Clear
ECHO ===========================================================================================
ECHO                                           Git
ECHO ===========================================================================================
ECHO.
ECHO  Git commands cannot be executed while this script is running inside the same repository
ECHO  folder that contains the batch file.
ECHO.
ECHO  To use Git options safely, do one of the following:
ECHO.
ECHO    - Move this batch file to the parent directory above your repo, then run it again.
ECHO      (It will automatically detect any .git folders in its subdirectories.)
ECHO.
ECHO    - Or, go to the '0. Status' menu and change the working directory to any other
ECHO      repository you want to manage.
ECHO.
ECHO  This prevents Git commands from accidentally affecting or deleting the batch file itself.
ECHO.
ECHO ===========================================================================================
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /P "input=Press 'z' or 'x' to continue: "
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
IF /i NOT "%input%"=="z"( ECHO. & ECHO That's not a valid option. Select 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo_PleaseRunOutsideRepo )
GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo_PleaseRunOutsideRepo


REM StartMenuOpt3_GitMenuOpt2_GitSingleRepo_RepoSelected: sub menu --------------------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepo_RepoSelected
CALL :Clear
ECHO ===========================================================================================
ECHO                                         Git
ECHO ===========================================================================================
ECHO  Perform Git commands on the chosen repository.
ECHO  Git Version %gitVersion%, default repo: "%defaultGitRepo%".
ECHO  Repo: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Settings
ECHO   2. Clean and Reset commands
ECHO   3. Combos
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-3, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 3
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '3', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo_RepoSelected )
IF "%input%"=="1" GOTO StartMenuOpt3_GitMenuOpt1_GitSettings
IF "%input%"=="2" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean
IF "%input%"=="3" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos
GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepo_RepoSelected




REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean: sub menu -----------------------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean
CALL :Clear
ECHO ===========================================================================================
ECHO                             Git - Clean and Reset commands
ECHO ===========================================================================================
ECHO  Perform Git commands on the chosen repository.
ECHO  Repo: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Restore tracked files               'git checkout .'
ECHO   2. Remove untracked files and dirs.    'git clean -fd'
ECHO   3. Remove everything untracked.        'git clean -fdx'
ECHO   4. Prune branches                      'git fetch --prune'
ECHO   5. Checkout to default                 'git checkout %defaultGitRepo%'
ECHO   6. Pull                                'git pull'
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-6, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 6
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '6', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenu )
IF "%input%"=="1" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt1
IF "%input%"=="2" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt2
IF "%input%"=="3" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt3
IF "%input%"=="4" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt4
IF "%input%"=="5" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt5
IF "%input%"=="6" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt6
GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean


REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt1: Restore tracked files ------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt1
CALL :Clear
ECHO Restoring tracked files... & ECHO.
git checkout .
ECHO. & IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean

REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt2: Remove untracked files and dirs. -------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt2
CALL :Clear
ECHO This will delete all untracked files and directories.
SET /p input=Are you sure you want to remove untracked files and directories? y/n: 

IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean
IF /i "%input%"=="n" ( ECHO. & ECHO Command cancelled. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean )
IF /I NOT "%input%"=="y" ( ECHO. & ECHO That's not a valid option. Select either 'y' or 'n' & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt3 )

ECHO Removing untracked files and directories... & ECHO.
git clean -fd
ECHO. & IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean

REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt3: Remove everything untracked. -----------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt3
CALL :Clear
ECHO This will delete all untracked files and directories and also everything that is in .gitignore.

SET /p input=Are you sure you want to remove EVERYTHING untracked? y/n: 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean
IF /i "%input%"=="n" ( ECHO. & ECHO Command cancelled. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean )
IF /I NOT "%input%"=="y" ( ECHO. & ECHO That's not a valid option. Select either 'y' or 'n' & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt3 )

ECHO Removing everything untracked...
git clean -fdx
ECHO. & IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean

REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt4: Prune branches -------------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt4
CALL :Clear
ECHO Prune branches... & ECHO.
git fetch --prune
ECHO. & IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean

REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt5: Checkout to default repo (develop) -----------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt5
CALL :Clear
ECHO Checking out to %defaultGitRepo%... & ECHO.
git checkout %defaultGitRepo%
ECHO. & IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean

REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt6: Pull -----------------------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_CleanOpt6
CALL :Clear
ECHO Pulling... & ECHO.
git pull
ECHO. & IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt2_Clean




REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos: sub menu ----------------------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos
CALL :Clear
ECHO ===========================================================================================
ECHO                                    Git - Combos
ECHO ===========================================================================================
ECHO  Perform Git commands on the chosen repository.
ECHO  Repo: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Reset branch 
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 1
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select number '1', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos )
IF "%input%"=="1" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_CombosOpt1
GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos



REM StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_CombosOpt1: Combo - Reset -------------------------------------------------
:StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_CombosOpt1
CALL :Clear
ECHO Combo - Reset branch 
ECHO This will perform several git commands:
ECHO.
ECHO  1) Restore tracked files;             'git checkout .'
ECHO  2) Remove all untracked;              'git clean -fdx'
ECHO  3) Checkout to develop;               'git checkout develop'
ECHO  4) Pull;                              'git pull'
ECHO  5) Prune branches.                    'git fetch --prune'
ECHO.
SET /p input=Are you sure you want to proceed? y/n : 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos
IF /i "%input%"=="n" ( ECHO. & ECHO Command cancelled. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos )
IF /I NOT "%input%"=="y" ( ECHO. & ECHO That's not a valid option. Select either 'y' or 'n' & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_CombosOpt1 )
ECHO. & ECHO Running full git reset sequence... & ECHO.

REM 1. Restore tracked files
ECHO Step 1: Restore tracked files 'git checkout .'
git checkout .
ECHO. & IF errorlevel 1 ( ECHO ERROR: 'git checkout .' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos )

REM 2. Remove untracked files
ECHO Step 2: Remove untracked files 'git clean -fd'
git clean -fd
ECHO. & IF errorlevel 1 ( ECHO ERROR: 'git clean -fd' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos )

REM 3. Checkout to develop
ECHO Step 3: Checkout to develop -git checkout develop
git checkout develop
ECHO. & IF errorlevel 1 ( ECHO ERROR: 'git checkout develop' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos )

REM 4. Pull
ECHO Step 4: Pull -git pull
git pull
ECHO. & IF errorlevel 1 ( ECHO ERROR: 'git pull' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos )

REM 5. Prune branches
ECHO Step 5: Prune branches -git fetch --prune
git fetch --prune
ECHO. & IF errorlevel 1 ( ECHO ERROR: 'git fetch --prune' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos )
ECHO. & ECHO All commands completed. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt2_GitSingleRepoOpt3_Combos





REM ==================================================================================== Git Multi Repo =================================================================================================

REM StartMenuOpt3_GitMenuOpt3_GitMultiRepo: Git multi repo menu -----------------------------------------------------------
:StartMenuOpt3_GitMenuOpt3_GitMultiRepo
CALL :Clear
ECHO ===========================================================================================
ECHO                                         Git 
ECHO ===========================================================================================
ECHO  Git version: %gitVersion%.
ECHO  Repo: %currentDir%
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Comming soon
ECHO   2. Comming soon
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-2, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenuOpt3_GitMenu
CALL :ValidateNumber 1 2
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '2', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt3_GitMenuOpt3_GitMultiRepo )
IF "%input%"=="1" GOTO StartMenuOpt3_GitMenuOpt3_GitMultiRepo
IF "%input%"=="2" GOTO StartMenuOpt3_GitMenuOpt3_GitMultiRepo
GOTO StartMenuOpt3_GitMenuOpt3_GitMultiRepo







REM ==========================================================================================================================================================================================================
REM                                                                                            Placeholder
REM ==========================================================================================================================================================================================================


REM =======================================================================================================================
REM StartMenuOpt5_Placeholder - Placeholder
REM StartMenuOpt4_Placeholder
:StartMenuOpt4_Placeholder
CALL :Clear 
ECHO ===========================================================================================
ECHO                                   Placeholder
ECHO ===========================================================================================
ECHO  Placeholder for something.
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Go to something
ECHO   2. Did I mention that this is just a placeholder?
ECHO   3. Bla bla bla
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.
SET /p input=Enter your choice (1-3, z, x): 
IF /i "%input%"=="x" CALL :Goodbye
IF /i "%input%"=="z" GOTO StartMenu
CALL :ValidateNumber 1 3
IF "%result%"=="0" ( ECHO. & ECHO That's not a valid option. Select a number between '1' and '3', 'z' to go back or 'x' to quit. & PAUSE & GOTO StartMenuOpt4_Placeholder ) 
IF "%input%"=="1" GOTO StartMenuOpt4_PlaceholderOpt1
IF "%input%"=="2" GOTO StartMenuOpt4_PlaceholderOpt2
IF "%input%"=="3" GOTO StartMenuOpt4_PlaceholderOpt3
GOTO StartMenuOpt4_Placeholder

:StartMenuOpt4_PlaceholderOpt1
CALL :Clear
ECHO Yup, you got it... & PAUSE & GOTO StartMenuOpt4_Placeholder

:StartMenuOpt4_PlaceholderOpt2
CALL :Clear
ECHO Almost!... & PAUSE & GOTO StartMenuOpt4_Placeholder

:StartMenuOpt4_PlaceholderOpt3
CALL :Clear
ECHO Your mamma is so fat... & PAUSE & GOTO StartMenuOpt4_Placeholder















REM   Subroutines =========================================================================================================


REM General ---------------------------------------------------------------------------------------------------------------

:Clear
REM summary: clears console and common use variables and ends all locals
REM   usage: CALL :Clear
CALL :EndAllSetLocal & CLS & SET "input=" &  SET "result=0" & EXIT /B

:Goodbye
REM summary: prints goodbye and exits
REM   usage: CALL :Goodbye
ECHO. & ECHO Exiting... Goodbye! & PAUSE & EXIT

:EndAllSetLocal
REM summary: tries to end all local scopes, harmless if none
REM   usage: CALL :EndAllSetLocal
FOR /L %%A IN (1,1,50) DO ENDLOCAL & EXIT /B



REM Validations -----------------------------------------------------------------------------------------------------------

:ValidateNumber
REM Summary.: validates a number between param values
REM Param %1: min valid number
REM Param %2: max valid number
REM Usage...: CALL :ValidateNumber 1 5 
REM returns:
REM   %result% with 0 - invalid, not a number between %~1 and %~2
REM   %result% with 1 - valid number

SET "result=0"
REM Empty validation
IF "%input%"=="" ( EXIT /B ) 
REM Numeric validation
FOR /f "delims=0123456789" %%A IN ("%input%") DO ( EXIT /B )
REM less than %~1 validation
IF %input% LSS %~1 ( EXIT /B )
REM Greater than %~2 validation
IF %input% GTR %~2 ( EXIT /B )
REM Valid number, set ok result and continue
SET "result=1" & EXIT /B


:ValidateString_NoWildcards
REM Summary..: Validates input string: no empty value or wildcards allowed
REM Param %1: variable name (e.g., myStringToValidate) <-- IMPORTANT: pass the name, not %value%
REM Usage...: CALL :ValidateString_NoWildcards "myStringToValidate"
REM returns.:
REM   %result% with 0 - invalid string, either empty or with wildcards '*' or '?'
REM   %result% with 1 - valid string

SET "result=0" 
SETLOCAL ENABLEDELAYEDEXPANSION
REM Get value of the variable
REM   SET "input=!%~1!" gets the value of the variable whose name was passed in (%1).
REM   We pass the name (not the value) so we can later clear or update it after ENDLOCAL.
SET "input=!%~1!"
REM Strip surrounding quotes if exist
SET "input=!input:"=!"
REM Empty validation
IF "!input!"=="" ( EXIT /B ) 
REM Check wildcards
ECHO.!input! | FINDSTR "\*" >nul
IF !ERRORLEVEL! EQU 0 ( EXIT /B )
ECHO.!input! | FINDSTR "\?" >nul
IF !ERRORLEVEL! EQU 0 ( EXIT /B )
REM Valid string, keep value
ENDLOCAL & ( SET "%~1=%input%" & SET "result=1" )
EXIT /B


:ValidateString_WindowsFolderName
REM Summary..: Validates if a string is a valid Windows folder name. Double-quotes are just removed.
REM Param %1.: variable name (e.g., folderNameVar) <-- pass the variable name, not its value
REM Returns..:
REM   %result% = 0 → invalid (empty or has forbidden chars)
REM   %result% = 1 → valid
REM Usage.....: CALL :ValidateString_WindowsFolderName "folderNameVar"

SET "result=0"
SETLOCAL ENABLEDELAYEDEXPANSION
REM Get actual value
SET "input=!%~1!"
SET "input=!input:"=!"
REM Empty or reserved dots validation
IF "!input!"=="" ( ENDLOCAL & EXIT /B )
IF "!input!"=="."  ( ENDLOCAL & EXIT /B )
IF "!input!"==".." ( ENDLOCAL & EXIT /B )
REM Forbidden characters: \ / : * ? " < > |
REM Check forbidden characters - double-quote already removed
ECHO(!input!| FINDSTR /R "[\\/:*?<>|]" >NUL
IF !ERRORLEVEL! EQU 0  ( ENDLOCAL & EXIT /B )
REM Names cannot end with a space or a dot
IF "!input:~-1!"==" " ( ENDLOCAL & EXIT /B )
IF "!input:~-1!"=="." ( ENDLOCAL & EXIT /B )
REM Valid string, pass it back
ENDLOCAL & ( SET "%~1=%input%" & SET "result=1" )
EXIT /B


:ValidateString_GitRepoName
REM Summary..: Validates if a string is a valid Git repo name. Double-quotes are just removed.
REM Param %1.: variable name (e.g., someGitRepoName ) <-- pass the variable name, not its value
REM Returns..:
REM   %result% = 0 → invalid (empty or has forbidden chars)
REM   %result% = 1 → valid
REM Usage.....: CALL :ValidateString_GitRepoName "someGitRepoName"

SET "result=0"
SETLOCAL ENABLEDELAYEDEXPANSION
REM Get actual value
SET "input=!%~1!"
SET "input=!input:"=!"
REM Detect spaces by removing them and comparing 
SET "inputNoSpaces=!input: =!"
IF NOT "!inputNoSpaces!"=="!input!" ( ECHO. & ECHO Spaces not allowed. Please try again. & ENDLOCAL & PAUSE & GOTO StartMenuOpt3_GitMenuOpt1_GitSettingsOpt1 )
REM Empty or reserved dots validation
IF "!input!"=="" ( ENDLOCAL & EXIT /B )
IF "!input!"=="."  ( ENDLOCAL & EXIT /B )
IF "!input!"==".." ( ENDLOCAL & EXIT /B )
REM Forbidden characters: \ : * ? " < > |
REM Check forbidden characters - double-quote already removed
ECHO(!input!| FINDSTR /R "[\\:*?<>|]" >NUL
IF !ERRORLEVEL! EQU 0  ( ENDLOCAL & EXIT /B )
REM Names cannot end with a space or a dot
IF "!input:~-1!"==" " ( ENDLOCAL & EXIT /B )
IF "!input:~-1!"=="." ( ENDLOCAL & EXIT /B )
REM Valid string, pass it back
ENDLOCAL & ( SET "%~1=%input%" & SET "result=1" )
EXIT /B


:ValidateString_NoSpacesOrSymbols
REM Summary..: Validates if a string has forbiden symbols or spaces. Double-quotes are just removed.
REM Param %1.: variable name (e.g., someName ) <-- pass the variable name, not its value
REM Returns..:
REM   %result% = 0 → invalid (empty or has forbidden chars)
REM   %result% = 1 → valid
REM Usage.....: CALL :ValidateString_NoSpacesOrSymbols "someName"

SET "result=0"
SETLOCAL ENABLEDELAYEDEXPANSION
REM Get actual value
SET "input=!%~1!"
SET "input=!input:"=!"
REM Detect spaces by removing them and comparing 
SET "inputNoSpaces=!input: =!"
IF NOT "!inputNoSpaces!"=="!input!" ( ECHO. & ECHO Spaces not allowed. Please try again. & ENDLOCAL & PAUSE & GOTO StartMenuOpt3_GitMenuOpt1_GitSettingsOpt1 )
REM Empty or reserved dots validation
IF "!input!"=="" ( ENDLOCAL & EXIT /B )
IF "!input!"=="."  ( ENDLOCAL & EXIT /B )
IF "!input!"==".." ( ENDLOCAL & EXIT /B )
REM Forbidden characters: \ : * ? " < > |
REM Check forbidden characters - double-quote already removed
ECHO(!input!| FINDSTR /R "[\\/:*?<>|]" >NUL
IF !ERRORLEVEL! EQU 0  ( ENDLOCAL & EXIT /B )
REM Names cannot end with a space or a dot
IF "!input:~-1!"==" " ( ENDLOCAL & EXIT /B )
IF "!input:~-1!"=="." ( ENDLOCAL & EXIT /B )
REM Valid string, pass it back
ENDLOCAL & ( SET "%~1=%input%" & SET "result=1" )
EXIT /B





REM Handle Strings --------------------------------------------------------------------------------------------------------
	

:TrimString
REM Summary..: Trims leading and trailing spaces from a string (handles quoted values).
REM Param %1.: variable name (e.g., myVar)
REM Returns..: updates the variable in place
REM Usage.....: CALL :TrimString "myVar"

SETLOCAL ENABLEDELAYEDEXPANSION
SET "str=!%~1!"
REM Remove surrounding quotes, if any
SET "str=!str:"=!"
REM Use FOR to trim leading/trailing spaces
FOR /F "tokens=* delims= " %%A IN ("!str!") DO SET "str=%%A"
ENDLOCAL & SET "%~1=%str%"
EXIT /B


:RemoveAllSpaces
REM Summary..: Removes all spaces from a variable's value.
REM Param %1.: variable name (e.g., myVar)  <-- pass the variable name, not its value
REM Returns..: updates the variable in place (same name)
REM Usage.....: CALL :RemoveAllSpaces "myVar"

SETLOCAL ENABLEDELAYEDEXPANSION
SET "str=!%~1!"
REM Remove surrounding quotes, if any
SET "str=!str:"=!"
REM Remove all spaces
SET "str=!str: =!"
ENDLOCAL & SET "%~1=%str%"
EXIT /B




REM  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
REM Build timestamp (YYYYMMDD-HHMM)

:CreateTimestamp
FOR /F "tokens=1-4 delims=/-. " %%a IN ("%DATE%") DO ( SET "Day=%%a" & SET "Month=%%b" & SET "Year=%%c" )
FOR /F "tokens=1-2 delims=:." %%a IN ("%TIME%") DO ( SET "Hour=%%a" & SET "Min=%%b" )
SET "Hour=%Hour: =0%" & SET "Min=%Min: =0%"
SET "TimeStamp=%Year%%Month%%Day%-%Hour%%Min%"
EXIT /B






REM Clear and Delete ------------------------------------------------------------------------------------------------------
	
:DeleteFolderRecurs
REM Summary.: deletes recursively all folders with specified name, starting from the work dir. to all of its subfolders
REM Param %1: folder name
REM Usage...: CALL :DeleteFolderRecurs obj
ECHO Cleaning %~1 folders recursively...
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /d /r "%currentDir%" %%d IN (%~1) DO (
    IF EXIST "%%d" (
        RD /s /q "%%d"
        IF EXIST "%%d" ( ECHO  -- Error: could not completely delete "%%d" ) ELSE ( ECHO  -- Deleted "%%d" )
    )
)
ENDLOCAL
EXIT /B


REM Windows Firewall ------------------------------------------------------------------------------------------------------

:FirewallAddBlockRules
REM Summary..: Recursively searches for files with the given extensions and adds inbound/outbound block rules in Windows Firewall
REM Param %~1: list of file extensions separated by spaces and no quotes (e.g. *.exe *.dll)
REM Param %~2: label to go back to on error
REM Usage....: CALL :FirewallAddBlockRules *.exe *.dll "FireWallMenu"
ECHO Blocking all web traffic for %* files...
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (%*) DO (
    FOR /r "%currentDir%" %%x IN (%%f) DO (
        ECHO Adding block rules for: %%x
        REM Add outbound rule
        netsh advfirewall firewall add rule name="Block %%~nx" dir=out program="%%x" action=block >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 ( ECHO ERROR: Failed to add outbound rule for "%%~nx" & PAUSE & ENDLOCAL & GOTO %~2 )
        REM Add inbound rule
        netsh advfirewall firewall add rule name="Block %%~nx" dir=in program="%%x" action=block >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 ( ECHO ERROR: Failed to add inbound rule for "%%~nx" & PAUSE & ENDLOCAL & GOTO %~2 )
        ECHO Blocked: %%~nx
    )
)
ENDLOCAL
GOTO :EOF


:FirewallRemoveBlockRules
REM Summary.: Recursively searches for files with the given extensions and removes any inbound/outbound block rules in Windows Firewall
REM Param %1: list of file extensions separated by spaces and no quotes (e.g. *.exe *.dll)
REM Usage...: CALL :FirewallRemoveBlockRules *.exe *.dll
ECHO Removing all web traffic block rules for %1 files...
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (%*) DO (
    FOR /r "%currentDir%" %%x IN (%%f) DO (
        ECHO Removing block rules for: %%x
        REM Remove outbound rule
        netsh advfirewall firewall delete rule name="Block %%~nx" program="%%x" dir=out >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 ( ECHO WARNING: Failed to remove outbound rule for "%%~nxf". May not exist. )
        REM Remove inbound rule
        netsh advfirewall firewall delete rule name="Block %%~nx" program="%%x" dir=in >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 ( ECHO WARNING: Failed to remove inbound rule for "%%~nxf". May not exist. )
        ECHO Removed: %%~nx
    )
)
ENDLOCAL
GOTO :EOF






















