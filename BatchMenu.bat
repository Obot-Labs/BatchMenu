@ECHO off

REM =======================================================================================================================
REM Status Check - running scope vars
REM =======================================================================================================================

REM ============ General vars ============

REM Save original working directory (to restore later if needed)
SET "originalWorkDir=%cd%"
REM Current working directory
SET "currentDir=%cd%"

REM Check if running with administrator privileges
SET "isAdmin=0"
net session >nul 2>&1
IF %errorlevel%==0 ( SET "isAdmin=1" )


REM ============ GIT vars ============

REM Check if Git tool is available and get version
SET "isGitAvailable=0"
SET "gitVersion="

FOR /F "tokens=3" %%G IN ('git --version 2^>nul') DO (
    SET "gitVersion=%%G"
    SET "isGitAvailable=1"
)

REM Default git repo name
SET "defaultGitRepo=develop"

REM Check if running in a dir. with a git repo
SET "isRunningInsideGitRepoDir=0"
IF EXIST "%currentDir%\.git" ( SET "isRunningInsideGitRepoDir=1" )





REM =======================================================================================================================
REM Start Menu
REM =======================================================================================================================
:StartMenu
CALL :Clear
ECHO ===========================================================================================
ECHO                                     THIS IS A BATCH TOOL
ECHO ===========================================================================================
ECHO.
ECHO  Current directory: %currentDir%
ECHO  Please select an option:
ECHO.
ECHO   0. Status
ECHO   1. Clear
ECHO   2. Backup
IF "%isAdmin%"=="1" (
    ECHO   3. Firewall
) ELSE (
    ECHO   3. Firewall   [Unavailable: needs administrator privileges]
)
IF "%isGitAvailable%"=="1" (
    ECHO   4. Git
) ELSE (
    ECHO   4. Git        [Unavailable: git tool not installed or not found]
)
ECHO   5. Placeholder
ECHO.
ECHO   x. Exit
ECHO.
ECHO.
SET /p choice=Enter your choice (0-5, x): 
CALL :ValidateInput_Choice 0 5 "StartMenu" "StartMenu"
IF "%choice%"=="0" GOTO StartMenuOpt0_Status
IF "%choice%"=="1" GOTO StartMenuOpt1_Clear
IF "%choice%"=="2" GOTO StartMenuOpt2_Backup
IF "%choice%"=="3" ( IF "%isAdmin%"=="1" ( GOTO StartMenuOpt3_Firewall ) ELSE ( ECHO. & ECHO Option unavailable. Administrator privileges required. & ECHO. & PAUSE & GOTO StartMenu ) )
IF "%choice%"=="4" ( IF "%isGitAvailable%"=="1" ( GOTO StartMenuOpt4_Git ) ELSE ( ECHO. & ECHO Option unavailable. Git is not installed or not found. & ECHO. & PAUSE & GOTO StartMenu ) )
IF "%choice%"=="5" GOTO StartMenuOpt5_Placeholder
GOTO StartMenu





REM =======================================================================================================================
REM StartMenuOpt0_Status - Status Menu
REM =======================================================================================================================
:StartMenuOpt0_Status
CALL :Clear
ECHO ===========================================================================================
ECHO                                             Status
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
ECHO   -- Change working directory --
ECHO   1. Move up to parent folder
ECHO   2. Choose a subfolder
ECHO   3. Reset to original directory
ECHO.
ECHO   z. Back to main menu
ECHO   x. Exit script
ECHO.
ECHO.
SET /P choice=Enter your choice (1-3, z, x): 
CALL :ValidateInput_Choice 1 3 "StartMenuOpt0_Status" "StartMenu"
IF "%choice%"=="1" GOTO StatusOpt1
IF "%choice%"=="2" GOTO StatusOpt2
IF "%choice%"=="3" GOTO StatusOpt3
GOTO StartMenuOpt0_Status


REM StatusOpt1 - Move up to parent folder ---------------------------------------------------------------------------------
:StatusOpt1
CALL :Clear
FOR %%A IN ("%currentDir%\..") DO SET "parentDir=%%~fA"
IF NOT EXIST "%parentDir%" ( ECHO. & ECHO  ERROR: Parent folder not found. & PAUSE & GOTO StartMenuOpt0_Status )

SET "currentDir=%parentDir%"
CD /D "%currentDir%"
GOTO StartMenuOpt0_Status


REM StatusOpt2 - Choose a subfolder ---------------------------------------------------------------------------------------
:StatusOpt2
CALL :Clear
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO ===========================================================================================
ECHO                                     Choose a Subfolder
ECHO ===========================================================================================
ECHO.
ECHO Scanning for subfolders in:
ECHO   %currentDir%
ECHO.

SET "folderCount=0"

REM List only immediate subfolders (non-recursive)
FOR /D %%d IN ("%currentDir%\*") DO ( SET /A folderCount+=1 & SET "folder!folderCount!=%%~fd" )
IF !folderCount! EQU 0 ( ECHO No subfolders found in this directory. & ECHO. & PAUSE & ENDLOCAL & GOTO StartMenuOpt0_Status )

