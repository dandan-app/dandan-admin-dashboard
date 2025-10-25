#!/bin/bash

# Vercel Flutter Build Script for Dandan Admin Dashboard
# This script installs Flutter and builds the web app for Vercel deployment

set -e  # Exit on any error

echo "🚀 Starting Vercel Flutter Build Process..."

# Define Flutter version
FLUTTER_VERSION=${FLUTTER_VERSION:-"3.24.0"}
FLUTTER_CHANNEL="stable"

# Check if Flutter is already installed
if ! command -v flutter &> /dev/null; then
    echo "📦 Flutter not found. Installing Flutter ${FLUTTER_VERSION}..."
    
    # Create Flutter directory
    mkdir -p /tmp/flutter
    cd /tmp/flutter
    
    # Download Flutter SDK
    echo "⬇️ Downloading Flutter SDK..."
    if command -v wget &> /dev/null; then
        wget -q "https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz" -O flutter.tar.xz
    elif command -v curl &> /dev/null; then
        curl -sL "https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz" -o flutter.tar.xz
    else
        echo "❌ Error: Neither wget nor curl found. Cannot download Flutter."
        exit 1
    fi
    
    # Extract Flutter
    echo "📂 Extracting Flutter..."
    tar -xf flutter.tar.xz
    
    # Add Flutter to PATH
    export PATH="/tmp/flutter/flutter/bin:$PATH"
    
    echo "✅ Flutter installed successfully!"
else
    echo "✅ Flutter already available!"
fi

# Verify Flutter installation
echo "🔍 Verifying Flutter installation..."
flutter --version

# Navigate to project directory
echo "📁 Navigating to project directory..."
cd $VERCEL_PROJECT_ROOT || cd .

# Find pubspec.yaml (in case project is in subdirectory)
if [ ! -f "pubspec.yaml" ]; then
    echo "🔍 pubspec.yaml not found in root. Searching subdirectories..."
    PUBSPEC_DIR=$(find . -name "pubspec.yaml" -type f | head -1 | xargs dirname)
    if [ -n "$PUBSPEC_DIR" ]; then
        echo "📁 Found pubspec.yaml in: $PUBSPEC_DIR"
        cd "$PUBSPEC_DIR"
    else
        echo "❌ Error: pubspec.yaml not found anywhere!"
        exit 1
    fi
fi

echo "✅ Found pubspec.yaml in: $(pwd)"

# Configure Flutter for web
echo "🌐 Configuring Flutter for web..."
flutter config --enable-web --no-analytics

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Build for web
echo "🏗️ Building Flutter web app..."
flutter build web --release --web-renderer canvaskit

# Verify build output
if [ -d "build/web" ]; then
    echo "✅ Build successful! Output directory: build/web"
    echo "📊 Build contents:"
    ls -la build/web/
else
    echo "❌ Error: Build failed - build/web directory not found!"
    exit 1
fi

echo "🎉 Vercel Flutter build completed successfully!"
