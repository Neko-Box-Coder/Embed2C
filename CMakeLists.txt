cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

project(Embed2C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD 11)

if(NOT TARGET Embed2C)
    add_executable(Embed2C "${CMAKE_CURRENT_LIST_DIR}/embed.c")
endif()