ECHO Found !folderCount! subfolder(s):
ECHO.
FOR /L %%i IN (1,1,!folderCount!) DO ( ECHO   %%i. !folder%%i! )
ECHO.
ECHO   z. Back to previous menu
ECHO   x. Exit
ECHO.
SET /P choice=Choose a folder (1-!folderCount!, z, x): 
CALL :ValidateInput_Choice 1 !folderCount! "StatusOpt2" "StartMenuOpt0_Status"

SET "selectedFolder=!folder%choice%!"
ENDLOCAL & SET "selectedFolder=%selectedFolder%"
CD /D "%selectedFolder%"
SET "currentDir=%cd%" & SET "selectedFolder="
GOTO StartMenuOpt0_Status

REM StatusOpt3 - Reset to original directory ------------------------------------------------------------------------------
:StatusOpt3
CALL :Clear
ECHO  This will reset the working directory 
ECHO   from: %currentDir%
ECHO   to:   %originalWorkDir%
ECHO.
SET /p confirm=Are you sure you want to continue? y/n: 
CALL :ValidateInput_Confirm "StatusOpt3" "StartMenuOpt0_Status"

CD /D "%originalWorkDir%"
SET "currentDir=%originalWorkDir%"
ECHO.
ECHO  Working directory has been reset.
ECHO.
PAUSE
GOTO StartMenuOpt0_Status





REM =======================================================================================================================
REM StartMenuOpt1_Clear - Clear
REM =======================================================================================================================
:StartMenuOpt1_Clear
CALL :Clear 
ECHO ===========================================================================================
ECHO                                      Clear
ECHO ===========================================================================================
ECHO  Clear cache or delete folders recursively. This actions cannot be undone.
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
ECHO   -- Clear cache -----------------
ECHO   8. Clear NuGet cache
ECHO   9. Clear npm cache
ECHO.
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO.
SET /p choice=Enter your choice (1-9, z, x): 
CALL :ValidateInput_Choice 1 9 "StartMenuOpt1_Clear" "StartMenu"

IF "%choice%"=="1" GOTO ClearOpt1
IF "%choice%"=="2" GOTO ClearOpt2
IF "%choice%"=="3" GOTO ClearOpt3
IF "%choice%"=="4" GOTO ClearOpt4
IF "%choice%"=="5" GOTO ClearOpt5
IF "%choice%"=="6" GOTO ClearOpt6
IF "%choice%"=="7" GOTO ClearOpt7
IF "%choice%"=="8" GOTO ClearOpt8
IF "%choice%"=="9" GOTO ClearOpt9
GOTO StartMenuOpt1_Clear


REM ClearOpt1 - Delete obj/bin --------------------------------------------------------------------------------------------
:ClearOpt1
CALL :Clear
CALL :DeleteFolderRecurs bin
CALL :DeleteFolderRecurs obj
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_Clear

REM ClearOpt2 - Delete packages -------------------------------------------------------------------------------------------
:ClearOpt2
CALL :Clear
CALL :DeleteFolderRecurs packages
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_Clear

REM ClearOpt3 - Delete node_modules ---------------------------------------------------------------------------------------
:ClearOpt3
CALL :Clear
CALL :DeleteFolderRecurs node_modules
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_Clear

REM ClearOpt4 - Delete .vs ------------------------------------------------------------------------------------------------
:ClearOpt4
CALL :Clear
CALL :DeleteFolderRecurs .vs
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_Clear

REM ClearOpt5 - Delete .git (with confirmation) ---------------------------------------------------------------------------
:ClearOpt5
CALL :Clear
SET /p confirm=Are you sure you want to delete ALL .git folders? y/n: 
CALL :ValidateInput_Confirm "ClearOpt5" "StartMenuOpt1_Clear"
CALL :DeleteFolderRecurs .git
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_Clear

REM ClearOpt6 - Delete custom folder --------------------------------------------------------------------------------------
:ClearOpt6
CALL :Clear
ECHO Delete a custom folder recursively. Wildcards '*' and '?' not allowed.
ECHO Press 'z' to cancel and go back to menu or 'x' to exit.
ECHO.
SET /P customFolderToClear=Enter the folder name to delete (e.g. dist, build, temp): 
CALL :ValidateInput_StringNoWildcards "customFolderToClear" "ClearOpt6" "StartMenuOpt1_Clear"
ECHO.
ECHO Cleaning "%customFolderToClear%" folders recursively...

REM Delete folders recursively, safely handling spaces in folder names
FOR /D /R "%currentDir%" %%p IN (*) DO (
    IF /I "%%~nxp"=="%customFolderToClear%" (
        IF EXIST "%%~fp" (
            RD /S /Q "%%~fp"
            IF EXIST "%%~fp" (
                ECHO  -- Error: could not completely delete "%%~fp"
            ) ELSE (
                ECHO  -- Deleted "%%~fp"
            )
        )
    )
)
SET "customFolderToClear="
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_Clear

REM ClearOpt7 - Delete custom files (no wildcards, supports spaces in user input) -----------------------------------------
:ClearOpt7
CALL :Clear
ECHO Delete a custom file recursively. Wildcards '*' and '?' not allowed.
ECHO Press 'z' to cancel and go back to menu or 'x' to exit.
ECHO.
SET /P customFileToClear=Enter the file name to delete (e.g. app.log, debug.txt): 
CALL :ValidateInput_StringNoWildcards "customFileToClear" "ClearOpt7" "StartMenuOpt1_Clear"
ECHO.
ECHO Cleaning "%customFileToClear%" files recursively...

