/* LuminOS - Power profile helper (lightweight Phase 1 CLI) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void apply_lumin_profile(int on_ac) {
    if (on_ac) {
        printf("[lumin-powerd] AC profile selected (advisory)\n");
        printf("  Suggested: CPU governor performance / schedutil\n");
        printf("  Note: automatic AC/BAT switching is not a daemon yet.\n");
    } else {
        printf("[lumin-powerd] Battery profile selected (advisory)\n");
        printf("  Suggested: CPU governor powersave, enable ASPM where safe\n");
        printf("  Note: automatic AC/BAT switching is not a daemon yet.\n");
    }
}

static void usage(void) {
    printf("Usage: lumin-powerd [--ac | --battery | --status]\n");
}

int main(int argc, char **argv) {
    printf("========================================================\n");
    printf("  LuminOS Power Helper (Phase 1)\n");
    printf("========================================================\n");

    if (argc > 1) {
        if (strcmp(argv[1], "--ac") == 0) {
            apply_lumin_profile(1);
            return 0;
        }
        if (strcmp(argv[1], "--battery") == 0) {
            apply_lumin_profile(0);
            return 0;
        }
        if (strcmp(argv[1], "--status") == 0) {
            printf("Mode: advisory CLI only (no background daemon yet)\n");
            return 0;
        }
        usage();
        return 1;
    }

    apply_lumin_profile(0);
    return 0;
}
