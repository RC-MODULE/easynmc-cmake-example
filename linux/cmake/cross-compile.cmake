# This file assumes that you have a linaro abe-based toolchain
# with a raspbian sysroot somewhere inside. This file also
# takes care to trick pkg-config into searching only toolchain's sysroot for
# the libraries

#Check if we're cross-compiling
if (NOT CROSS_COMPILE)
    return()
endif()

#Do not go further if there's a user-supplied cmake toolchain file
if (CMAKE_TOOLCHAIN_FILE)
    return()
endif()

SET(CROSS_COMPILING yes)
macro(SET_DEFAULT_VALUE _VAR _VALUE)
    if (NOT ${_VAR})
        SET(${_VAR} "${_VALUE}")
    endif()
endmacro()

SET_DEFAULT_VALUE(CMAKE_LIBRARY_PATH "${CROSS_COMPILE}")

SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_VERSION 1)

SET_DEFAULT_VALUE(CMAKE_C_COMPILER     ${CROSS_COMPILE}-gcc${CMAKE_EXECUTABLE_SUFFIX})
SET_DEFAULT_VALUE(CMAKE_CXX_COMPILER   ${CROSS_COMPILE}-g++${CMAKE_EXECUTABLE_SUFFIX})

find_program(CROSS_TOOLCHAIN_PATH NAMES ${CMAKE_C_COMPILER})
get_filename_component(CROSS_TOOLCHAIN_PATH "${CROSS_TOOLCHAIN_PATH}" PATH)

if (EXISTS ${CROSS_TOOLCHAIN_PATH}/../${CROSS_COMPILE}/sysroot)
    SET(CMAKE_FIND_ROOT_PATH  ${CROSS_TOOLCHAIN_PATH}/../${CROSS_COMPILE}/sysroot)
elseif(EXISTS ${CROSS_TOOLCHAIN_PATH}/../${CROSS_COMPILE}/libc)
    SET(CMAKE_FIND_ROOT_PATH  ${CROSS_TOOLCHAIN_PATH}/../${CROSS_COMPILE}/libc)
else()
    message(WARNING "Couldn't auto-detect sysroot dir")
endif()

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
message(STATUS "Using cross-sysroot ${CMAKE_FIND_ROOT_PATH}")

#Since autodetection will not work as expected when cross-compiling
#Let's fill in details
SET_DEFAULT_VALUE(LUA_CPATH "lib/lua/5.2/")
SET_DEFAULT_VALUE(LUA_LPATH "share/lua/5.2/")

#Tell pkg-config where to look for libraries.
#SYSROOT dir only makes sense and works on linux
if (UNIX)
    SET(ENV{PKG_CONFIG_SYSROOT_DIR} ${CMAKE_FIND_ROOT_PATH})
endif()

#Windows version of pkg-config expect ; as delimeters.
macro(add_pkg_config_path NEWPATH)
    if (WIN32)
        SET(SEPARATOR ";")
    else()
        SET(SEPARATOR ":")
    endif()
    SET(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}${SEPARATOR}${NEWPATH}")
endmacro()

SET(ENV{PKG_CONFIG_LIBDIR} ${CMAKE_FIND_ROOT_PATH}/usr/lib/pkgconfig/)

add_pkg_config_path(${CMAKE_FIND_ROOT_PATH}/usr/lib/${CMAKE_LIBRARY_PATH}/pkgconfig/)
add_pkg_config_path("${CMAKE_FIND_ROOT_PATH}/usr/share/pkgconfig/")