REM Change to script directory so relative names behave as expected
PUSHD "%currentDir%" 2>NUL || ( ECHO Failed to change directory to "%currentDir%". & PAUSE & GOTO StartMenuOpt1_Clear )
REM Use DIR to find matching files (handles spaces & quoted names), iterate with FOR /F "delims="
SETLOCAL
FOR /F "usebackq delims=" %%F IN (`DIR /B /S "%customFileToClear%" 2^>nul`) DO (
    IF EXIST "%%F" (
        DEL /F /Q "%%F" 2>nul
        IF EXIST "%%F" (
            ECHO  -- Error: could not completely delete "%%F"
        ) ELSE (
            ECHO  -- Deleted "%%F"
        )
    )
)
ENDLOCAL
POPD
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt1_Clear

REM ClearOpt8 - Clear NuGet cache -----------------------------------------------------------------------------------------
:ClearOpt8
CALL :Clear
ECHO Cleaning NuGet cache...
nuget locals all -clear
ECHO.
IF %ERRORLEVEL%==0 ( ECHO. & ECHO Success! & PAUSE & GOTO StartMenuOpt1_Clear ) ELSE ( ECHO. & ECHO ERROR: Command failed with exit code %ERRORLEVEL%. & PAUSE & GOTO StartMenuOpt1_Clear )

REM ClearOpt9 - Clear npm cache -------------------------------------------------------------------------------------------
:ClearOpt9
CALL :Clear
ECHO Cleaning npm cache...
npm cache clean --force
ECHO.
IF %ERRORLEVEL%==0 ( ECHO. & ECHO Success! & PAUSE & GOTO StartMenuOpt1_Clear ) ELSE ( ECHO. & ECHO ERROR: Command failed with exit code %ERRORLEVEL%. & PAUSE & GOTO StartMenuOpt1_Clear )







REM =======================================================================================================================
REM StartMenuOpt2_Backup - Backup
REM =======================================================================================================================
:StartMenuOpt2_Backup
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
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO.

SET /p choice=Enter your choice (1-2, z, x): 
CALL :ValidateInput_Choice 1 2 "StartMenuOpt2_Backup" "StartMenu"

IF "%choice%"=="1" GOTO BackupOpt1
IF "%choice%"=="2" GOTO BackupOpt2
GOTO StartMenuOpt2_Backup



:BackupOpt1
CALL :Clear
SETLOCAL
ECHO Creating quick backup of current folder...
ECHO.

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
ECHO Source:      "%srcDir%"
ECHO Destination: "%backupDir%"
ECHO.

REM Perform backup (exclude .bat itself and destination)
robocopy "%srcDir%" "%backupDir%" /E /XD "%backupDir%" /XF "%~f0"
IF %ERRORLEVEL% LSS 8 ( ECHO. & ECHO Backup completed successfully! ) ELSE ( ECHO. & ECHO ERROR: Backup failed with code %ERRORLEVEL%. )

ECHO.
ENDLOCAL
PAUSE
GOTO StartMenuOpt2_Backup



REM BackupOpt2 - Smart recursive backup with full exclusions + logging
REM Summary:
REM   Performs a backup copy of all files in the same directory as the bat to a new directory with timestamp.
REM   Automatically excludes unwanted folders like "bin", "obj", "packages", "node_modules",
REM   and asks the user if ".vs" and ".git" are also to be excluded.
REM   Creates a txt file log in the backup folder.
:BackupOpt2
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

REM Search for .git folders ------------------------------------
ECHO Searching for .git folders...
DIR /S /B /AD "%WorkDirFull%" | FINDSTR /I "\\.git$" >"%TEMP%\gitlist.txt"
IF EXIST "%TEMP%\gitlist.txt" (
    FOR /F "usebackq delims=" %%G IN ("%TEMP%\gitlist.txt") DO ECHO Found .git: "%%G"
    SET /P "IncludeGit=Include the above .git folders in the backup? y/n: "
) ELSE ( SET "IncludeGit=None" & ECHO No .git folders found. )

IF /I "%IncludeGit%"=="N" ( SET "ExcludeDirs=%ExcludeDirs% .git" )
ECHO. & ECHO.

REM Search for .vs folders -------------------------------------
ECHO Searching for .vs folders...
DIR /S /B /AD "%WorkDirFull%" | FINDSTR /I "\\.vs$" >"%TEMP%\vslist.txt"
IF EXIST "%TEMP%\vslist.txt" (
    FOR /F "usebackq delims=" %%V IN ("%TEMP%\vslist.txt") DO ECHO Found .vs: "%%V"
    SET /P "IncludeVs=Include the above .vs folders in the backup? y/n: "
) ELSE ( SET "IncludeVs=None" & ECHO No .vs folders found. )

IF /I "%IncludeVs%"=="N" ( SET "ExcludeDirs=%ExcludeDirs% .vs" )
ECHO. & ECHO.

