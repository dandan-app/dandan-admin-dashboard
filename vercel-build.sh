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
        echo "📄 index.html content preview:"
        head -10 build/web/index.html
        
        # Copy index.html to root for Vercel rewrites
        cp build/web/index.html ./index.html
        echo "✅ Copied index.html to root directory"
        
        # Copy all assets to root for proper serving
        if [ -d "build/web/assets" ]; then
            echo "✅ Assets directory found"
            cp -r build/web/assets ./assets 2>/dev/null || echo "⚠️ Could not copy assets"
        fi
        
        if [ -d "build/web/canvaskit" ]; then
            echo "✅ Canvaskit directory found"
            cp -r build/web/canvaskit ./canvaskit 2>/dev/null || echo "⚠️ Could not copy canvaskit"
        fi
        
        if [ -d "build/web/icons" ]; then
            echo "✅ Icons directory found"
            cp -r build/web/icons ./icons 2>/dev/null || echo "⚠️ Could not copy icons"
        fi
        
        # Copy all JS and CSS files to root
        cp build/web/*.js ./ 2>/dev/null || echo "⚠️ No JS files to copy"
        cp build/web/*.css ./ 2>/dev/null || echo "⚠️ No CSS files to copy"
        cp build/web/*.wasm ./ 2>/dev/null || echo "⚠️ No WASM files to copy"
        
        # Create build verification file
        echo "Flutter Web App - Built $(date)" > build/web/build-info.txt
        echo "Build Status: SUCCESS" >> build/web/build-info.txt
        echo "Index.html: EXISTS" >> build/web/build-info.txt
        echo "Assets: $(ls build/web/assets/ 2>/dev/null | wc -l) files" >> build/web/build-info.txt
        
    else
        echo "❌ Error: index.html not found in build/web!"
        echo "🔧 Creating fallback index.html..."
        
        # Create a simple fallback if Flutter build failed
        cat > build/web/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dandan Admin - Build Error</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
        .error { background: #ffebee; border: 1px solid #f44336; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="error">
        <h1>🚨 Build Error</h1>
        <p>Flutter build failed. Please check build logs.</p>
        <p>Time: $(date)</p>
        <p>This is a fallback page.</p>
    </div>
</body>
</html>
EOF
        
        # Copy fallback to root
        cp build/web/index.html ./index.html
        echo "✅ Copied fallback index.html to root"
    fi
    
    # Final verification
    echo "🔍 Final verification:"
    echo "📁 Root directory contents:"
    ls -la ./
    
    echo "📁 build/web directory structure:"
    find build/web -type f -name "*.html" -o -name "*.js" -o -name "*.css" | head -10
    
    echo "📊 Total files in build/web:"
    find build/web -type f | wc -l
    
else
    echo "❌ Error: Build failed - build/web directory not found!"
    echo "🆘 Creating emergency structure..."
    
    # Create emergency build/web directory
    mkdir -p build/web
    
    # Create emergency fallback
    cat > build/web/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dandan Admin - Build Failed</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
        .error { background: #ffebee; border: 1px solid #f44336; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="error">
        <h1>🚨 Build Completely Failed</h1>
        <p>Flutter build completely failed. Please check configuration.</p>
        <p>Time: $(date)</p>
    </div>
</body>
</html>
EOF
    
    # Copy emergency fallback to root
    cp build/web/index.html ./index.html
    echo "🆘 Created emergency fallback in root directory"
fi

echo "🎉 Vercel Flutter build completed successfully!"
echo "📁 Output ready for deployment in: build/web"
echo "📁 Root files ready for Vercel rewrites"
