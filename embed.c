#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) 
{
    FILE *fp;
    int i, j, ch;
    for(i = 1; i < argc; i+=2) 
    {
        if((fp = fopen(argv[i], "rb")) == NULL)
        {
            printf("Failed to read: %s", argv[i]);
            exit(i);
        } 
        else 
        {
            if(i == 1)
            {
                printf("#include <stdint.h>\n");
            }
            
            if(i + 1 >= argc)
            {
                exit(i+1);
            }
            
            printf("const uint8_t %s[] = {", argv[i + 1]);
            
            for (j = 0; (ch = fgetc(fp)) != EOF; j++) 
            {
                if ((j % 12) == 0) 
                {
                    printf("%s", "\n    ");
                }
                printf("%#04x, ", ch);
            }
            // Append zero byte at the end, to make text files appear in memory
            // as nul-terminated strings.
            printf("%s", "0x00\n};\n");
            fclose(fp);
        }
    }    
}