REM Confirm proceed -----------------------------------------------
SET /P "Confirm=Proceed with the backup? y/n: "
IF /I NOT "%Confirm%"=="y" ( ECHO Backup cancelled. & ENDLOCAL & GOTO StartMenuOpt2_Backup )


REM 2. Start backup ===============================================
ECHO.
ECHO Starting copy...
ECHO.
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
    ECHO Backup completed on %DATE% %TIME%
    ECHO.
    ECHO Source: %WorkDirFull%
    ECHO Destination: %BackupDir%
    ECHO.
    ECHO Excluded folders: %ExcludeDirs%
    ECHO.

    REM .git folders logging --------------------------------------
    IF EXIST "%TEMP%\gitlist.txt" (
        IF /I "%IncludeGit%"=="N" (
            ECHO .git folders were excluded:
            TYPE "%TEMP%\gitlist.txt"
        ) ELSE IF /I "%IncludeGit%"=="Y" (
            ECHO .git folders were included.
        ) ELSE (
            ECHO No .git folders found.
        )
        ECHO.
    ) ELSE ( ECHO No .git folders found. & ECHO. )

    REM .vs folders logging ---------------------------------------
    IF EXIST "%TEMP%\vslist.txt" (
        IF /I "%IncludeVs%"=="N" (
            ECHO .vs folders were excluded:
            TYPE "%TEMP%\vslist.txt"
        ) ELSE IF /I "%IncludeVs%"=="Y" (
            ECHO .vs folders were included.
        ) ELSE (
            ECHO No .vs folders found.
        )
        ECHO.
    ) ELSE ( ECHO No .vs folders found. & ECHO. )

    ECHO ---------------------------------------------------------------
    ECHO Robocopy details:
    ECHO ---------------------------------------------------------------
    IF EXIST "%RoboLog%" TYPE "%RoboLog%"
) > "%MainLog%"

DEL "%RoboLog%" >NUL 2>&1

IF %Rc% GEQ 8 (
    ECHO [ERROR] Robocopy failed. Cleaning up...
    RMDIR /S /Q "%BackupDir%"
    MKDIR "%BackupDir%"
    ECHO Backup failed with RC %Rc% on %DATE% %TIME% > "%MainLog%"
)

ECHO Done!
ECHO Backup log saved: "%MainLog%"
ECHO.
ENDLOCAL
PAUSE
GOTO StartMenuOpt2_Backup








REM =======================================================================================================================
REM StartMenuOpt3_Firewall - Windows Firewall
REM =======================================================================================================================
:StartMenuOpt3_Firewall
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
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO.

SET /p choice=Enter your choice (1-6, z, x): 
CALL :ValidateInput_Choice 1 6 "StartMenuOpt3_Firewall" "StartMenu"

IF "%choice%"=="1" GOTO FirewallOpt1
IF "%choice%"=="2" GOTO FirewallOpt2
IF "%choice%"=="3" GOTO FirewallOpt3
IF "%choice%"=="4" GOTO FirewallOpt4
IF "%choice%"=="5" GOTO FirewallOpt5
IF "%choice%"=="6" GOTO FirewallOpt6
GOTO StartMenuOpt3_Firewall

REM FirewallOpt1: Block web traffic - Block all EXE and DLL files ---------------------------------------------------------
:FirewallOpt1
CALL :Clear
CALL :FirewallAddBlockRules *.exe *.dll
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM FirewallOpt2: Block web traffic - COM, SCR, CPL, OCX and SYS files ----------------------------------------------------
:FirewallOpt2
CALL :Clear
CALL :FirewallAddBlockRules *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM FirewallOpt3: Block web traffic - All the above -----------------------------------------------------------------------
:FirewallOpt3
CALL :Clear
CALL :FirewallAddBlockRules *.exe *.dll *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM FirewallOpt4: Remove web trafic block - EXE and DLL files -------------------------------------------------------------
:FirewallOpt4
CALL :Clear
CALL :FirewallRemoveBlockRules *.exe *.dll
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM FirewallOpt5: Remove web trafic block - COM, SCR, CPL, OCX and SYS files ----------------------------------------------
:FirewallOpt5
CALL :Clear
CALL :FirewallRemoveBlockRules *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall

REM FirewallOpt6: Remove web trafic block -  All the above  ---------------------------------------------------------------
:FirewallOpt6
CALL :Clear
CALL :FirewallRemoveBlockRules *.exe *.dll *.com *.scr *.cpl *.ocx *.sys
ECHO. & ECHO Done! & PAUSE & GOTO StartMenuOpt3_Firewall






REM =======================================================================================================================
REM StartMenuOpt4_Git - Git
REM =======================================================================================================================
:StartMenuOpt4_Git
CALL :Clear
REM Normalize paths (remove trailing backslash except for root)
FOR %%A IN ("%currentDir%") DO SET "currentDir=%%~fA"
FOR %%A IN ("%originalWorkDir%") DO SET "originalWorkDir=%%~fA"

