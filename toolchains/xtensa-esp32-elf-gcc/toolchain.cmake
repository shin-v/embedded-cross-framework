# ESP32 Toolchain File

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR XTENSA)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Executable file extension
IF(WIN32)
 SET(TOOLCHAIN_EXE ".exe")
ELSE()
 SET(TOOLCHAIN_EXE "")
ENDIF()

# The triplet to use for the target
SET(TARGET_TRIPLET "xtensa-esp32-elf")

# Find the compiler
find_program(TOOLCHAIN_COMPILER NAME "${TARGET_TRIPLET}-gcc${TOOLCHAIN_EXE}" 
    PATHS "~/.espressif/tools"
)

MESSAGE(STATUS "TOOLCHAIN_COMPILER: " ${TOOLCHAIN_COMPILER})

# Set up toolchain paths
get_filename_component(XTENSA_ELF_TOOLCHAIN_DIR ${TOOLCHAIN_COMPILER} DIRECTORY)

# Find include and lib directories
find_file(TOOLCHAIN_STRING_H NAMES "string.h" PATHS ${XTENSA_ELF_TOOLCHAIN_DIR}/../${TARGET_TRIPLET}/include /usr/local/${TARGET_TRIPLET}/include /usr/local/${TARGET_TRIPLET}/${TARGET_TRIPLET}/include /usr/${TARGET_TRIPLET}/include /usr/include/${TARGET_TRIPLET} /usr/local/Cellar/${TARGET_TRIPLET}-gcc*/*/${TARGET_TRIPLET}/${TARGET_TRIPLET}/include /opt/homebrew/Cellar/${TARGET_TRIPLET}-gcc*/*/${TARGET_TRIPLET}/${TARGET_TRIPLET}/include)
get_filename_component(XTENSA_ELF_TOOLCHAIN_INCLUDE_DIR ${TOOLCHAIN_STRING_H} DIRECTORY)

find_library(TOOLCHAIN_LIBC NAMES "c" PATHS ${XTENSA_ELF_TOOLCHAIN_DIR}/../${TARGET_TRIPLET}/lib /usr/local/${TARGET_TRIPLET}/lib /usr/local/${TARGET_TRIPLET}/${TARGET_TRIPLET}/lib /usr/${TARGET_TRIPLET}/lib /usr/include/${TARGET_TRIPLET} /usr/local/Cellar/${TARGET_TRIPLET}-gcc*/*/${TARGET_TRIPLET}/${TARGET_TRIPLET}/lib /opt/homebrew/Cellar/${TARGET_TRIPLET}-gcc*/*/${TARGET_TRIPLET}/${TARGET_TRIPLET}/lib)
get_filename_component(XTENSA_ELF_TOOLCHAIN_LIB_DIR ${TOOLCHAIN_LIBC} DIRECTORY)

set(TOOLCHAIN_INCLUDE_DIRS ${XTENSA_ELF_TOOLCHAIN_INCLUDE_DIR})
set(TOOLCHAIN_LIBDIR ${XTENSA_ELF_TOOLCHAIN_LIB_DIR})

MESSAGE(STATUS "TOOLCHAIN_INCLUDE_DIR: " ${TOOLCHAIN_INCLUDE_DIRS})
MESSAGE(STATUS "TOOLCHAIN_LIBRARY_DIR: " ${TOOLCHAIN_LIBDIR})

set(XTENSA_ELF_BINUTILS_PATH ${XTENSA_ELF_TOOLCHAIN_DIR})
set(TOOLCHAIN_PREFIX ${XTENSA_ELF_TOOLCHAIN_DIR}/${TARGET_TRIPLET})

# Set compilers
set(CMAKE_C_COMPILER "${TOOLCHAIN_PREFIX}-gcc${TOOLCHAIN_EXE}")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}-g++${TOOLCHAIN_EXE}")
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})

