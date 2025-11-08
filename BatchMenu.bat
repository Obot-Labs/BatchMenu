@ECHO off

:: Save original working directory (to restore later)
SET "originalWorkDir=%cd%"

:: Check for Administrator
SET "isAdmin=0"
net session >nul 2>&1
IF %errorlevel%==0 (
    SET "isAdmin=1"
)

:: ========================================================================================================================
:: Start - Main menu
:: ========================================================================================================================
:main_menu
CLS
ECHO ===========================================================================================
ECHO                                     THIS IS A BATCH TOOL
ECHO ===========================================================================================
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Quick Clear
ECHO   2. Git
ECHO   3. Windows Firewall
ECHO   4. Option 4 - [Placeholder]
ECHO   5. Option 5 - [Placeholder]
ECHO   6. Option 6 - [Placeholder]
ECHO   7. Option 7 - [Placeholder]
ECHO   8. Option 8 - [Placeholder]
ECHO   9. Option 9 - [Placeholder]
ECHO.
ECHO   x. Exit
ECHO.
IF "%isAdmin%"=="1" (
    ECHO  Running with Administrator privileges.
) ELSE (
    ECHO  Not running as Administrator.
)
ECHO.
SET "choice="
SET /p choice=Enter your choice (1-9 or x): 

:: Handle input
IF "%choice%"=="1" GOTO main_option1
IF "%choice%"=="2" GOTO main_option2
IF "%choice%"=="3" GOTO main_option3
IF "%choice%"=="4" GOTO main_option4
IF "%choice%"=="5" GOTO main_option5
IF "%choice%"=="6" GOTO main_option6
IF "%choice%"=="7" GOTO main_option7
IF "%choice%"=="8" GOTO main_option8
IF "%choice%"=="9" GOTO main_option9
IF /i "%choice%"=="x" GOTO exit

ECHO Invalid choice! Please try again.
PAUSE
GOTO main_menu






:: ================================================================================================
:: main_option1 - Quick Clear
:: ================================================================================================
:main_option1
CLS
ECHO ===========================================================================================
ECHO                                      Quick Clear
ECHO ===========================================================================================
ECHO  Clear cache or delete folders recursively. This actions cannot be undone.
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   -- Delete folders recursively
ECHO   1. Delete obj/bin
ECHO   2. Delete packages
ECHO   3. Delete node_modules
ECHO   4. Delete .vs
ECHO   5. Delete .git
ECHO   6. Delete custom folder
ECHO.
ECHO   -- Clear cache
ECHO   7. Clear NuGet cache
ECHO   8. Clear npm cache
ECHO.
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO.
SET "choice="
SET /p choice=Enter your choice (1-8, z, or x): 

:: Handle input
IF "%choice%"=="1" GOTO clear_option1
IF "%choice%"=="2" GOTO clear_option2
IF "%choice%"=="3" GOTO clear_option3
IF "%choice%"=="4" GOTO clear_option4
IF "%choice%"=="5" GOTO clear_option5
IF "%choice%"=="6" GOTO clear_option6
IF "%choice%"=="7" GOTO clear_option7
IF "%choice%"=="8" GOTO clear_option8
IF /i "%choice%"=="z" GOTO main_menu
IF /i "%choice%"=="x" GOTO exit

ECHO Invalid choice! Please try again.
PAUSE
GOTO main_option1


:: ========================================================================
:: clear_option1: Delete obj/bin
:: ========================================================================
:clear_option1
CLS
ECHO Cleaning obj/bin folders recursively...
FOR /d /r "%~dp0" %%d IN (bin obj) DO (
    IF EXIST "%%d" (
        ECHO Deleting %%d
        RD /s /q "%%d"
    )
)
ECHO.
ECHO Done!
PAUSE
GOTO main_option1

:: ========================================================================
:: clear_option2: Delete packages
:: ========================================================================
:clear_option2
CLS
ECHO Cleaning packages folders recursively...
FOR /d /r "%~dp0" %%d IN (packages) DO (
    IF EXIST "%%d" (
        ECHO Deleting %%d
        RD /s /q "%%d"
    )
)
ECHO.
ECHO Done!
PAUSE
GOTO main_option1

