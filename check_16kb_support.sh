#!/bin/bash

# Comprehensive 16KB Page Size Support Checker (APK or AAB)
# - For APK: uses aapt to read manifest and ABIs
# - For AAB: inspects bundle structure (base/lib/**) without aapt

echo "=== 16KB Page Size Support Analysis ==="
echo "Date: $(date)"
echo ""

APK_PATH="${1:-android/app/release/app-release.aab}"

if [ ! -f "$APK_PATH" ]; then
  echo "❌ File not found at $APK_PATH"
  echo "Usage: $0 <path-to-apk-or-aab>"
  exit 1
fi

echo "📱 Analyzing: $APK_PATH"
echo ""

# 1) Basic info
echo "1. Artifact Information:"
echo "   Size: $(ls -lh "$APK_PATH" | awk '{print $5}')"
EXT="${APK_PATH##*.}"
echo "   Type: .$EXT"
echo ""

# Utility: safe aapt dump
safe_aapt_dump() {
  "$ANDROID_HOME"/build-tools/34.0.0/aapt dump badging "$APK_PATH" 2>/dev/null || true
}

TARGET_SDK=""
MIN_SDK=""
ABIS=""

# 2) SDK and ABI detection
if [ "$EXT" = "apk" ]; then
  echo "2. Target SDK Version:"
  BADGING="$(safe_aapt_dump)"
  TARGET_SDK=$(echo "$BADGING" | grep targetSdkVersion | sed "s/.*targetSdkVersion:'\([^']*\)'.*/\1/")
  MIN_SDK=$(echo "$BADGING" | grep sdkVersion | sed "s/.*sdkVersion:'\([^']*\)'.*/\1/")
  echo "   Min SDK: ${MIN_SDK:-unknown}"
  echo "   Target SDK: ${TARGET_SDK:-unknown}"
  if [ -n "$TARGET_SDK" ] && [ "$TARGET_SDK" -ge 35 ] 2>/dev/null; then
    echo "   ✅ Target SDK 35+ (Android 15+) - 16KB page size support required"
  else
    echo "   ℹ️  Target SDK < 35 or unknown"
  fi
  echo ""

  echo "3. Native Code Support:"
  ABIS=$(echo "$BADGING" | grep native-code | sed "s/.*native-code: '\([^']*\)'.*/\1/")
  echo "   Architectures: ${ABIS:-unknown}"
  if echo "$ABIS" | grep -q "arm64-v8a"; then
    echo "   ✅ ARM64 support (primary architecture for 16KB pages)"
  else
    echo "   ⚠️  No ARM64 support detected"
  fi
  echo ""
else
  echo "2. Target SDK Version:"
  echo "   ℹ️  Skipped (AAB manifest is binary; use Play Console or bundletool for exact values)"
  echo ""

  echo "3. Native Code Support:"
  # For AAB, list ABIs by inspecting base/lib/*
  TEMP_DIR=$(mktemp -d)
  unzip -q "$APK_PATH" -d "$TEMP_DIR" 2>/dev/null || true
  if [ -d "$TEMP_DIR/base/lib" ]; then
    ABIS=$(ls -1 "$TEMP_DIR/base/lib" 2>/dev/null | tr '\n' ' ' | sed 's/ $//')
  elif [ -d "$TEMP_DIR/lib" ]; then
    ABIS=$(ls -1 "$TEMP_DIR/lib" 2>/dev/null | tr '\n' ' ' | sed 's/ $//')
  fi
  echo "   Architectures: ${ABIS:-none}"
  if echo "$ABIS" | grep -q "arm64-v8a"; then
    echo "   ✅ ARM64 support (primary architecture for 16KB pages)"
  else
    echo "   ⚠️  No ARM64 support detected"
  fi
  echo ""
fi

# 4) Native libraries inventory
echo "4. Native Libraries Analysis:"
echo "   Extracting contents..."
TMP=$(mktemp -d)
unzip -q "$APK_PATH" -d "$TMP" 2>/dev/null || true
LIB_ROOT=""
if [ -d "$TMP/lib" ]; then
  LIB_ROOT="$TMP/lib"
elif [ -d "$TMP/base/lib" ]; then
  LIB_ROOT="$TMP/base/lib"
fi

if [ -n "$LIB_ROOT" ]; then
  echo "   Native libraries found:"
  find "$LIB_ROOT" -name "*.so" 2>/dev/null | while read -r so; do
    size=$(ls -lh "$so" | awk '{print $5}')
    arch=$(echo "$so" | awk -F "/" '{for(i=1;i<=NF;i++){if($i=="lib"){print $(i+1);break}}}')
    echo "     - $(basename "$so") ($arch) - $size"
  done
  if [ -f "$LIB_ROOT/arm64-v8a/libflutter.so" ]; then
    echo "   ✅ Flutter engine library found (ARM64)"
  else
    echo "   ⚠️  Flutter engine library not found (ARM64)"
  fi
  if [ -f "$LIB_ROOT/arm64-v8a/libapp.so" ]; then
    echo "   ✅ App-specific native code found (ARM64)"
  else
    echo "   ℹ️  No app-specific native code detected (ARM64)"
  fi
else
  echo "   ℹ️  No lib/ directory found in artifact"
fi

# 5) Build configuration hints (from Gradle files)
echo ""
echo "5. Build Configuration Check:"
if grep -q "abiFilters.*arm64-v8a" android/app/build.gradle; then
  echo "   ✅ ARM64 ABI filter configured"
else
  echo "   ⚠️  ARM64 ABI filter not found in build.gradle"
fi
# User migrated to `packaging { jniLibs { useLegacyPackaging = false } }`
if grep -q "packaging[[:space:]]*{[[:space:]]*jniLibs" android/app/build.gradle; then
  echo "   ✅ Packaging (jniLibs/useLegacyPackaging=false) configured"
else
  echo "   ⚠️  Packaging (jniLibs) not configured"
fi

# 6) Final assessment
echo ""
echo "6. 16KB Page Size Support Assessment:"
HAS_ARM64="false"
if echo "$ABIS" | grep -q "arm64-v8a"; then HAS_ARM64="true"; fi

if [ "$HAS_ARM64" = "true" ]; then
  echo "   ✅ Artifact includes ARM64 libraries (required for 16KB devices)"
else
  echo "   ⚠️  Missing ARM64 libraries"
fi

echo ""
echo "7. Recommendations:"
echo "   - Use release builds for Play submission (debug may include validation layers)"
echo "   - Test on devices/emulators with 16KB page sizes when available"
echo "   - Keep plugins/SDKs updated for 16KB compatibility"

echo ""
rm -rf "$TMP" "$TEMP_DIR" 2>/dev/null || true
echo "=== Analysis Complete ==="