IF EXIST "%currentDir%\.git" ( IF "%currentDir%"=="%originalWorkDir%" ( SET "isRunningInsideGitRepoDir=1" ) ELSE ( SET "isRunningInsideGitRepoDir=0" ) ) ELSE (	SET "isRunningInsideGitRepoDir=0" )
IF "%isRunningInsideGitRepoDir%"=="1" ( GOTO StartMenuOpt4_Git_PleaseRunOutsideRepo )

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
IF %gitRepoCount%==0 ( ECHO. & ECHO No Git repositories found in this folder or its subfolders. & ECHO. & PAUSE & ENDLOCAL & CD /d "%originalWorkDir%" & GOTO StartMenu )

REM Git repositories menu
ECHO Found %gitRepoCount% repositories:
ECHO. 
FOR /l %%i IN (1,1,%gitRepoCount%) DO ( ECHO   %%i. !repo%%i! )
ECHO. 
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO. 

SET /p choice=Choose a repository (1-%gitRepoCount%, z, x): 
CALL :ValidateInput_Choice 1 %gitRepoCount% "StartMenuOpt4_Git" "StartMenu"

SET "selectedRepo=!repo%choice%!"
ENDLOCAL & SET "selectedRepo=%selectedRepo%"

IF EXIST "%selectedRepo%\.git" ( 
	REM Normalize paths (remove trailing backslash except for root)
	FOR %%A IN ("%selectedRepo%") DO SET "selectedRepo=%%~fA"
	FOR %%A IN ("%originalWorkDir%") DO SET "originalWorkDir=%%~fA"
	IF "%selectedRepo%"=="%originalWorkDir%" ( 
		ECHO.
		ECHO Performing git commands in the same directory as the bat is not allowed.
		ECHO Please choose another repository.
		SET "selectedRepo=" & PAUSE & GOTO StartMenuOpt4_Git
	)
)
SET "currentDir=%selectedRepo%" & SET "selectedRepo="
CD /d "%currentDir%"
GOTO StartMenuOpt4_Git_RepoSelected


REM StartMenuOpt4_Git_PleaseRunOutsideRepo: sub menu ----------------------------------------------------------------------
:StartMenuOpt4_Git_PleaseRunOutsideRepo
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
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO.
SET /P "choice=Press 'z' or 'x' to continue: "
CALL :ValidateInput_BackExitChoice "StartMenuOpt4_Git" "StartMenu"
GOTO StartMenu


REM StartMenuOpt4_Git_RepoSelected: sub menu ------------------------------------------------------------------------------
:StartMenuOpt4_Git_RepoSelected
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

SET /p choice=Enter your choice (1-3, z, x): 

REM Override back option
IF /i "%choice%"=="z" ( 
	SETLOCAL
	FOR %%A IN ("%currentDir%\..") DO SET "parentDir=%%~fA"
	ENDLOCAL & SET "currentDir=%parentDir%"
	CD /D "%currentDir%"
	GOTO StartMenuOpt4_Git
)

CALL :ValidateInput_Choice 1 3 "StartMenuOpt4_Git_RepoSelected" "StartMenuOpt4_Git"

IF "%choice%"=="1" GOTO GitOpt1_Settings
IF "%choice%"=="2" GOTO GitOpt2_Clean
IF "%choice%"=="3" GOTO GitOpt3_Combos
GOTO StartMenuOpt4_Git_RepoSelected


REM GitOpt1_Settings: sub menu --------------------------------------------------------------------------------------------
:GitOpt1_Settings
CALL :Clear
ECHO ===========================================================================================
ECHO                                     Git - Settings
ECHO ===========================================================================================
ECHO  Perform Git commands on the chosen repository.
ECHO  Repo: %currentDir%
ECHO.
ECHO  Settings:
ECHO.
ECHO   1. Re-select repo
ECHO   2. Change default repo (currently: '%defaultGitRepo%')
ECHO   3. Reset default repo to 'develop'
ECHO.
ECHO   z. Back
ECHO   x. Exit
ECHO.

SET /p choice=Enter your choice (1-3, z, x): 
CALL :ValidateInput_Choice 1 3 "GitOpt1_Settings" "StartMenuOpt4_Git_RepoSelected"

IF "%choice%"=="1" GOTO GitOpt1_SettingsOpt1
IF "%choice%"=="2" GOTO GitOpt1_SettingsOpt2
IF "%choice%"=="3" GOTO GitOpt1_SettingsOpt3
GOTO GitOpt1_Settings


REM GitOpt1_SettingsOpt1: Re-select repo ----------------------------------------------------------------------------------
:GitOpt1_SettingsOpt1
CALL :Clear
SETLOCAL
FOR %%A IN ("%currentDir%\..") DO SET "parentDir=%%~fA"
ENDLOCAL & SET "currentDir=%parentDir%"
CD /D "%currentDir%"
GOTO StartMenuOpt4_Git


REM GitOpt1_SettingsOpt2: Change default repo -----------------------------------------------------------------------------
:GitOpt1_SettingsOpt2
CALL :Clear
SETLOCAL ENABLEDELAYEDEXPANSION
SET /P "defaultGitRepo=Enter new default repo name: "

REM Detect spaces by removing them and comparing 
SET "noSpaceRepo=!defaultGitRepo: =!"
IF NOT "!defaultGitRepo!"=="!noSpaceRepo!" ( ECHO Spaces not allowed. Please try again. & ENDLOCAL & SET "defaultGitRepo=" & PAUSE & GOTO GitOpt1_SettingsOpt1 )

