

macro(enEnventoryItems)

    if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
        set(enUse_CLANG ON)
    endif()
    if (WIN32)
        set(enUse_MSW ON)
    endif()

    set(enCompiler ${CMAKE_CXX_COMPILER_ID}) 

    message(STATUS "=================================================================")
    message(STATUS "enUse_CLANG : ${enUse_CLANG}")
    message(STATUS "  enUse_MSW : ${enUse_MSW}")
    message(STATUS "=================================================================")

endmacro()


function(enInitPrivate)

    set(enProjectName Project-envelope PARENT_SCOPE)

    string(APPEND initText "# Your personal initialization setup here.\n")
    string(APPEND initText "\nset(CMAKE_INSTALL_PREFIX ../dist)")
    string(APPEND initText "\nset(enMS_MT_EXE mt.exe)")
    string(APPEND initText "\nset(enMS_RC_EXE rc.exe)")
    string(APPEND initText "\n# ...")

    string(APPEND implText "# Your personal implemenation setup here.\n")
    string(APPEND implText "\n# set(BUILD_SHARED_LIBS OFF)")
    string(APPEND implText "\n# ...")

    string(APPEND finlText "# Your personal finalization setup here.\n")
    string(APPEND finlText "\n# ...")

    string(APPEND aftrText "# Your personal post-build  macros here.\n")
    string(APPEND aftrText "# This file may be deleted.\n")
    string(APPEND aftrText "\n# ...")

    string(APPEND befrText "# Your personal pre-build  macros here.\n")
    string(APPEND befrText "# This file may be deleted.\n")
    string(APPEND befrText "\n# ...")

    string(APPEND macrText "# Your personal common CMake macros here.\n")
    string(APPEND macrText "# This file may be deleted.\n")
    string(APPEND macrText "\n# ...")

    string(APPEND initReadMe "# Place in this folder native project files.\n")
    string(APPEND initReadMe "# Of course, include CMakeList.txt.\n")

    string(APPEND natvText "# Native project initialization setup here.\n")
    string(APPEND natvText "# Parse project version etc...\n")
    string(APPEND natvText "\nset(enProjectName Project-envelope)\n")
    string(APPEND natvText "\n# ...\n")

    string(APPEND natvText "\n# macro(enInitNative)")
    string(APPEND natvText "\n#    ...")
    string(APPEND natvText "\n# endmacro()")
    string(APPEND natvText "\n# enInitNative()")
    
    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/private/items/initialization/setup.cmake) 
        file(WRITE ${CMAKE_SOURCE_DIR}/private/items/initialization/setup.cmake ${initText} )
    endif()
    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/private/items/implemenation/setup.cmake) 
        file(WRITE ${CMAKE_SOURCE_DIR}/private/items/implemenation/setup.cmake  ${implText})
    endif()
    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/private/items/finalization/setup.cmake) 
        file(WRITE ${CMAKE_SOURCE_DIR}/private/items/finalization/setup.cmake   ${finlText})
    endif()
    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/private/items/beforebuild) 
        file(WRITE ${CMAKE_SOURCE_DIR}/private/items/beforebuild/commands.cmake   ${befrText})
    endif()
    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/private/items/afterbuild) 
        file(WRITE ${CMAKE_SOURCE_DIR}/private/items/afterbbuild/commands.cmake  ${aftrText})
    endif()

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/private/macros) 
        file(WRITE ${CMAKE_SOURCE_DIR}/private/macros/common.cmake   ${macrText})
    endif()

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/native/CMakeLists.txt) 
        file(WRITE ${CMAKE_SOURCE_DIR}/native/CMakeLists.txt  ${initReadMe})
    endif()
    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/public/core/native.cmake) 
        file(WRITE ${CMAKE_SOURCE_DIR}/public/core/native.cmake ${natvText} )
    endif()

endfunction()


    ## !!  freeglut-devel

## https://github.com/llvm/llvm-project/issues/61997 
## https://github.com/wxWidgets/wxWidgets/issues/23428               


macro(enIncludeCMakeFolders enGroup enFolder)

    file(GLOB cmakeFiles public/${enFolder}${enGroup}/*.cmake)
    foreach(cmakeFile ${cmakeFiles})
        message(STATUS "include file ${cmakeFile} ")
        include(${cmakeFile})
    endforeach(cmakeFile)

    file(GLOB cmakeFiles private/${enFolder}${enGroup}/*.cmake)
    foreach(cmakeFile ${cmakeFiles})
        message(STATUS "include file ${cmakeFile} ")
        include(${cmakeFile})
    endforeach(cmakeFile)

    unset(enSourceFilder)
   
endmacro()

macro(enIncludeCMakeItems enGroup)
    enIncludeCMakeFolders("/${enGroup}" "items")
endmacro()

macro(enIncludeCMakeMacros)
    enIncludeCMakeFolders("" "macros")
endmacro()


macro(enInitialization)
    enInitPrivate()
    if (EXISTS ${CMAKE_SOURCE_DIR}/public/core/native.cmake)
        include(./public/core/native.cmake)
    endif()
    enIncludeCMakeItems("initialization") 
endmacro()

macro(enImplemenation)
    enEnventoryItems()
    enIncludeCMakeItems("implemenation") 
endmacro()

macro(enEncapsulation)
    if (EXISTS ${CMAKE_SOURCE_DIR}/native/CMakeLists.txt ) 
        add_subdirectory("native")
    endif()
endmacro()

macro(enFinalization)
    enAddAlwaysTargets()
    enIncludeCMakeItems("finalization") 
endmacro()
