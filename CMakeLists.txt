#####################################################################################################################################################
# CMAKE List
#
# Tips:
#   IF STATEMENT EXAMPLE:
#       SET(SRCS src.cpp)
#       IF(WIN32)
#           SET(SRCS ${SRCS} win_src.cpp)
#       ELSEIF(UNIX)
#           SET(SRCS ${SRCS} unix_src.cpp)
#       ELSE()
#
#       ENDIF()
#
#   Make with Debug (Default)
#       $ cd <path_to_cmakelist.txt>
#       $ mkdir build/debug
#       $ cd build/debug
#       $ cmake ../../ -DCMAKE_BUILD_TYPE=Debug
#
#   Make with Release
#       $ cd <path_to_cmakelist.txt>
#       $ mkdir build/release
#       $ cd build/release
#       $ cmake ../../ -DCMAKE_BUILD_TYPE=Release
#
#   Print a message
#       MESSAGE("variable is")
#
#   Print variable value
#       MESSAGE("variable is: " ${PROJECT_SOURCE_DIR} )
#   
#####################################################################################################################################################


# BEGIN CMAKE Version (Required Line) ---------------------------------------------------------------------------------------------------------------
CMAKE_MINIMUM_REQUIRED (VERSION 3.3.2)
# END CMAKE Version ---------------------------------------------------------------------------------------------------------------------------------


# set (CMAKE_CXX_STANDARD 11)


# If you need CUDA
# BEGIN CUDA Config ---------------------------------------------------------------------------------------------------------------------------------
#find_package(CUDA)
#SET(CUDA_NVCC_FLAGS
#    ${CUDA_NVCC_FLAGS}
#    -O3 
#	-gencode=arch=compute_61,code=\"sm_61,compute_61\"
#)
# END CUDA Config -----------------------------------------------------------------------------------------------------------------------------------


# BEGIN Target Name ---------------------------------------------------------------------------------------------------------------------------------
SET(TARGET_NAME sysc_fpga)
# END Target Name -----------------------------------------------------------------------------------------------------------------------------------


# BEGIN Project Name --------------------------------------------------------------------------------------------------------------------------------
PROJECT(${TARGET_NAME})
# END Project Name-----------------------------------------------------------------------------------------------------------------------------------


# BEGIN Debug / Release Settings --------------------------------------------------------------------------------------------------------------------
IF(EXISTS "${PROJECT_SOURCE_DIR}/DEBUG_BUILD")
    SET(CMAKE_BUILD_TYPE Debug)
	SET(BUILD_DIR_SUFFIX "debug")
ELSEIF(EXISTS "${PROJECT_SOURCE_DIR}/RELEASE_BUILD")
    SET(CMAKE_BUILD_TYPE Release)
	SET(BUILD_DIR_SUFFIX "release")
ELSEIF(NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE Debug)
	SET(BUILD_DIR_SUFFIX "debug")
ENDIF()
IF(WIN32)
	SET(CMAKE_CXX_FLAGS_DEBUG "/ZI /Od")
ELSE()
	SET(CMAKE_CXX_FLAGS_DEBUG "-g")
ENDIF()
SET(CMAKE_CXX_FLAGS_RELEASE "-O3")
MESSAGE("[" ${TARGET_NAME} "] Build Type: " ${CMAKE_BUILD_TYPE})
# END Debug / Release Settings ----------------------------------------------------------------------------------------------------------------------


# BEGIN Set VS startup Project (Affects Windows only) -----------------------------------------------------------------------------------------------
#SET_PROPERTY(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${TARGET_NAME})
# END Set VS startup Project ------------------------------------------------------------------------------------------------------------------------


# BEGIN Compiler Definitions ------------------------------------------------------------------------------------------------------------------------
#ADD_DEFINITIONS(-DLINUX)   #define LINUX
#ADD_DEFINITIONS(-ULINUX)   #undef  LINUX
# END Compiler Definitions --------------------------------------------------------------------------------------------------------------------------


