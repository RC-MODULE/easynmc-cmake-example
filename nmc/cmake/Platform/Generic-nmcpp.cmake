# a free C compiler for 8 and 16 bit microcontrollers.
# To use it either a toolchain file is required or cmake has to be run like this:
# cmake -DCMAKE_C_COMPILER=NMC -DCMAKE_SYSTEM_NAME=Generic <dir...>
# Since NMC doesn't support C++, C++ support should be disabled in the
# CMakeLists.txt using the project() command:
# project(my_project C)

set(CMAKE_STATIC_LIBRARY_PREFIX "")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".lib")
set(CMAKE_SHARED_LIBRARY_PREFIX "")          # lib
set(CMAKE_SHARED_LIBRARY_SUFFIX ".lib")          # .so
set(CMAKE_IMPORT_LIBRARY_PREFIX )
set(CMAKE_IMPORT_LIBRARY_SUFFIX )
set(CMAKE_EXECUTABLE_SUFFIX ".abs")    # elf actually
set(CMAKE_LINK_LIBRARY_SUFFIX ".lib")
set(CMAKE_DL_LIBS "")

set(CMAKE_C_OUTPUT_EXTENSION ".asmx")

get_filename_component(NMC_LOCATION "${CMAKE_C_COMPILER}" PATH)
find_program(NMCLIBR_EXECUTABLE libr PATHS "${NMC_LOCATION}" NO_DEFAULT_PATH)
set(CMAKE_AR "${NMCLIBR_EXECUTABLE}" CACHE FILEPATH "The NMC librarian" FORCE)

# CMAKE_C_FLAGS_INIT and CMAKE_EXE_LINKER_FLAGS_INIT should be set in a CMAKE_SYSTEM_PROCESSOR file
if(NOT DEFINED CMAKE_C_FLAGS_INIT)
  set(CMAKE_C_FLAGS_INIT "-DNEURO -OPT2 -inline -Tc99")
endif()

if(NOT DEFINED CMAKE_EXE_LINKER_FLAGS_INIT)
  set (CMAKE_EXE_LINKER_FLAGS_INIT -m -heap=0 -heap1=0 -heap2=0 -heap3=0 -stack=20000 -full_names)
endif()

# compile a C file into an object file
set(CMAKE_C_COMPILE_OBJECT  "<CMAKE_C_COMPILER> -Tc99 <DEFINES> <FLAGS> <SOURCE> -O <OBJECT>")

# link object files to an executable
set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> <FLAGS> <OBJECTS> --out-fmt-ihx -o  <TARGET> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <LINK_LIBRARIES>")

# needs NMC 2.7.0 + sddclib from cvs
set(CMAKE_C_CREATE_STATIC_LIBRARY
      "\"${CMAKE_COMMAND}\" -E remove <TARGET>"
      "<CMAKE_AR> -a <TARGET> <LINK_FLAGS> <OBJECTS> ")

# not supported by NMC
set(CMAKE_C_CREATE_SHARED_LIBRARY "")
set(CMAKE_C_CREATE_MODULE_LIBRARY "")
