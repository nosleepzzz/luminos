/* LuminOS - System info fetch utility */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
void print_fetch(void) {
    printf("\033[1;33m");
    printf("         /\\       \n");
    printf("        /  \\      \033[1;36mlumin\033[0m@\033[1;36mhost\033[0m\n");
    printf("       / /\\ \\     -------------------------------\n");
    printf("      / /  \\ \\    OS:        LuminOS Glass (WIP)\n");
    printf("     / / /\\ \\ \\   Note:      Full stats available on Linux\n");
    printf("    / / /  \\ \\ \\  Base:      CachyOS / Arch (planned)\n");
    printf("   /_/_/____\\_\\_\\ Flavor:    Glass (Hyprland)\n");
    printf("\033[0m\n");
}
#else
#include <sys/utsname.h>

void print_fetch(void) {
    struct utsname sys_info;
    uname(&sys_info);

    long total_mem = 0;
    long avail_mem = 0;
    FILE *memfile = fopen("/proc/meminfo", "r");
    if (memfile) {
        char mem_line[256];
        while (fgets(mem_line, sizeof(mem_line), memfile)) {
            if (sscanf(mem_line, "MemTotal: %ld kB", &total_mem) == 1) {
                continue;
            }
            if (sscanf(mem_line, "MemAvailable: %ld kB", &avail_mem) == 1) {
                continue;
            }
        }
        fclose(memfile);
    }

    long used_mb = 0;
    long total_mb = total_mem / 1024;
    if (total_mem > 0 && avail_mem >= 0) {
        used_mb = (total_mem - avail_mem) / 1024;
    }

    printf("\033[1;33m");
    printf("         /\\       \n");
    printf("        /  \\      \033[1;36mlumin\033[0m@\033[1;36mluminos\033[0m\n");
    printf("       / /\\ \\     -------------------------------\n");
    printf("      / /  \\ \\    OS:        LuminOS Glass (pre-alpha)\n");
    printf("     / / /\\ \\ \\   Kernel:    %s %s\n", sys_info.sysname, sys_info.release);
    printf("    / / /  \\ \\ \\  Base:      CachyOS / Arch\n");
    printf("   /_/_/____\\_\\_\\ Flavor:    Glass (Hyprland)\n");
    printf("\033[0m");
    if (total_mb > 0) {
        printf("                  RAM:       %ld MB / %ld MB\n\n", used_mb, total_mb);
    } else {
        printf("\n");
    }
}
#endif

int main(void) {
    print_fetch();
    return 0;
}
