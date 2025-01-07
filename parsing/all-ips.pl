#!/usr/bin/perl -l

# this perl script takes a file as argument 1 and uses a regular expression to locate and 
# print all the IPv4 addresses contained therein.
# usage: ./all_ips.txt file.type

sub find_ip_addresses {

    open(my $file, '<', $_[0]) or die "Could not open the file: $!";               # $file is argv[1]

    my $contents = do { local $/; <$file> };

    close($file);

    my @ip_addresses = $contents =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/g;

    print join("\n", map { "[+] $_" } @ip_addresses) . "\n";

}

find_ip_addresses($ARGV[0]);