REM End and export the local value to global scope
ENDLOCAL & SET "defaultGitRepo=%defaultGitRepo%"
CALL :ValidateInput_StringNoWildcards "defaultGitRepo" "GitOpt1_SettingsOpt1" "StartMenuOpt4_Git_RepoSelected"
GOTO GitOpt1_Settings


REM GitOpt1_SettingsOpt3: Reset default repo to 'develop' -----------------------------------------------------------------
:GitOpt1_SettingsOpt3
SET "defaultGitRepo=develop"
GOTO GitOpt1_Settings





REM GitOpt2_Clean: sub menu -----------------------------------------------------------------------------------------------
:GitOpt2_Clean
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

SET /p choice=Enter your choice (1-6, z, x): 
CALL :ValidateInput_Choice 1 6 "GitOpt2_Clean" "StartMenuOpt4_Git_RepoSelected"

IF "%choice%"=="1" GOTO GitOpt2_CleanOpt1
IF "%choice%"=="2" GOTO GitOpt2_CleanOpt2
IF "%choice%"=="3" GOTO GitOpt2_CleanOpt3
IF "%choice%"=="4" GOTO GitOpt2_CleanOpt4
IF "%choice%"=="5" GOTO GitOpt2_CleanOpt5
IF "%choice%"=="6" GOTO GitOpt2_CleanOpt6
GOTO GitOpt2_Clean



REM GitOpt2_CleanOpt1: Restore tracked files ------------------------------------------------------------------------------
:GitOpt2_CleanOpt1
CALL :Clear
ECHO Restoring tracked files...
ECHO.
git checkout .
ECHO.
IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE
GOTO GitOpt2_Clean


REM GitOpt2_CleanOpt2: Remove untracked files and dirs. -------------------------------------------------------------------
:GitOpt2_CleanOpt2
CALL :Clear
ECHO This will delete all untracked files and directories.
SET /p confirm=Are you sure you want to remove untracked files and directories? y/n: 
CALL :ValidateInput_Confirm "GitOpt2_CleanOpt2" "GitOpt2_Clean"

ECHO Removing untracked files and directories...
ECHO.
git clean -fd
ECHO.
IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE
GOTO GitOpt2_Clean


REM GitOpt2_CleanOpt3: Remove everything untracked. -----------------------------------------------------------------------
:GitOpt2_CleanOpt3
CALL :Clear
ECHO This will delete all untracked files and directories and also everything that is in .gitignore.
SET /p confirm=Are you sure you want to remove EVERYTHING untracked? y/n : 
CALL :ValidateInput_Confirm "GitOpt2_CleanOpt3" "GitOpt2_Clean"

ECHO Removing everything untracked...
git clean -fdx
ECHO.
IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE
GOTO GitOpt2_Clean


REM GitOpt2_CleanOpt4: Prune branches -------------------------------------------------------------------------------------
:GitOpt2_CleanOpt4
CALL :Clear
ECHO Prune branches...
ECHO.
git fetch --prune
ECHO.
IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE
GOTO GitOpt2_Clean


REM GitOpt2_CleanOpt5: Checkout to default repo (develop) -----------------------------------------------------------------
:GitOpt2_CleanOpt5
CALL :Clear
ECHO Checking out to %defaultGitRepo%...
ECHO.
git checkout %defaultGitRepo%
ECHO.
IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE
GOTO GitOpt2_Clean


REM GitOpt2_CleanOpt6: Pull -----------------------------------------------------------------------------------------------
:GitOpt2_CleanOpt6
CALL :Clear
ECHO Pulling... 
ECHO.
git pull
ECHO.
IF %ERRORLEVEL%==0 ( ECHO Command succeeded! ) ELSE ( ECHO ERROR: Command failed with exit code %ERRORLEVEL%. )
PAUSE
GOTO GitOpt2_Clean




REM GitOpt3_Combos: sub menu ----------------------------------------------------------------------------------------------
:GitOpt3_Combos
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

SET /p choice=Enter your choice (1-1, z, x): 
CALL :ValidateInput_Choice 1 1 "GitOpt3_Combos" "StartMenuOpt4_Git_RepoSelected"

IF "%choice%"=="1" GOTO GitOpt3_CombosOpt1
GOTO GitOpt3_Combos



