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
    
    # Verify index.html exists
    if [ -f "build/web/index.html" ]; then
        echo "✅ index.html found in build/web"
        
        # Copy index.html to root for Vercel routing
        cp build/web/index.html ./index.html
        echo "✅ Copied index.html to root directory"
        
    else
        echo "❌ Error: index.html not found in build/web!"
        echo "🔧 Creating fallback index.html..."
        
        # Create a simple fallback if Flutter build failed
        cat > ./index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dandan Admin - Build Error</title>
</head>
<body>
    <h1>Build Error</h1>
    <p>Flutter build failed. Please check build logs.</p>
    <p>Time: $(date)</p>
</body>
</html>
EOF
    fi
    
    # Create a simple test file to verify deployment
    echo "Flutter Web App - Built $(date)" > build/web/build-info.txt
    echo "Flutter Web App - Built $(date)" > ./build-info.txt
    
    # List all files in root for debugging
    echo "📁 Root directory contents:"
    ls -la ./
    
else
    echo "❌ Error: Build failed - build/web directory not found!"
    
    # Create emergency fallback
    cat > ./index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dandan Admin - Build Failed</title>
</head>
<body>
    <h1>Build Failed</h1>
    <p>Flutter build completely failed. Please check configuration.</p>
</body>
</html>
EOF
    
    echo "🆘 Created emergency fallback index.html"
    exit 1
fi

echo "🎉 Vercel Flutter build completed successfully!"
echo "📁 Output ready for deployment in: build/web"
echo "📁 Root index.html ready for Vercel routing"
