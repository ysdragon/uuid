cmake_minimum_required(VERSION 3.16)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
project(RingUUID LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "macOS deployment target")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.15")
endif()

include(FetchContent)

set(RING_ROOT_DEFAULT "${CMAKE_CURRENT_SOURCE_DIR}/../..")
if(DEFINED ENV{RING})
    set(RING_ROOT_DEFAULT "$ENV{RING}")
endif()
set(RING_ROOT "${RING_ROOT_DEFAULT}" CACHE PATH "Path to the Ring project root directory.")
message(STATUS "Using Ring from: ${RING_ROOT}")

if(NOT TARGET Ring::Ring)
    add_library(Ring::Ring UNKNOWN IMPORTED)
    find_path(RING_INCLUDE_DIR ring.h PATHS "${RING_ROOT}/language/include")
    find_library(RING_LIBRARY_PATH NAMES ring PATHS "${RING_ROOT}/lib")

    if(NOT RING_INCLUDE_DIR OR NOT RING_LIBRARY_PATH)
        message(FATAL_ERROR "Could not find Ring headers or library in ${RING_ROOT}. "
                            "Please set the RING_ROOT cache variable correctly.")
    endif()

    set_target_properties(Ring::Ring PROPERTIES
        IMPORTED_LOCATION "${RING_LIBRARY_PATH}"
        INTERFACE_INCLUDE_DIRECTORIES "${RING_INCLUDE_DIR}"
    )
endif()

# Set paths
set(RING_INCLUDE "${RING_ROOT}/language/include")
set(RING_LIB "${RING_ROOT}/lib")
set(RING_BIN "${RING_ROOT}/bin")

# Determine OS and Architecture specific paths
string(TOLOWER "${CMAKE_SYSTEM_NAME}" OS_DIR)
if(OS_DIR STREQUAL "darwin")
    set(OS_DIR "macos")
endif()

string(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" ARCH_DIR_RAW)

if(CMAKE_SYSTEM_NAME STREQUAL "Windows" AND DEFINED CMAKE_GENERATOR_PLATFORM)
    if(CMAKE_GENERATOR_PLATFORM STREQUAL "Win32")
        set(ARCH_DIR_RAW "i386")
    elseif(CMAKE_GENERATOR_PLATFORM STREQUAL "x64")
        set(ARCH_DIR_RAW "amd64")
    elseif(CMAKE_GENERATOR_PLATFORM STREQUAL "ARM64")
        set(ARCH_DIR_RAW "arm64")
    else()
        message(WARNING "Unsupported CMAKE_GENERATOR_PLATFORM: ${CMAKE_GENERATOR_PLATFORM}, falling back to CMAKE_SYSTEM_PROCESSOR")
    endif()
endif()

if(NOT DEFINED ARCH_DIR)
    if(ARCH_DIR_RAW MATCHES "x86_64|amd64")
        set(ARCH_DIR "amd64")
    elseif(ARCH_DIR_RAW MATCHES "aarch64|arm64")
        set(ARCH_DIR "arm64")
    elseif(ARCH_DIR_RAW MATCHES "riscv64")
        set(ARCH_DIR "riscv64")
    elseif(ARCH_DIR_RAW MATCHES "i386|i686|x8x")
        set(ARCH_DIR "i386")
    else()
        set(ARCH_DIR "${ARCH_DIR_RAW}")
        message(WARNING "Unsupported architecture: ${ARCH_DIR_RAW}. Using as directory name.")
    endif()
endif()

# Set the destination directory for the built library
set(LIB_DEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lib/${OS_DIR}/${ARCH_DIR}")

# Configure stduuid build options
set(UUID_BUILD_TESTS OFF CACHE BOOL "Do not build stduuid tests")
set(UUID_BUILD_SHARED OFF CACHE BOOL "Build stduuid as a static library")

# Add jansson as a subdirectory to build it
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/c_src/stduuid/CMakeLists.txt")
    message(STATUS "stduuid source not found, fetching from GitHub...")
    FetchContent_Declare(
        stduuid
        GIT_REPOSITORY https://github.com/mariusbancila/stduuid.git
        GIT_TAG        v1.2.3
    )
    FetchContent_MakeAvailable(stduuid)
else()
    message(STATUS "stduuid found locally, adding as subdirectory.")
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)
    add_subdirectory(src/c_src/stduuid)
endif()

# Create the Ring UUID extension shared library
add_library(ring_uuid SHARED
	${CMAKE_CURRENT_SOURCE_DIR}/src/c_src/ring_uuid.cpp
)

# Include directories
target_include_directories(ring_uuid PRIVATE
	${RING_INCLUDE}
	${stduuid_SOURCE_DIR}/include
)

# Link libraries
target_link_libraries(ring_uuid PRIVATE
	Ring::Ring
	stduuid
)

target_compile_options(ring_uuid PRIVATE
    $<$<CONFIG:Release,RelWithDebInfo,MinSizeRel>:
        $<$<CXX_COMPILER_ID:MSVC>:/O2>
        $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-O3>
        -DNDEBUG
    >
    $<$<CXX_COMPILER_ID:MSVC>:/std:c++17>
)

# Set target properties for output name and prefix
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	set_target_properties(ring_uuid PROPERTIES
		OUTPUT_NAME "ring_uuid"
	)
endif()

# Move built library to lib directory
add_custom_command(
	TARGET ring_uuid
	POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E make_directory ${LIB_DEST_DIR}
	COMMAND ${CMAKE_COMMAND} -E rename $<TARGET_FILE:ring_uuid> ${LIB_DEST_DIR}/$<TARGET_FILE_NAME:ring_uuid>
	COMMENT "Moving built library to ${LIB_DEST_DIR}"
	VERBATIM
)

# Copy to bin directory on Windows
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	add_custom_command(
		TARGET ring_uuid
		POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E make_directory ${RING_BIN}
		COMMAND ${CMAKE_COMMAND} -E copy ${LIB_DEST_DIR}/$<TARGET_FILE_NAME:ring_uuid> ${RING_BIN}/$<TARGET_FILE_NAME:ring_uuid>
		COMMENT "Copying built library to bin directory"
		VERBATIM
	)
endif()

install(TARGETS ring_uuid
    LIBRARY DESTINATION "${RING_ROOT}/lib"
)

message(STATUS "Ring UUID Extension Configuration:")
message(STATUS "  - Ring Include Dir: ${RING_INCLUDE_DIR}")
message(STATUS "  - Ring Library Path: ${RING_LIBRARY_PATH}")
message(STATUS "  - stduuid Source Dir: ${stduuid_SOURCE_DIR}")