REM GitOpt3_CombosOpt1: Combo - Reset -------------------------------------------------------------------------------------
:GitOpt3_CombosOpt1
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
SET /p confirm=Are you sure you want to proceed? (y/n): 
IF /i "%confirm%"=="y" (
	ECHO Running full git reset sequence...
	ECHO.
	
	REM 1. Restore tracked files
	ECHO Step 1: Restore tracked files 'git checkout .'
	git checkout .
	ECHO.
	IF errorlevel 1 ( ECHO ERROR: 'git checkout .' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO GitOpt2_Combos )
	
	REM 2. Remove untracked files
	ECHO Step 2: Remove untracked files 'git clean -fd'
	git clean -fd
	ECHO.
	IF errorlevel 1 ( ECHO ERROR: 'git clean -fd' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO GitOpt2_Combos )
	
	REM 5. Checkout to develop
	ECHO Step 3: Checkout to develop -git checkout develop
	git checkout develop
	ECHO.
	IF errorlevel 1 ( ECHO ERROR: 'git checkout develop' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO GitOpt2_Combos )
	
	REM 6. Pull
	ECHO Step 4: Pull -git pull
	git pull
	ECHO.
	IF errorlevel 1 ( ECHO ERROR: 'git pull' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO GitOpt2_Combos )
	
	REM 4. Prune branches
	ECHO Step 5: Prune branches -git fetch --prune
	git fetch --prune
	ECHO.
	IF errorlevel 1 ( ECHO ERROR: 'git fetch --prune' failed with exit code %ERRORLEVEL%. & PAUSE & GOTO GitOpt2_Combos )
	
	ECHO.
	ECHO All commands completed successfully!
	PAUSE
	GOTO GitOpt2_Combos
) ELSE (
    ECHO Canceled. Returning to menu...
	ECHO.
    PAUSE
    GOTO GitOpt2_Combos
)








REM =======================================================================================================================
REM StartMenuOpt5_Placeholder - Placeholder
REM =======================================================================================================================
:StartMenuOpt5_Placeholder
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
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO.
SET /p choice=Enter your choice (1-3, z, x): 
CALL :ValidateInput_Choice 1 3 "StartMenuOpt5_Placeholder" "StartMenu"

IF "%choice%"=="1" GOTO PlaceholderOpt1
IF "%choice%"=="2" GOTO PlaceholderOpt2
IF "%choice%"=="3" GOTO PlaceholderOpt3
GOTO StartMenuOpt1_Clear


:PlaceholderOpt1
CALL :Clear
ECHO Yup, you got it...
PAUSE
GOTO StartMenuOpt5_Placeholder


:PlaceholderOpt2
CALL :Clear
ECHO Almost!...
PAUSE
GOTO StartMenuOpt5_Placeholder


:PlaceholderOpt3
CALL :Clear
ECHO Your mamma is so fat...
PAUSE
GOTO StartMenuOpt5_Placeholder


















REM =======================================================================================================================
REM   Subroutines
REM =======================================================================================================================


REM General ---------------------------------------------------------------------------------------------------------------

:Clear
REM summary:
REM   clears user input and console
REM usage example:
REM   CALL :Clear

CLS & SET "choice=" & SET "confirm="
EXIT /B


:Goodbye
REM summary:
REM   prints goodbye and exits
REM usage example:
REM   CALL :Goodbye

ECHO. & ECHO Exiting... Goodbye! & PAUSE
EXIT


REM Validate user input ---------------------------------------------------------------------------------------------------

:ValidateInput_Choice
REM summary:
REM   validates user input on menus
REM params:
REM   %~1 = min valid number
REM   %~2 = max valid number
REM   %~3 = current label to return on invalid input
REM   %~4 = label to go back to
REM usage example:
REM   CALL :ValidateInput_Choice 1 %gitRepoCount% "CurrentLabel" "BackToMenuLabel"

