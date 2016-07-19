# a free C compiler for 8 and 16 bit microcontrollers.
# To use it either a toolchain file is required or cmake has to be run like this:
# cmake -DCMAKE_C_COMPILER=NMC -DCMAKE_SYSTEM_NAME=Generic <dir...>
# Since NMC doesn't support C++, C++ support should be disabled in the
# CMakeLists.txt using the project() command:
# project(my_project C)

#this one not so much

set(CMAKE_STATIC_LIBRARY_PREFIX "")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".lib")
set(CMAKE_SHARED_LIBRARY_PREFIX "")          # lib
set(CMAKE_SHARED_LIBRARY_SUFFIX ".lib")          # .so
set(CMAKE_IMPORT_LIBRARY_PREFIX )
set(CMAKE_IMPORT_LIBRARY_SUFFIX )
set(CMAKE_EXECUTABLE_SUFFIX ".abs")    # elf actually
set(CMAKE_LINK_LIBRARY_SUFFIX ".lib")
set(CMAKE_DL_LIBS "")

set(CMAKE_C_OUTPUT_EXTENSION ".o")
set(CMAKE_CXX_OUTPUT_EXTENSION ".o")

if (CMAKE_C_COMPILER)
  get_filename_component(NMC_LOCATION "${CMAKE_C_COMPILER}" PATH)
elseif(CMAKE_CXX_COMPILER)
  get_filename_component(NMC_LOCATION "${CMAKE_CXX_COMPILER}" PATH)
elseif(CMAKE_ASM_COMPILER)
  get_filename_component(NMC_LOCATION "${CMAKE_ASM_COMPILER}" PATH)
endif()


find_program(NMCLIBR_EXECUTABLE libr PATHS "${NMC_LOCATION}" NO_DEFAULT_PATH)
set(CMAKE_AR "${NMCLIBR_EXECUTABLE}")

find_program(NMCLINKER_EXECUTABLE linker PATHS "${NMC_LOCATION}" NO_DEFAULT_PATH)
set(CMAKE_LINKER "${NMCLINKER_EXECUTABLE}")

if (NOT NMC_LIBC)
  SET(NMC_LIBC "libc05.lib")
endif()

set(CMAKE_C_COMPILE_OBJECT  "<CMAKE_C_COMPILER> -Tc99 <DEFINES> <FLAGS> -Sc <SOURCE> -o<OBJECT>")
set(CMAKE_CXX_COMPILE_OBJECT  "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> -Sc <SOURCE> -o<OBJECT>")
set(CMAKE_ASM_COMPILE_OBJECT  "<CMAKE_ASM_COMPILER> <DEFINES> <FLAGS> <SOURCE> -o<OBJECT>")

set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_LINKER> <OBJECTS> -o<TARGET> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> -l\"$ENV{NEURO}/lib\" <LINK_LIBRARIES> ${NMC_LIBC}")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> <OBJECTS> -o<TARGET> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -l\"$ENV{NEURO}/lib\" <LINK_LIBRARIES> ${NMC_LIBC}")

#set(CMAKE_C_LINK_EXECUTABLE "cat")
# needs NMC 2.7.0 + sddclib from cvs
set(CMAKE_C_CREATE_STATIC_LIBRARY
      "\"${CMAKE_COMMAND}\" -E remove <TARGET>"
      "<CMAKE_AR> -a <TARGET> <LINK_FLAGS> <OBJECTS> ")

# not supported by NMC
set(CMAKE_C_CREATE_SHARED_LIBRARY "")
set(CMAKE_C_CREATE_MODULE_LIBRARY "")