# Set other tools
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}-objcopy${TOOLCHAIN_EXE} CACHE INTERNAL "objcopy tool")
set(CMAKE_OBJDUMP ${TOOLCHAIN_PREFIX}-objdump${TOOLCHAIN_EXE} CACHE INTERNAL "objdump tool")
set(CMAKE_RANLIB ${TOOLCHAIN_PREFIX}-ranlib${TOOLCHAIN_EXE} CACHE INTERNAL "ranlib tool")
set(CMAKE_READELF ${TOOLCHAIN_PREFIX}-readelf${TOOLCHAIN_EXE} CACHE INTERNAL "readelf tool")
set(CMAKE_SIZE ${TOOLCHAIN_PREFIX}-size${TOOLCHAIN_EXE} CACHE INTERNAL "size tool")
set(CMAKE_STRIP ${TOOLCHAIN_PREFIX}-strip${TOOLCHAIN_EXE} CACHE INTERNAL "strip tool")
set(CMAKE_AR ${TOOLCHAIN_PREFIX}-ar${TOOLCHAIN_EXE} CACHE INTERNAL "ar tool")
set(CMAKE_NM ${TOOLCHAIN_PREFIX}-nm${TOOLCHAIN_EXE} CACHE INTERNAL "nm tool")
set(CMAKE_LINKER ${TOOLCHAIN_PREFIX}-ld${TOOLCHAIN_EXE} CACHE INTERNAL "ld tool")

# Root path for finding libraries/includes
set(CMAKE_FIND_ROOT_PATH ${XTENSA_ELF_BINUTILS_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# ESP-IDF specific flags
set(_CMAKE_TOOLCHAIN_PREFIX xtensa-esp32-elf-)

# Imported from esp-idf utilities.cmake
# Remove duplicates from a string containing compilation flags
function(remove_duplicated_flags FLAGS UNIQFLAGS)
    set(FLAGS_LIST "${FLAGS}")
    # Convert the given flags, as a string, into a CMake list type
    separate_arguments(FLAGS_LIST)
    # Remove all the duplicated flags
    list(REMOVE_DUPLICATES FLAGS_LIST)
    # Convert the list back to a string
    string(REPLACE ";" " " FLAGS_LIST "${FLAGS_LIST}")
    # Return that string to the caller
    set(${UNIQFLAGS} "${FLAGS_LIST}" PARENT_SCOPE)
endfunction()

# Set and clean up flags
remove_duplicated_flags("-mlongcalls -Wno-frame-address \
 -fno-builtin-memcpy -fno-builtin-memset -fno-builtin-bzero \
 -fno-builtin-stpcpy -fno-builtin-strncpy \
 ${CMAKE_C_FLAGS}" UNIQ_CMAKE_C_FLAGS)
set(CMAKE_C_FLAGS "${UNIQ_CMAKE_C_FLAGS}" CACHE STRING "C Compiler Base Flags" FORCE)

remove_duplicated_flags("-mlongcalls -Wno-frame-address \
 -fno-builtin-memcpy -fno-builtin-memset -fno-builtin-bzero \
 -fno-builtin-stpcpy -fno-builtin-strncpy \
 ${CMAKE_CXX_FLAGS}" UNIQ_CMAKE_CXX_FLAGS)
set(CMAKE_CXX_FLAGS "${UNIQ_CMAKE_CXX_FLAGS}" CACHE STRING "C++ Compiler Base Flags" FORCE)

remove_duplicated_flags("-mlongcalls ${CMAKE_ASM_FLAGS}" UNIQ_CMAKE_ASM_FLAGS)
set(CMAKE_ASM_FLAGS "${UNIQ_CMAKE_ASM_FLAGS}" CACHE STRING "ASM Compiler Base Flags" FORCE)

# Toolchain link libraries
set(TOOLCHAIN_LIBS
 -Wl,--start-group
 m
 c
 gcc
 nosys
 -Wl,--end-group
)