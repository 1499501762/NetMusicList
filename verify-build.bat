@echo off
REM NetMusicList Build Verification Script

echo === NetMusicList Build Verification ===
echo.

REM Check if gradlew.bat exists
if not exist gradlew.bat (
    echo Error: gradlew.bat not found
    exit /b 1
)

echo OK: gradlew.bat found
echo.

REM Build with verbose output
echo Building project...
call gradlew.bat clean build --stacktrace

echo.
echo === Checking build output ===
echo.

if not exist build\libs (
    echo Error: build\libs directory not found
    exit /b 1
)

echo Contents of build\libs:
dir /s build\libs\

echo.
echo === JAR File Analysis ===
echo.

for /r build\libs %%F in (*.jar) do (
    echo.
    echo File: %%~nxF
    echo.
    REM Use jar command to list contents
    jar tf "%%F" | findstr /r "\.class$" > nul
    if errorlevel 1 (
        echo WARNING: No .class files found in this JAR!
    ) else (
        echo OK: Class files found
    )
    
    REM Show some entries
    echo First 20 entries:
    jar tf "%%F" | more +0
)

echo.
echo === Build Complete ===
pause
