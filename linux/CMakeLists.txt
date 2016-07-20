CMAKE_MINIMUM_REQUIRED(VERSION 2.8.8)

#Add our all-in-one cross-compile helper
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake)
include(cross-compile)

PROJECT(easynmc-example-project)
SET(PROJECT_VERSION   0.1)

SET(SRCS example.c)

FIND_PACKAGE(PkgConfig)
PKG_CHECK_MODULES(EASYNMC easynmc-0.1.1)

if ( ${CMAKE_BUILD_TYPE} MATCHES "Debug")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -finstrument-functions")
endif()

INCLUDE_DIRECTORIES(
  ${EASYNMC_INCLUDE_DIRS}
)

ADD_EXECUTABLE(easynmc-example ${SRCS})
TARGET_LINK_LIBRARIES(easynmc-example ${EASYNMC_LIBRARIES})