:: ========================================================================
:: clear_option3: Delete node_modules
:: ========================================================================
:clear_option3
CLS
ECHO Cleaning node_modules folders recursively...
FOR /d /r "%~dp0" %%d IN (node_modules) DO (
    IF EXIST "%%d" (
        ECHO Deleting %%d
        RD /s /q "%%d"
    )
)
ECHO.
ECHO Done!
PAUSE
GOTO main_option1

:: ========================================================================
:: clear_option4: Delete .vs
:: ========================================================================
:clear_option4
CLS
ECHO Cleaning .vs folders recursively...
FOR /d /r "%~dp0" %%d IN (.vs) DO (
    IF EXIST "%%d" (
        ECHO Deleting %%d
        RD /s /q "%%d"
    )
)
ECHO.
ECHO Done!
PAUSE
GOTO main_option1

:: ========================================================================
:: clear_option5: Delete .git (with confirmation)
:: ========================================================================
:clear_option5
CLS
SET /p confirm=Are you sure you want to delete ALL .git folders? (y/n): 
IF /i "%confirm%"=="y" (
    ECHO Cleaning .git folders recursively...
	FOR /d /r "%~dp0" %%d IN (.git) DO (
		IF EXIST "%%d" (
			ECHO Deleting %%d
			RD /s /q "%%d"
		)
	)
	ECHO.
    ECHO Done!
    PAUSE
    GOTO main_option1
) ELSE (
    ECHO Canceled. Returning to menu...
	ECHO.
    PAUSE
    GOTO main_option1
)

:: ========================================================================
:: clear_option6: Delete custom folder
:: ========================================================================
:clear_option6
CLS
ECHO Delete a custom folder recursively.
ECHO Press 'z' to cancel and go back to main menu.
ECHO Wildcard '*' not allowed.
ECHO.
SET /p customFolderToClear=Enter the folder name to delete (e.g. dist, build, temp): 

:: Check if empty
IF "%customFolderToClear%"=="" (
    ECHO No folder name entered. Please try again.
    PAUSE
    GOTO clear_option6
)
:: Check if cancel
IF /I "%customFolderToClear%"=="z" (
    ECHO Canceling...
    PAUSE
    GOTO main_option1
)
:: Check for dangerous wildcard '*'
ECHO.%customFolderToClear% | FINDSTR "\*" >nul
IF %ERRORLEVEL%==0 (
	ECHO.
    ECHO ERROR: Wildcards * are not allowed. Please enter an exact folder name.
    PAUSE
    GOTO clear_option6
)

ECHO.
ECHO Cleaning "%customFolderToClear%" folders recursively...
FOR /d /r "%~dp0" %%d IN (%customFolderToClear%) DO (
    IF EXIST "%%d" (
        ECHO Deleting %%d
        RD /s /q "%%d"
    )
)

ECHO.
ECHO Done!
PAUSE
GOTO main_option1


:: ========================================================================
:: clear_option7: Clear NuGet cache
:: ========================================================================
:clear_option7
CLS
ECHO Cleaning NuGet cache...
nuget locals all -clear
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option1

:: ========================================================================
:: clear_option8: Clear npm cache
:: ========================================================================
:clear_option8
CLS
ECHO Cleaning npm cache...
npm cache clean --FORce
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option1














:: ========================================================================================================================
:: main_option2 - Git
:: ========================================================================================================================
:main_option2
SETLOCAL enabledelayedexpansion

CLS
ECHO ===========================================================================================
ECHO                                           Git
ECHO ===========================================================================================
ECHO.

:: First check if the current folder is itself a repository
IF EXIST "%~dp0\.git" (
    SET "selectedRepo=%~dp0"
    CLS
    ECHO WARNING: This batch tool is running directly inside a Git repository:
    ECHO   !selectedRepo!
    ECHO. 
    ECHO Some Git commands will be unavailable.
    ECHO. 
    PAUSE
    GOTO main_option2_menu
)

