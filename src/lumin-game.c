/* LuminOS - Gaming mode helper (opt-in; not part of lean Glass base) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void show_gaming_status(void) {
    printf("========================================================\n");
    printf("  lumin-game (planned / not enabled in Glass base)\n");
    printf("========================================================\n");
    printf("  Lean Glass ISO does not ship a gaming stack.\n");
    printf("  Future opt-in: Proton/Wine-GE, MangoHud, game mode tweaks.\n");
    printf("========================================================\n");
}

static int enable_game_mode(void) {
    fprintf(stderr,
            "lumin-game: game mode is not implemented yet.\n"
            "It will remain opt-in and out of the lean Glass base ISO.\n");
    return 1;
}

static void usage(void) {
    printf("Usage: lumin-game [--status | --enable]\n");
}

int main(int argc, char **argv) {
    if (argc > 1) {
        if (strcmp(argv[1], "--enable") == 0 || strcmp(argv[1], "on") == 0) {
            return enable_game_mode();
        }
        if (strcmp(argv[1], "--status") == 0) {
            show_gaming_status();
            return 0;
        }
        usage();
        return 1;
    }
    show_gaming_status();
    return 0;
}
