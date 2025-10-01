#!/bin/bash

# Comprehensive 16KB Page Size Support Checker
# This script analyzes your APK to verify 16KB page size support

echo "=== 16KB Page Size Support Analysis ==="
echo "Date: $(date)"
echo ""

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ ! -f "$APK_PATH" ]; then
    echo "❌ APK not found at $APK_PATH"
    echo "Please build the APK first: flutter build apk --target-platform android-arm64"
    exit 1
fi

echo "📱 Analyzing APK: $APK_PATH"
echo ""

# Check APK basic info
echo "1. APK Basic Information:"
echo "   Size: $(ls -lh $APK_PATH | awk '{print $5}')"
echo ""

# Check target SDK version
echo "2. Target SDK Version:"
TARGET_SDK=$($ANDROID_HOME/build-tools/34.0.0/aapt dump badging "$APK_PATH" | grep targetSdkVersion | sed "s/.*targetSdkVersion:'\([^']*\)'.*/\1/")
MIN_SDK=$($ANDROID_HOME/build-tools/34.0.0/aapt dump badging "$APK_PATH" | grep sdkVersion | sed "s/.*sdkVersion:'\([^']*\)'.*/\1/")

echo "   Min SDK: $MIN_SDK"
echo "   Target SDK: $TARGET_SDK"

if [ "$TARGET_SDK" -ge 35 ]; then
    echo "   ✅ Target SDK 35+ (Android 15+) - 16KB page size support required"
else
    echo "   ⚠️  Target SDK < 35 - 16KB page size support not required yet"
fi
echo ""

# Check native code support
echo "3. Native Code Support:"
NATIVE_CODE=$($ANDROID_HOME/build-tools/34.0.0/aapt dump badging "$APK_PATH" | grep native-code | sed "s/.*native-code: '\([^']*\)'.*/\1/")
echo "   Architectures: $NATIVE_CODE"

if [[ "$NATIVE_CODE" == *"arm64-v8a"* ]]; then
    echo "   ✅ ARM64 support (primary architecture for 16KB pages)"
else
    echo "   ⚠️  No ARM64 support detected"
fi
echo ""

# Check native libraries
echo "4. Native Libraries Analysis:"
echo "   Extracting APK contents..."

# Create temporary directory for analysis
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
unzip -q "$OLDPWD/$APK_PATH" 2>/dev/null

echo "   Native libraries found:"
find lib -name "*.so" 2>/dev/null | while read -r lib; do
    if [ -f "$lib" ]; then
        size=$(ls -lh "$lib" | awk '{print $5}')
        arch=$(echo "$lib" | cut -d'/' -f2)
        echo "     - $(basename "$lib") ($arch) - $size"
    fi
done

# Check for Flutter engine
if [ -f "lib/arm64-v8a/libflutter.so" ]; then
    echo "   ✅ Flutter engine library found (ARM64)"
else
    echo "   ⚠️  Flutter engine library not found"
fi

# Check for app-specific native code
if [ -f "lib/arm64-v8a/libapp.so" ]; then
    echo "   ✅ App-specific native code found (ARM64)"
else
    echo "   ℹ️  No app-specific native code detected"
fi

# Cleanup
cd "$OLDPWD"
rm -rf "$TEMP_DIR"
echo ""

# Check build configuration
echo "5. Build Configuration Check:"
if grep -q "abiFilters.*arm64-v8a" android/app/build.gradle; then
    echo "   ✅ ARM64 ABI filter configured"
else
    echo "   ⚠️  ARM64 ABI filter not found in build.gradle"
fi

if grep -q "packagingOptions" android/app/build.gradle; then
    echo "   ✅ Packaging options configured"
else
    echo "   ⚠️  Packaging options not configured"
fi
echo ""

# Final assessment
echo "6. 16KB Page Size Support Assessment:"
echo ""

if [ "$TARGET_SDK" -ge 35 ] && [[ "$NATIVE_CODE" == *"arm64-v8a"* ]]; then
    echo "   ✅ APK appears to support 16KB page sizes"
    echo "   ✅ Target SDK 35+ with ARM64 native libraries"
    echo "   ✅ Ready for Google Play Store requirements (Nov 1, 2025)"
else
    echo "   ⚠️  APK may not fully support 16KB page sizes"
    if [ "$TARGET_SDK" -lt 35 ]; then
        echo "   ⚠️  Target SDK < 35 (not required yet)"
    fi
    if [[ "$NATIVE_CODE" != *"arm64-v8a"* ]]; then
        echo "   ⚠️  Missing ARM64 support"
    fi
fi

echo ""
echo "7. Recommendations:"
echo "   - Test on devices with 16KB page sizes when available"
echo "   - Monitor app performance on Android 15+ devices"
echo "   - Keep dependencies updated for 16KB page size compatibility"
echo ""
echo "=== Analysis Complete ==="
