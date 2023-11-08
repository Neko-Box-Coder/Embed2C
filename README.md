## Embed2C
---
A quick C program for embedding binary files into array in .c file.
This repo also has additional cmake function script for automatically embedding files
<br>
<br>
<br>
### Building
---

`gcc -o Embed2C embed.c` (Add .exe on Windows)

or

`mkdir Build && cd Build && cmake .. && cmake --build .` (Might need to add generator arguments on Windows)
<br>
<br>
<br>
### Running
---

`Embed2C "<path/to/file/to/embed>" "EmbeddedFile" "<path/to/file2/to/embed>" "EmbeddedFile2" ...`

which will output to console:

```c
#include <stdint.h>
#include <stddef.h>
const uint8_t EmbeddedFile[] = {
    //Contents...
};
const size_t EmbeddedFile_size;
const uint8_t EmbeddedFile2[] = {
    //Contents...
};
const size_t EmbeddedFile2_size;
```

You can save the output from console to a file with `Embed2C ... > EmbeddedFiles.c`
<br>
To use the variable in other files, just forward declarate like this
```c
extern const uint8_t EmbeddedFile[];
extern const size_t EmbeddedFile_size;
extern const uint8_t EmbeddedFile2[];
extern const size_t EmbeddedFile2_size;
```
or put them in a header file

<br>
<br>
<br>

### Using this repo in CMake
---
```CMake
# ...

add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/Path/To/Embed2C" EXCLUDE_FROM_ALL)

include("${CMAKE_CURRENT_LIST_DIR}/Path/To/Embed2C/embedFile.cmake")

# First Get the embed executable path
set(EMBED_EXEC_PATH "")
GET_EXEC_PATH(EMBED_EXEC_PATH)

set(FILES_TO_EMBED "${CMAKE_CURRENT_LIST_DIR}/Path/To/File/To/Embed"
                    "EmbedVariableName"
                    "${CMAKE_CURRENT_LIST_DIR}/Path/To/File2/To/Embed"
                    "Embed2VariableName"
                    # etc...
                    )

EMBED_FILES("${EMBED_EXEC_PATH}"
            "${CMAKE_CURRENT_LIST_DIR}/Path/To/Output/File.c"
            "${FILES_TO_EMBED}")
#...
```

You can check if the embedded C file is populated or not with 
```CMake
file(SIZE "${CMAKE_CURRENT_LIST_DIR}/Path/To/Output/File.c" EMBEDDED_FILE_SIZE)
if(EMBEDDED_FILE_SIZE LESS 1024)
    # Pupulate it with EMBED_FILES function
endif()
```
<br><br><br>

### Credits
---

This is just a modification from https://gist.github.com/cpq/4714740
which is licensed under MIT and
created by Sergey Lyubka (cpq) https://github.com/cpq

