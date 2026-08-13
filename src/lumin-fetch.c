/* LuminOS - System Info Fetch Utility in C */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/utsname.h>

void print_fetch() {
    struct utsname sys_info;
    uname(&sys_info);

    FILE *memfile = fopen("/proc/meminfo", "r");
    char mem_line[256];
    long total_mem = 0, free_mem = 0;
    if (memfile) {
        while (fgets(mem_line, sizeof(mem_line), memfile)) {
            if (sscanf(mem_line, "MemTotal: %ld kB", &total_mem) == 1) {}
            if (sscanf(mem_line, "MemAvailable: %ld kB", &free_mem) == 1) {}
        }
        fclose(memfile);
    }

    printf("\033[1;33m");
    printf("         /\\       \n");
    printf("        /  \\      \033[1;36mlumin\033[0m@\033[1;36mlumin-pc\033[0m\n");
    printf("       / /\\ \\     -------------------------------\n");
    printf("      / /  \\ \\    OS:        LuminOS v1.0 (Windows Killer)\n");
    printf("     / / /\\ \\ \\   Kernel:    %s %s\n", sys_info.sysname, sys_info.release);
    printf("    / / /  \\ \\ \\  Idle RAM:  ~280 MB - 420 MB (Ultra-Light Footprint)\n");
    printf("   /_/_/____\\_\\_\\ ZRAM:      ZSTD 2.5x Compression Enabled\n");
    printf("                  Target:    Universal (Desktops, Laptops, Low-Spec PCs, Handhelds)\n");
    printf("                  Scheduler: BORE + eBPF scx_lavd\n");
    printf("\033[0m");
    printf("                  RAM Usage: %ld MB / %ld MB\n\n", (total_mem - free_mem)/1024, total_mem/1024);
}

int main() {
    print_fetch();
    return 0;
}