:: If not, search for repositories in subfolders recursively
ECHO Scanning for Git repositories...
SET gitRepoCount=0
FOR /r "%~dp0" %%d IN (.) DO (
    IF EXIST "%%d\.git" (
        SET /a gitRepoCount+=1
        SET "repo!gitRepoCount!=%%~fd"
    )
)
:: If no repositories are found
IF %gitRepoCount%==0 (
    ECHO. 
    ECHO No Git repositories found in this folder or its subfolders.
    ECHO. 
    PAUSE
    ENDLOCAL
    CD /d "%originalWorkDir%"
    GOTO main_menu
)
:: Git repositories menu
ECHO Found %gitRepoCount% repositories:
ECHO. 
FOR /l %%i IN (1,1,%gitRepoCount%) DO (
    ECHO   %%i. !repo%%i!
)
ECHO. 
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO. 
SET "choice="
SET /p choice=Choose a repository (1-%gitRepoCount%, z, or x): 

IF /i "%choice%"=="z" (
    ENDLOCAL
    CD /d "%originalWorkDir%"
    GOTO main_menu
)
IF /i "%choice%"=="x" GOTO exit
IF "%choice%"=="" (ECHO Invalid choice! & PAUSE & GOTO main_option2_menu)
IF %choice% GTR %gitRepoCount% (ECHO Invalid choice! & PAUSE & GOTO main_option2_menu)
IF %choice% LSS 1 (ECHO Invalid choice! & PAUSE & GOTO main_option2_menu)

SET "selectedRepo=!repo%choice%!"
CD /d "%selectedRepo%"


:: ========================================================================================================================
:: main_option2_menu - Git Menu
:: ========================================================================================================================
:main_option2_menu
CLS
ECHO ===========================================================================================
ECHO                                           Git Menu
ECHO ===========================================================================================
ECHO Repository: !selectedRepo!
ECHO.
ECHO   1. Restore tracked files               'git checkout .'
IF "%selectedRepo%"=="%~dp0" (
    ECHO   2. Remove untracked files and dirs.    'git clean -fd'        [Unavailable]
    ECHO   3. Remove everything untracked.        'git clean -fdx'       [Unavailable]
) ELSE (
    ECHO   2. Remove untracked files and dirs.    'git clean -fd'
    ECHO   3. Remove everything untracked.        'git clean -fdx'
)
ECHO   4. Prune branches                      'git fetch --prune'
ECHO   5. Checkout to develop                 'git checkout develop'
ECHO   6. Pull                                'git pull'
ECHO.
IF "%selectedRepo%"=="%~dp0" (
	ECHO   7. Restore - 1, 2, 5, 6, 4                                    [Unavailable]
) ELSE (
	ECHO   7. Restore - 1, 2, 5, 6, 4
)
ECHO. 
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO. 
SET "choice="
SET /p choice=Enter your choice (1-7, z, or x): 

:: Handle input
IF "%choice%"=="1" GOTO git_option1
IF "%choice%"=="2" GOTO git_option2
IF "%choice%"=="3" GOTO git_option3
IF "%choice%"=="4" GOTO git_option4
IF "%choice%"=="5" GOTO git_option5
IF "%choice%"=="6" GOTO git_option6
IF "%choice%"=="7" GOTO git_option7

IF /i "%choice%"=="z" (
    ENDLOCAL
    CD /d "%originalWorkDir%"
    GOTO main_menu
)
IF /i "%choice%"=="x" GOTO exit

ECHO Invalid choice!
PAUSE
GOTO main_option2_menu

:: ========================================================================
:: git_option1: Restore tracked files
:: ========================================================================
:git_option1
CLS
ECHO Restoring tracked files...
ECHO.
git checkout .
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option2_menu

:: ========================================================================
:: git_option2: Remove untracked files and dirs.
:: ========================================================================
:git_option2
IF "%selectedRepo%"=="%~dp0" (
    ECHO. 
    ECHO Option 2 is unavailable. Run this bat outside the repo.
    PAUSE
    GOTO main_option2_menu
)
CLS
ECHO This will delete all untracked files and directories.
SET /p confirm=Are you sure you want to remove untracked files and directories? (y/n): 
IF /i "%confirm%"=="y" (
	ECHO Removing untracked files and directories...
	ECHO.
	git clean -fd
	ECHO.
	IF %ERRORLEVEL%==0 (
		ECHO Command succeeded!
	) ELSE (
		ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
	)
	PAUSE
	GOTO main_option2_menu
) ELSE (
    ECHO Canceled. Returning to menu...
	ECHO.
    PAUSE
    GOTO main_option2_menu
)