# BEGIN Target Sources ------------------------------------------------------------------------------------------------------------------------------
FILE(GLOB TARGET_SRCS 
    ${PROJECT_SOURCE_DIR}/src/*.c
    ${PROJECT_SOURCE_DIR}/src/*.cpp
)
# END Target Sources --------------------------------------------------------------------------------------------------------------------------------


# BEGIN Target Headers ------------------------------------------------------------------------------------------------------------------------------
FILE(GLOB TARGET_HEADERS
    ${PROJECT_SOURCE_DIR}/inc/*.h 
    ${PROJECT_SOURCE_DIR}/inc/*.hpp
)
# END Target Headers --------------------------------------------------------------------------------------------------------------------------------


# BEGIN Library Settings ----------------------------------------------------------------------------------------------------------------------------
# For Visual studio this call must be before ADD_EXECUTABLE
#LINK_DIRECTORIES(
#    <path_to_lib0>
#    <path_to_lib1>
#    <path_to_libN>
#)
# END Library Settings ------------------------------------------------------------------------------------------------------------------------------


# BEGIN Target Settings -----------------------------------------------------------------------------------------------------------------------------
IF(NOT TARGET_SRCS)
    MESSAGE(FATAL_ERROR "No Source Files Specified")
ENDIF()
ADD_EXECUTABLE(${TARGET_NAME} ${TARGET_SRCS} ${TARGET_HEADERS})
# END Target Settings -------------------------------------------------------------------------------------------------------------------------------


# BEGIN Set Output Path for libs or bins ------------------------------------------------------------------------------------------------------------
# This command must come after ADD_EXECUTABLE or ADD_LIBRARY
SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES
                        RUNTIME_OUTPUT_DIRECTORY_DEBUG 
                        ${PROJECT_SOURCE_DIR}/build/debug)
SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES
                        RUNTIME_OUTPUT_DIRECTORY_RELEASE 
                        ${PROJECT_SOURCE_DIR}/build/release)
            
SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES
                        LIBRARY_OUTPUT_DIRECTORY_DEBUG 
                        ${PROJECT_SOURCE_DIR}/build/debug)
SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES
                        LIBRARY_OUTPUT_DIRECTORY_RELEASE
                        ${PROJECT_SOURCE_DIR}/build/release)
             
SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES
                        ARCHIVE_OUTPUT_DIRECTORY_DEBUG
                        ${PROJECT_SOURCE_DIR}/build/debug)
SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES
                        ARCHIVE_OUTPUT_DIRECTORY_RELEASE
                        ${PROJECT_SOURCE_DIR}/build/release)
# END Set Output Path for libs or bins --------------------------------------------------------------------------------------------------------------


# BEGIN Build dependencies --------------------------------------------------------------------------------------------------------------------------
# ${TARGET_NAME} depends on [<target-dependency>]
ADD_DEPENDENCIES(${TARGET_NAME} sysc_fpga_shim)
ADD_DEPENDENCIES(${TARGET_NAME} network)
ADD_DEPENDENCIES(${TARGET_NAME} syscNetProto)
ADD_DEPENDENCIES(${TARGET_NAME} cnn_layer_accel_model)
# END Build dependencies ----------------------------------------------------------------------------------------------------------------------------


# BEGIN Compiler Flags ------------------------------------------------------------------------------------------------------------------------------
TARGET_COMPILE_OPTIONS(${TARGET_NAME} PUBLIC 
    "-std=c++1y" 
    "-Wall"
	"-fPIC"
    "-fexceptions"
)
# END Compiler Flags --------------------------------------------------------------------------------------------------------------------------------


# BEGIN Include directories -------------------------------------------------------------------------------------------------------------------------
IF(WIN32)
    TARGET_INCLUDE_DIRECTORIES(${TARGET_NAME} PUBLIC
        ${PROJECT_SOURCE_DIR}/inc/
        C:/IkennaWorkSpace/systemC/systemc-2.3.3/src/
        ${PROJECT_SOURCE_DIR}/../../util/inc
        #<include_path0>
        #<include_path1>
        #<include_pathN>
    )
ELSE()
    TARGET_INCLUDE_DIRECTORIES(${TARGET_NAME} PUBLIC
        /usr/include/
        /usr/local/include/
        $ENV{IZO5011_X86_DEV_TOOLS}/include/
        ${PROJECT_SOURCE_DIR}/inc/
        ${PROJECT_SOURCE_DIR}/../util/inc/
        ${PROJECT_SOURCE_DIR}/../cnn_layer_accel/model/inc/
        ${PROJECT_SOURCE_DIR}/../network/inc/
        ${PROJECT_SOURCE_DIR}/../FPGA_shim/inc/
        ${PROJECT_SOURCE_DIR}/../SYSC_FPGA_shim/inc/
        ${PROJECT_SOURCE_DIR}/../syscNetProto/inc/
        ${PROJECT_SOURCE_DIR}/../espresso/inc/
        ${PROJECT_SOURCE_DIR}/../espresso/inc/FPGA/
        ${PROJECT_SOURCE_DIR}/../fixedPoint/inc/
        $ENV{DOWNLOADED_REPOS}/systemc-2.3.3/src/
		/home/mdl/izo5011/IkennaWorkSpace/izo5011_dev_tools/x86/include/
        #<include_path0>
        #<include_path1>
        #<include_pathN>
    )
ENDIF()
# END Include directories ---------------------------------------------------------------------------------------------------------------------------


# BEGIN Library Settings ----------------------------------------------------------------------------------------------------------------------------
# Libraries to be linked against
#   For shared libraries make sure.....
#       WINDOWS: PATH env variable includes path(s) to dll's
#       LINUX:  LD_LIBRARY_PATH env variablel includes path(s) to so's
#
#   If lib0 depends on lib1, list lib0 before lib1
#
IF(WIN32)
    TARGET_LINK_LIBRARIES(${TARGET_NAME} PUBLIC
        systemc.lib
    )
ELSE()
    TARGET_LINK_LIBRARIES(${TARGET_NAME} PUBLIC
        -L/usr/local/lib/
        -L/usr/lib/
        -L$ENV{DOWNLOADED_REPOS}/build/systemc-2.3.3/src/
        -L$ENV{IZO5011_X86_DEV_TOOLS}/lib/
        #-L/home/mdl/izo5011/IkennaWorkSpace/izo5011_dev_tools_redhat/x86/lib64/
        -L${PROJECT_SOURCE_DIR}/../syscNetProto/build/${BUILD_DIR_SUFFIX}/
        -L${PROJECT_SOURCE_DIR}/../network/build/${BUILD_DIR_SUFFIX}/
        -L${PROJECT_SOURCE_DIR}/../cnn_layer_accel/model/build/${BUILD_DIR_SUFFIX}/
        -L${PROJECT_SOURCE_DIR}/../SYSC_FPGA_shim//build/${BUILD_DIR_SUFFIX}/
        -L${PROJECT_SOURCE_DIR}/../espresso/build/${BUILD_DIR_SUFFIX}/
        -L${PROJECT_SOURCE_DIR}/../fixedPoint/build/${BUILD_DIR_SUFFIX}/
        -lsystemc
        -lespresso
        -lcnn_layer_accel_model
        -lsysc_fpga_shim
        # FIXME: create separate lib for espresso FPGA layer
        -lsyscNetProto
        -lnetwork
        -lpthread
        -lfixedPoint
    )
ENDIF()
# END Library Settings ------------------------------------------------------------------------------------------------------------------------------
