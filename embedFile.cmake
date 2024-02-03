
function(GET_EXEC_PATH OUT_PATH)
    if(WIN32)
        file(GLOB_RECURSE EMBED_EXEC_PATH "${CMAKE_CURRENT_BINARY_DIR}/*/Embed2C.exe")
    else()
        file(GLOB_RECURSE EMBED_EXEC_PATH "${CMAKE_CURRENT_BINARY_DIR}/*/Embed2C")
    endif()
    
    list(LENGTH EMBED_EXEC_PATH EMBED_EXEC_PATH_LENGTH)
    
    if(EMBED_EXEC_PATH STREQUAL "")
        if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" OR CMAKE_C_COMPILER_ID STREQUAL "MSVC")
            message(WARNING "Embed2C not found, please build the Embed2C target inside Visual Studio first")
        else()
            message(WARNING "Embed2C not found, please run \"cmake --build . --target Embed2C\" in the build folder")
        endif()
        set(OUT_PATH "" PARENT_SCOPE)
    elseif(NOT EMBED_EXEC_PATH_LENGTH EQUAL 1)
        message(FATAL_ERROR "More than 1 Embed2C executable found: ${EMBED_EXEC_PATH}")
    else()
        set(${OUT_PATH} ${EMBED_EXEC_PATH} PARENT_SCOPE)
    endif()
endfunction()

function(EMBED_FILES EMBED_PATH OUTPUT_FILE_PATH FILES_TO_EMBED)
    if(EMBED_PATH STREQUAL "")
        message(WARNING "Failed to run embed2C")
        return()
    endif()
    
    set(PRINT_EMBED_COMMAND_ARGS)
    
    foreach(FILE_TO_EMBED ${FILES_TO_EMBED})
        set(PRINT_EMBED_COMMAND_ARGS "${PRINT_EMBED_COMMAND_ARGS}\"${FILE_TO_EMBED}\" ")
    endforeach()
    
    get_filename_component(OUTPUT_FILE_DIR ${OUTPUT_FILE_PATH} DIRECTORY)
    
    if(NOT EXISTS ${OUTPUT_FILE_DIR})
        message(FATAL_ERROR "The directory ${OUTPUT_FILE_DIR} does not exist")
    endif()
    
    execute_process(OUTPUT_FILE         ${OUTPUT_FILE_PATH}
                    RESULT_VARIABLE     RET
                    COMMAND             ${EMBED_PATH} ${FILES_TO_EMBED})

    if(NOT RET EQUAL "0")
        message("RET: ${RET}")
        message("OUTPUT_FILE_PATH: ${OUTPUT_FILE_PATH}")
        message("Ran command ${EMBED_PATH} ${PRINT_EMBED_COMMAND_ARGS}")
        message(FATAL_ERROR "Failed to embed files")
    endif()
endfunction()

