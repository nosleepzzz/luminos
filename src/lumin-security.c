/* LuminOS - Security audit helper (bwrap sandbox arrives in Phase 2) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void audit_security_status(void) {
    printf("========================================================\n");
    printf("  LuminOS - Security Audit\n");
    printf("========================================================\n");
    printf("  Kernel sysctl profile: iso/airootfs/etc/sysctl.d/\n");
    printf("  Bubblewrap EXE sandbox: Phase 2 (not implemented)\n");
    printf("  Firewall / AppArmor:    planned with lean Glass ISO\n");
    printf("========================================================\n");
}

static int launch_sandboxed_exe(const char *exe_path) {
    (void)exe_path;
    fprintf(stderr,
            "lumin-security: sandboxed .exe execution is not implemented yet.\n"
            "Phase 2 will use bubblewrap around Wine-GE/Proton.\n");
    return 1;
}

static void usage(void) {
    printf("Usage: lumin-security [--audit | --sandbox <app.exe>]\n");
}

int main(int argc, char **argv) {
    if (argc > 1) {
        if (strcmp(argv[1], "--sandbox") == 0) {
            return launch_sandboxed_exe(argc > 2 ? argv[2] : NULL);
        }
        if (strcmp(argv[1], "--audit") == 0) {
            audit_security_status();
            return 0;
        }
        usage();
        return 1;
    }
    audit_security_status();
    return 0;
}
