# CMakeLists.txt for 16KB page size support
cmake_minimum_required(VERSION 3.22.1)

# Enable 16KB page size support
set(ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES ON)

# Set the minimum SDK version
set(CMAKE_ANDROID_API_MIN 26)

# Set the target SDK version
set(CMAKE_ANDROID_API 35)

# Configure for 16KB page sizes
set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)

# Add linker flags for 16KB page size support
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,-z,max-page-size=16384")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,-z,max-page-size=16384")

# Add any native libraries here if needed
# add_library(your_native_lib SHARED your_source.cpp)