:: ========================================================================
:: git_option3: Remove everything untracked.
:: ========================================================================
:git_option3
IF "%selectedRepo%"=="%~dp0" (
    ECHO. 
    ECHO Option 3 is unavailable. Run this bat outside the repo.
    PAUSE
    GOTO main_option2_menu
)
CLS
ECHO This will delete all untracked files and directories and also everything that is in .gitignore.
SET /p confirm=Are you sure you want to remove EVERYTHING untracked? (y/n): 
IF /i "%confirm%"=="y" (
    ECHO Removing everything untracked...
	git clean -fdx
	ECHO.
	IF %ERRORLEVEL%==0 (
		ECHO Command succeeded!
	) ELSE (
		ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
	)
    PAUSE
    GOTO main_option2_menu
) ELSE (
    ECHO Canceled. Returning to menu...
	ECHO.
    PAUSE
    GOTO main_option2_menu
)
	
ECHO Removing all untracked files...
ECHO.
git clean -fdx
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option2_menu


:: ========================================================================
:: git_option4: Prune branches
:: ========================================================================
:git_option4
CLS
ECHO Prune branches...
ECHO.
git fetch --prune
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option2_menu

:: ========================================================================
:: git_option5: Checkout to develop
:: ========================================================================
:git_option5
CLS
ECHO Checking out to develop...
ECHO.
git checkout develop
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option2_menu

:: ========================================================================
:: git_option6: Pull
:: ========================================================================
:git_option6
CLS
ECHO Pulling...
ECHO.
git pull
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option2_menu

:: ========================================================================
:: git_option7: Restore - 1, 2, 5, 6, 4 
:: ========================================================================
:git_option7
IF "%selectedRepo%"=="%~dp0" (
    ECHO. 
    ECHO Option 7 is unavailable. Run this bat outside the repo.
    PAUSE
    GOTO main_option2_menu
)
CLS
ECHO This will perform several git commands:
ECHO.
ECHO  1) Restore tracked files;             'git checkout .'
ECHO  2) Remove untracked files and dirs;   'git clean -fd'
ECHO  3) Checkout to develop;               'git checkout develop'
ECHO  4) Pull;                              'git pull'
ECHO  5) Prune branches.                    'git fetch --prune'
ECHO.
SET /p confirm=Are you sure you want to proceed? (y/n): 
IF /i "%confirm%"=="y" (
	ECHO Running full git restore sequence...
	ECHO.
	
	:: 1. Restore tracked files
	ECHO Step 1: Restore tracked files -git checkout .
	git checkout .
	ECHO.
	IF errorlevel 1 (
		ECHO ERROR: git checkout . failed with exit code %ERRORLEVEL%.
		PAUSE
		GOTO main_option2
	)
	
	:: 2. Remove untracked files
	ECHO Step 2: Remove untracked files -git clean -fd
	git clean -fd
	ECHO.
	IF errorlevel 1 (
		ECHO ERROR: git clean -fd failed with exit code %ERRORLEVEL%.
		PAUSE
		GOTO main_option2
	)
	
	:: 5. Checkout to develop
	ECHO Step 3: Checkout to develop -git checkout develop
	git checkout develop
	ECHO.
	IF errorlevel 1 (
		ECHO ERROR: git checkout develop failed with exit code %ERRORLEVEL%.
		PAUSE
		GOTO main_option2
	)
	
	:: 6. Pull
	ECHO Step 4: Pull -git pull
	git pull
	ECHO.
	IF errorlevel 1 (
		ECHO ERROR: git pull failed with exit code %ERRORLEVEL%.
		PAUSE
		GOTO main_option2
	)
	
	:: 4. Prune branches
	ECHO Step 5: Prune branches -git fetch --prune
	git fetch --prune
	ECHO.
	IF errorlevel 1 (
		ECHO ERROR: git fetch --prune failed with exit code %ERRORLEVEL%.
		PAUSE
		GOTO main_option2
	)
	
	ECHO.
	ECHO All commands completed successfully!
	PAUSE
	GOTO main_option2
) ELSE (
    ECHO Canceled. Returning to menu...
	ECHO.
    PAUSE
    GOTO main_option2
)






