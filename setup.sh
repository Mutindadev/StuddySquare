#!/bin/bash
# setup.sh

echo "🚀 Setting up StudySquare development environment..."

# Check if FVM is installed
if ! command -v fvm &> /dev/null; then
    echo "❌ FVM not found. Please install FVM first:"
    echo "dart pub global activate fvm"
    exit 1
fi

# Check if SDKMAN is installed
if [[ ! -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    echo "❌ SDKMAN not found. Please install SDKMAN first:"
    echo "curl -s \"https://get.sdkman.io\" | bash"
    exit 1
fi

# Source SDKMAN
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install and use correct Flutter version
echo "📱 Setting up Flutter..."
fvm install
fvm use

# Install and use correct Java version
echo "☕ Setting up Java..."
sdk env install
sdk env

# Install dependencies
echo "📦 Installing dependencies..."
fvm flutter pub get

echo "✅ Setup complete! You can now run the app with: fvm flutter run"