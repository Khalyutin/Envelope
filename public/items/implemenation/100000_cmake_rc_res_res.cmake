
if (WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    message(STATUS "========== by default CMake with llvm-rc create file with .rc.res.res extention instade of .rc.res") # -c65001    
    set(CMAKE_RC_COMPILE_OBJECT "<CMAKE_RC_COMPILER> <DEFINES> -i ${CMAKE_SOURCE_DIR}/native/include -i ${CMAKE_SOURCE_DIR}/native/samples -fo <OBJECT> <SOURCE>")
endif()