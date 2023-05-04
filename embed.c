#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) 
{
    FILE *fp;
    int i, j, ch;

    printf("#include <stdint.h>\n");
    printf("#include <stddef.h>\n");
    
    printf("%s", "\n");

    printf("%s", "//Extern Declaration:\n");
    for(i = 1; i < argc; i+=2) 
    {
        if(i + 1 >= argc)
        {
            printf("ERROR: Missing argument %d", i + 1);
            exit(EXIT_FAILURE);
        }
        
        printf("//extern const uint8_t %s[];\n", argv[i + 1]);
        printf("//extern const size_t %s_size;\n", argv[i + 1]);
    }
    
    printf("%s", "\n");
    printf("%s", "//Embedded contents:\n");
    
    for(i = 1; i < argc; i+=2) 
    {
        if((fp = fopen(argv[i], "rb")) == NULL)
        {
            printf("ERROR: Failed to read: %s", argv[i]);
            exit(EXIT_FAILURE);
        } 
        else 
        {
            printf("const uint8_t %s[] = {", argv[i + 1]);
            
            for (j = 0; (ch = fgetc(fp)) != EOF; j++) 
            {
                if ((j % 12) == 0) 
                {
                    printf("%s", "\n    ");
                }
                printf("%#04x, ", ch);
            }
            
            //// Append zero byte at the end, to make text files appear in memory
            //// as nul-terminated strings.
            //printf("%s", "0x00\n};\n");
            printf("%s", "\n};\n");
            
            printf("const size_t %s_size = sizeof(%s);\n", argv[i + 1], argv[i + 1]);
            
            fclose(fp);
        }
    }    
}