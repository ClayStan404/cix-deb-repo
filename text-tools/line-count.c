#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <file>\n", argv[0]);
        printf("Count lines in a text file\n");
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("fopen");
        return 1;
    }

    int lines = 0;
    int c;

    while ((c = fgetc(fp)) != EOF) {
        if (c == '\n') {
            lines++;
        }
    }

    fclose(fp);
    printf("Line count: %d\n", lines);
    return 0;
}
