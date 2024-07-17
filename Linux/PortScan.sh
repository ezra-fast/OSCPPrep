# port scan the target with 1 second timeout per port
for port in $(seq 1 1000); do nc -zv -w 1 172.16.180.217 $port; done

# sweep subnet for hosts with port 445 open
for i in $(seq 1 254); do nc -zv -w 1 172.16.180.$i 445; done
