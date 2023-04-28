
function(GET_EXEC_PATH OUT_PATH)
    # MSVC
    #file (SIZE "${CMAKE_CURRENT_LIST_DIR}/Src/OpenDrawer/CLUtil/Kernels.c" embeddedKernelSize)
    
    #if(embeddedKernelSize GREATER 1024)
    #    return()
    #endif()
    
    if(WIN32)
        file(GLOB_RECURSE EMBED_EXEC_PATH "${CMAKE_CURRENT_BINARY_DIR}/*/Embed2C.exe")
    else()
        file(GLOB_RECURSE EMBED_EXEC_PATH "${CMAKE_CURRENT_BINARY_DIR}/*/Embed2C")
    endif()
    
    if(EMBED_EXEC_PATH STREQUAL "")
        if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" OR CMAKE_C_COMPILER_ID STREQUAL "MSVC")
            message(WARNING "Embed2C not found, please build the Embed2C target inside Visual Studio first")
        else()
            message(WARNING "Embed2C not found, please run \"cmake --build . --target Embed2C\" in the build folder")
        endif()
        set(OUT_PATH "" PARENT_SCOPE)
    else()
        set(${OUT_PATH} ${EMBED_EXEC_PATH} PARENT_SCOPE)
    endif()
endfunction()

function(EMBED_FILES OUTPUT_FILE_PATH)
    #file(   COPY "${embedPath}" 
    #        DESTINATION "${CMAKE_CURRENT_LIST_DIR}/"
    #        FILE_PERMISSIONS OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
    
    set(EMBED_PATH "")
    
    GET_EXEC_PATH(EMBED_PATH)
    #message("EMBED_PATH: ${EMBED_PATH}")
    #message("OUTPUT_FILE_PATH: ${OUTPUT_FILE_PATH}")
    
    if(EMBED_PATH STREQUAL "")
        message(WARNING "Failed to run embed2C")
        return()
    endif()
    
    set(EMBED_COMMAND_ARGS)
    set(PRINT_EMBED_COMMAND_ARGS)
    math(EXPR LOOP_ARGC "${ARGC} - 1")
    foreach(INDEX RANGE 1 ${LOOP_ARGC})
        list(GET ARGV ${INDEX} CURRENT)
        set(EMBED_COMMAND_ARGS "${EMBED_COMMAND_ARGS};${CURRENT}")
        set(PRINT_EMBED_COMMAND_ARGS "${PRINT_EMBED_COMMAND_ARGS} \"${CURRENT}\"")
    endforeach()
    
    execute_process(OUTPUT_FILE         ${OUTPUT_FILE_PATH}
                    RESULT_VARIABLE     RET
                    COMMAND             ${EMBED_PATH} ${EMBED_COMMAND_ARGS})
    #message("Ran command ${EMBED_PATH} ${PRINT_EMBED_COMMAND_ARGS}")

    if(NOT RET EQUAL "0")
        message("RET: ${RET}")
        message(FATAL_ERROR "Failed to embed files")
    endif()
endfunction()