REM Exit option
IF /i "%choice%"=="x" CALL :Goodbye
REM Back option
IF /i "%choice%"=="z" ( SET "choice=" & GOTO %~4 )
REM Empty validation
IF "%choice%"=="" ( ECHO. & ECHO That's not a valid option. Use a number between %~1 and %~2, 'z' to go back, or 'x' to quit. & PAUSE & GOTO %~3 ) 
REM Numeric validation
FOR /f "delims=0123456789" %%A IN ("%choice%") DO ( ECHO. & ECHO That's not a valid option. Use a number between %~1 and %~2, 'z' to go back, or 'x' to quit. & SET "choice=" & PAUSE & GOTO %~3 )
REM less than %~1 validation
IF %choice% LSS %~1 ( ECHO. & ECHO That's not a valid option. Use a number between %~1 and %~2, 'z' to go back, or 'x' to quit. & SET "choice=" & PAUSE & GOTO %~3 )
REM Greater than %~2 validation
IF %choice% GTR %~2 ( ECHO. & ECHO That's not a valid option. Use a number between %~1 and %~2, 'z' to go back, or 'x' to quit. & SET "choice=" & PAUSE & GOTO %~3 )
REM Valid choice continues ( %choice% not cleared )
EXIT /B


:ValidateInput_Confirm
REM summary:
REM   validates user input on confirm yes or no questions
REM   Exit and Back options are not mentioned to user
REM params:
REM   %~1 = current label to return on invalid input
REM   %~2 = label to go back to
REM usage example:
REM   CALL :ValidateInput_Confirm "CurrentLabel" "BackToMenuLabel"

REM Exit option
IF /i "%confirm%"=="x" CALL :Goodbye
REM Back option
IF /i "%confirm%"=="z"  ( SET "confirm=" & GOTO %~2 )
REM No option
IF /i "%confirm%"=="n" ( ECHO. & ECHO Canceled. Returning... & SET "confirm=" & PAUSE & GOTO %~2 )
REM Everything else but y
IF /i NOT "%confirm%"=="y" ( ECHO. & ECHO Invalid option. Possible options: y/n & SET "confirm=" & PAUSE & GOTO %~1 )
REM Yes option continues ( %confirm% not cleared )
EXIT /B


:ValidateInput_BackExitChoice
REM summary:
REM   validates user input on menus with only back and exit
REM params:
REM   %~1 = current label to return on invalid input
REM   %~2 = label to go back to
REM usage example:
REM   CALL :ValidateInput_BackExitChoice "CurrentLabel" "BackToMenuLabel"

REM Exit option
IF /i "%choice%"=="x" CALL :Goodbye
REM Back option
IF /i "%choice%"=="z" ( SET "choice=" & GOTO %~2 )
IF /i NOT "%choice%"=="z" ( ECHO. & ECHO That's not a valid option. 'z' to go back, or 'x' to quit. & PAUSE & GOTO %~1 ) 
EXIT /B


:ValidateInput_StringNoWildcards
REM Summary:
REM   Validates user input string: no wildcards allowed
REM Params:
REM   %1 = variable name (e.g., customFolderToClear) <-- IMPORTANT: pass the name, not %value%
REM   %2 = current label to return on invalid input
REM   %3 = label to go back to
REM Usage:
REM   CALL :ValidateInput_StringNoWildcards "customFolderToClear" "CurrentLabel" "BackToMenuLabel"
REM Extra details:
REM   SET "input=!%~1!" gets the value of the variable whose name was passed in (%1).
REM   We pass the name (not the value) so we can later clear or update it after ENDLOCAL.

SETLOCAL ENABLEDELAYEDEXPANSION

REM Get value of the variable
SET "input=!%~1!"
REM Strip surrounding quotes if user typed them
SET "input=!input:"=!"

REM Exit option
IF /i "!input!"=="x" CALL :Goodbye
REM Back option
IF /i "!input!"=="z" ( ENDLOCAL & SET "%~1=" & GOTO %~2 )
REM Empty validation
IF "!input!"=="" ( ECHO. & ECHO Nothing entered. Please try again. & ENDLOCAL & PAUSE & GOTO %~2 ) 
REM Check wildcards
ECHO.!input! | FINDSTR "\*" >nul
IF !ERRORLEVEL! EQU 0 ( ECHO Wildcard "*" detected. Please try again. & ENDLOCAL & SET "%~1=" & PAUSE & GOTO %~2 )
ECHO.!input! | FINDSTR "\?" >nul
IF !ERRORLEVEL! EQU 0 ( ECHO Wildcard "?" detected. Please try again. & ENDLOCAL & SET "%~1=" & PAUSE & GOTO %~2 )

REM Valid input, keep value
ENDLOCAL & SET "%~1=%input%"
EXIT /B


REM Clear and Delete ------------------------------------------------------------------------------------------------------
	
:DeleteFolderRecurs
REM summary:
REM   deletes recursively all folders with specified name, starting from the work dir. to all of its subfolders
REM   doesn't support folder names with spaces
REM params:
REM   %~1 = folder name
REM usage example:
REM   CALL :DeleteFolderRecurs obj

ECHO Cleaning %~1 folders recursively...
SETLOCAL ENABLEDELAYEDEXPANSION

FOR /d /r "%currentDir%" %%d IN (%~1) DO (
    IF EXIST "%%d" (
        RD /s /q "%%d"
        IF EXIST "%%d" (
            ECHO  -- Error: could not completely delete "%%d"
        ) ELSE (
            ECHO  -- Deleted "%%d"
        )
    )
)
ENDLOCAL
EXIT /B


REM Windows Firewall ------------------------------------------------------------------------------------------------------

:FirewallAddBlockRules
REM summary:
REM   Recursively searches for files with the given extensions and adds inbound/outbound block rules in Windows Firewall
REM params:
REM   %1 = list of file extensions separated by spaces and no quotes (e.g. *.exe *.dll)
REM usage example:
REM   CALL :FirewallAddBlockRules *.exe *.dll

ECHO Blocking all web traffic for %* files...
SETLOCAL ENABLEDELAYEDEXPANSION

FOR %%f IN (%*) DO (
    FOR /r "%currentDir%" %%x IN (%%f) DO (
        ECHO Adding block rules for: %%x
        REM Add outbound rule
        netsh advfirewall firewall add rule name="Block %%~nx" dir=out program="%%x" action=block >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 (
            ECHO ERROR: Failed to add outbound rule for "%%~nx"
            PAUSE & ENDLOCAL & GOTO StartMenuOpt3_Firewall
        )
        REM Add inbound rule
        netsh advfirewall firewall add rule name="Block %%~nx" dir=in program="%%x" action=block >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 (
            ECHO ERROR: Failed to add inbound rule for "%%~nx"
            PAUSE & ENDLOCAL & GOTO StartMenuOpt3_Firewall
        )

        ECHO Blocked: %%~nx
    )
)
ENDLOCAL
GOTO :EOF


:FirewallRemoveBlockRules
REM summary:
REM   Recursively searches for files with the given extensions and removes any inbound/outbound block rules in Windows Firewall
REM params:
REM   %1 = list of file extensions separated by spaces and no quotes (e.g. *.exe *.dll)
REM usage example:
REM   CALL :FirewallRemoveBlockRules *.exe *.dll

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