:: ========================================================================================================================
:: main_option3 - Windows Firewall
:: ========================================================================================================================
:main_option3
CLS
ECHO ===========================================================================================
ECHO                                   Windows Firewall
ECHO ===========================================================================================
ECHO  Searches for exe and dll files recursively and adds/deletes a rule on Windows Firewall
ECHO  to block all incoming and outgoing trafic. This option requires Administrator rights.
ECHO.
ECHO  Please select an option:
ECHO.
ECHO   1. Block all web trafic for exe and dll files
ECHO   2. Remove block rules for exe and dll files
ECHO.
ECHO   z. Back to main menu
ECHO   x. Exit
ECHO.
IF "%isAdmin%"=="1" (
    ECHO  Running with Administrator privileges.
) ELSE (
    ECHO  Not running as Administrator.
)
ECHO.
SET "choice="
SET /p choice=Enter your choice (1-2, z, or x): 

:: Handle input
IF "%choice%"=="1" GOTO firewall_option1
IF "%choice%"=="2" GOTO firewall_option2
IF /i "%choice%"=="z" GOTO main_menu
IF /i "%choice%"=="x" GOTO exit

ECHO Invalid choice! Please try again.
PAUSE
GOTO main_option3


:: ========================================================================
:: firewall_option1: Block all web traffic for exe and dll files
:: ========================================================================
:firewall_option1
CLS
IF "%isAdmin%"=="0" (
    ECHO ERROR: This option requires Administrator rights.
    ECHO Please restart the script as Administrator.
	ECHO.
    PAUSE
    GOTO main_option3
)

ECHO Blocking all web traffic for exe and dll files...
ECHO.
FOR /r "%~dp0" %%f IN (*.exe *.dll) DO (
	ECHO Adding block rules for: %%f
    netsh advfirewall firewall add rule name="Block %%~nxf" dir=out program="%%f" action=block
    netsh advfirewall firewall add rule name="Block %%~nxf" dir=IN  program="%%f" action=block
)
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option3



:: ========================================================================
:: firewall_option2: Removing block rules for exe and dll files
:: ========================================================================
:firewall_option2
CLS
IF "%isAdmin%"=="0" (
    ECHO ERROR: This option requires Administrator rights.
    ECHO Please restart the script as Administrator.
	ECHO.
    PAUSE
    GOTO main_option3
)

ECHO Removing block rules for exe and dll files...
ECHO.
FOR /r "%~dp0" %%f IN (*.exe *.dll) DO (
	ECHO Removing rules for: %%f
    netsh advfirewall firewall delete rule name="Block %%~nxf" program="%%f" dir=out
    netsh advfirewall firewall delete rule name="Block %%~nxf" program="%%f" dir=IN
)
ECHO.
IF %ERRORLEVEL%==0 (
    ECHO Command succeeded!
) ELSE (
    ECHO ERROR: Command failed with exit code %ERRORLEVEL%.
)
PAUSE
GOTO main_option3






:: ========================
:: Placeholder sections
:: ========================

:main_option4
ECHO You chose Option 4! & PAUSE & GOTO main_menu

:main_option5
ECHO You chose Option 5! & PAUSE & GOTO main_menu

:main_option6
ECHO You chose Option 6! & PAUSE & GOTO main_menu

:main_option7
ECHO You chose Option 7! & PAUSE & GOTO main_menu

:main_option8
ECHO You chose Option 8! & PAUSE & GOTO main_menu

:main_option9
ECHO You chose Option 9! & PAUSE & GOTO main_menu

:exit
ECHO Exiting... Goodbye!
exit





:: =============================
:: Subroutines
:: =============================

::IF "%choice%"=="" CALL :InvalidChoice main_option2_menu
:ChoiceInvalid
ECHO Invalid choice! & SET "choice=" & ECHO. & PAUSE & GOTO %~1

:ChoiceCancelled
ECHO Canceled. Returning to menu... & SET "choice=" & ECHO. & PAUSE & GOTO %~1

