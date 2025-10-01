#!/bin/bash

# Test script to verify 16KB page size support
# This script helps verify that your app supports 16KB memory page sizes

echo "=== 16KB Page Size Support Test ==="
echo "Date: $(date)"
echo ""

# Check if device is connected
echo "1. Checking for connected Android devices..."
adb devices

echo ""
echo "2. Checking page size on connected device..."
adb shell getconf PAGE_SIZE

echo ""
echo "3. If the page size is 16384, your device supports 16KB pages"
echo "   If the page size is 4096, your device uses 4KB pages"

echo ""
echo "4. To test your app on a 16KB page size device:"
echo "   - Use Android emulator with 16KB page size support"
echo "   - Or use a physical device that supports 16KB pages"

echo ""
echo "5. Build and install your app:"
echo "   flutter build apk --target-platform android-arm64"
echo "   adb install build/app/outputs/flutter-apk/app-release.apk"

echo ""
echo "6. Test app functionality on the device"
echo "   - Launch the app"
echo "   - Test all major features"
echo "   - Check for crashes or performance issues"

echo ""
echo "=== Test Complete ==="
