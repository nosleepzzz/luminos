/* LuminOS - System control center (Windows runner arrives in Phase 2) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void show_status(void) {
    printf("========================================================\n");
    printf("  LuminOS - System Control Center\n");
    printf("========================================================\n");
    printf("  Distro:   LuminOS Glass (pre-alpha)\n");
    printf("  Base:     CachyOS / Arch (linux-cachyos)\n");
    printf("  Desktop:  Hyprland (lean Glass profile)\n");
    printf("  Phase 1:  Lean live/install ISO profile\n");
    printf("  Phase 2:  Wine-GE / Proton .exe runner (not shipped yet)\n");
    printf("========================================================\n");
}

static int launch_win_app(const char *exe) {
    (void)exe;
    fprintf(stderr,
            "lumin-mgr: Windows application execution is not implemented yet.\n"
            "Phase 2 will wire Wine-GE/Proton + per-app prefixes.\n");
    return 1;
}

static void usage(void) {
    printf("Usage: lumin [--status | --run-exe <file.exe>]\n");
}

int main(int argc, char **argv) {
    if (argc > 1) {
        if (strcmp(argv[1], "--run-exe") == 0 || strcmp(argv[1], "run") == 0) {
            return launch_win_app(argc > 2 ? argv[2] : NULL);
        }
        if (strcmp(argv[1], "--status") == 0) {
            show_status();
            return 0;
        }
        usage();
        return 1;
    }
    show_status();
    return 0;
}
