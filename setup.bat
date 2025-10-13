@echo off
REM setup.bat

echo 🚀 Setting up StudySquare development environment...

REM Check if FVM is installed
fvm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ FVM not found. Please install FVM first:
    echo dart pub global activate fvm
    exit /b 1
)

REM Install and use correct Flutter version
echo 📱 Setting up Flutter...
fvm install
fvm use

REM Install dependencies
echo 📦 Installing dependencies...
fvm flutter pub get

echo ✅ Setup complete! You can now run the app with: fvm flutter run
echo ⚠️  Please ensure you have Java 21 installed for Android development