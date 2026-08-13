/* LuminOS - Windows installer helper (Phase 2 stub) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void print_help(void) {
    printf("========================================================\n");
    printf("  lumin-install (Phase 2 placeholder)\n");
    printf("========================================================\n");
    printf("  Usage (future): lumin-install <installer.exe> [App Name]\n");
    printf("  Status: not implemented in Phase 1 (lean Glass ISO).\n");
    printf("========================================================\n");
}

int main(int argc, char **argv) {
    (void)argv;
    if (argc < 2) {
        print_help();
        return 1;
    }

    fprintf(stderr,
            "lumin-install: Windows app install is not implemented yet.\n"
            "Phase 2 will create isolated prefixes under ~/.lumin-apps/.\n");
    return 1;
}
