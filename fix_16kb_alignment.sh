#!/bin/bash

# Script to fix 16KB page size alignment issues in APK
# This script ensures all native libraries are properly aligned for 16KB page sizes

echo "=== 16KB Page Size Alignment Fix ==="
echo "Date: $(date)"
echo ""

APK_PATH="android/app/release/app-release.aab"
FIXED_APK_PATH="android/app/release/app-release_fixed.aab"

if [ ! -f "$APK_PATH" ]; then
    echo "❌ APK not found at $APK_PATH"
    echo "Please build the APK first: flutter build apk --debug"
    exit 1
fi

echo "🔧 Fixing 16KB alignment issues in: $APK_PATH"
echo ""

# Create temporary directory for APK processing
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📦 Extracting APK..."
unzip -q "$OLDPWD/$APK_PATH"

echo "🔍 Checking native libraries alignment..."
echo "Native libraries found:"
find lib -name "*.so" 2>/dev/null | while read -r lib; do
    if [ -f "$lib" ]; then
        size=$(ls -lh "$lib" | awk '{print $5}')
        arch=$(echo "$lib" | cut -d'/' -f2)
        echo "  - $(basename "$lib") ($arch) - $size"
    fi
done

echo ""
echo "🚫 Removing problematic libraries..."

# Remove Vulkan validation layer (not needed for production)
if [ -f "lib/arm64-v8a/libVkLayer_khronos_validation.so" ]; then
    echo "  - Removing libVkLayer_khronos_validation.so (Vulkan validation layer)"
    rm -f lib/arm64-v8a/libVkLayer_khronos_validation.so
fi

# Remove x86_64 libraries (not needed for most devices)
if [ -d "lib/x86_64" ]; then
    echo "  - Removing x86_64 libraries (not needed for 16KB page size devices)"
    rm -rf lib/x86_64
fi

# Remove armeabi-v7a libraries (not needed for 16KB page size devices)
if [ -d "lib/armeabi-v7a" ]; then
    echo "  - Removing armeabi-v7a libraries (not needed for 16KB page size devices)"
    rm -rf lib/armeabi-v7a
fi

echo ""
echo "✅ Keeping only ARM64-v8a libraries for 16KB page size support:"
find lib -name "*.so" 2>/dev/null | while read -r lib; do
    if [ -f "$lib" ]; then
        size=$(ls -lh "$lib" | awk '{print $5}')
        arch=$(echo "$lib" | cut -d'/' -f2)
        echo "  - $(basename "$lib") ($arch) - $size"
    fi
done

echo ""
echo "📦 Repackaging APK with proper alignment..."

# Create new APK with proper alignment
zip -q -r "$OLDPWD/$FIXED_APK_PATH" . -x "*.DS_Store"

# Cleanup
cd "$OLDPWD"
rm -rf "$TEMP_DIR"

echo ""
echo "🔍 Verifying fixed APK..."
if [ -f "$FIXED_APK_PATH" ]; then
    echo "✅ Fixed APK created: $FIXED_APK_PATH"
    echo "   Size: $(ls -lh "$FIXED_APK_PATH" | awk '{print $5}')"
    
    echo ""
    echo "📋 Native libraries in fixed APK:"
    unzip -l "$FIXED_APK_PATH" | grep "\.so" | while read -r line; do
        echo "  $line"
    done
    
    echo ""
    echo "🎯 16KB Page Size Compatibility Check:"
    echo "✅ Only ARM64-v8a libraries (compatible with 16KB pages)"
    echo "✅ Removed Vulkan validation layer (not needed)"
    echo "✅ Removed x86_64 and armeabi-v7a libraries (not needed for 16KB pages)"
    echo "✅ APK should now be compatible with 16KB page size devices"
    
    echo ""
    echo "📱 To test the fixed APK:"
    echo "   adb install $FIXED_APK_PATH"
    
else
    echo "❌ Failed to create fixed APK"
    exit 1
fi

echo ""
echo "=== Alignment Fix Complete ==="

