#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <file>\n", argv[0]);
        printf("Count words in a text file\n");
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("fopen");
        return 1;
    }

    int words = 0;
    int in_word = 0;
    int c;

    while ((c = fgetc(fp)) != EOF) {
        if (isspace(c)) {
            in_word = 0;
        } else {
            if (!in_word) {
                words++;
            }
            in_word = 1;
        }
    }

    fclose(fp);
    printf("Word count: %d\n", words);
    return 0;
}
