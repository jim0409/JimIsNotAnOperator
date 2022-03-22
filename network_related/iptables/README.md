# intro
Linux, netfilter and iptables
1. netfilter: module for filtering packets in Linux kernel
2. iptables: user space application to manipulate packet filters of netfilter

```
userspace ; Network Applications / iptables
---             |                       |                   
kernelspace ; Linux Kernel        [netfilter]
--              |
hardware ; Network Interface Cards
```

# iptables Concepts
### Tables
- Different `tables` of filters (depend on kernel configuration)
- Selected using -t option
    - filter: default table (if no option used)
    - nat: network Network Address Translation
    - mangle: Altering packets
    - ...
- Tables contain `chains`


### Chains
Different filtering rules depending on how/ where packet processed by kernel
- INPUT: packets destined to this computer
- OUTPUT packets originating from this computer
- FORWARD packets being forwarded by this computer
- PREROUTING altering packets as they come in to this computer (e.g. nat, mangle)
- POSTROUTING altering packets as they go out of this computer (e.g. nat, mangle)

```
                                                ----------- local process ---------
                                                |                                 |
                                            INPUT chain                      OUTPUT chain
                                                |                                 |
--(incoming_packets)--> PRETOUYING chain --> routing decision --> FORWARD chain ----> POSTROUTING chain --(outgoing_packets)-->
```

### Rules
- Chains contain packet filtering `rules`
- Rules consist of:
    - Matching condition(s) desired packet characteristics
        - protocol, source/ dest. address, interface
        - many protocol specific extensions
    - Target action to take if packet matches specified conditions
        - ACCEPT, DROP, RETURN
- A packet is checked against rules in chain, from 1st to last
- If rule does not match, check against next rule in chain
- If rule matches, take action as specified by target


### (Short) Common iptables Syntax
iptables [-t `table`] [-operation `chain`] [-p `protocol`] [-s `srcip`] [-d `dstip`] 
         [-i `inif`] [-o `outif`] [-param1 `value1` ...] -j target

- table: filter, nat, mangle
- operation: (first uppercase letter) Append, Delete, Insert, List, Flush, Policy, ...
- chain: INPUT, OUTPUT, FORWARD, PREROUTING, POSTROUTING
- protocol: tcp, udp, icmp, all ...
- srcip, dstip: IP address, e.g. 1.1.1.1, 2.2.2.0/24
- inif, outif: interface name, e.g. eth0
- param, value: protocol specific parameter and value
    - sport, dport, tcp-flags, icmp-type, ...
- target: ACCEPT, DROP, RETURN

# Examples
# 1.
### AIM
Drop all ICMP packets sent by this computer

```
  [inside]      [router]    [outside]
192.168.1.11 -> firewall -> 192.168.2.21
                `FORWARD`
                ;; Default: ACCEPT
```

### Design
- Assuem default policy is `ACCEPT`
- Assume filter tables empty -> append a new rule
- Packets sent -> `OUTPUT` chain
- Protocol is `icmp`
- Target is `DROP`

### Implementation
> iptables -A FORWARD -p icmp -j DROP
iptables -L OUTPUT -v
```
root@ubuntu:/home/ubuntu# ping 127.0.0.1 -c 3
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
ping: sendmsg: Operation not permitted
ping: sendmsg: Operation not permitted
ping: sendmsg: Operation not permitted
^C
--- 127.0.0.1 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2029ms

root@ubuntu:/home/ubuntu# sudo iptables -L OUTPUT -v
Chain OUTPUT (policy ACCEPT 748 packets, 76703 bytes)
 pkts bytes target     prot opt in     out     source               destination
   11   992 DROP       icmp --  any    any     anywhere             anywhere
```

<!-- undo iptables -->
> iptables -D OUTPUT -p icmp -j DROP
```
root@ubuntu:/home/ubuntu# sudo iptables -L OUTPUT -v
Chain OUTPUT (policy ACCEPT 4 packets, 504 bytes)
 pkts bytes target     prot opt in     out     source               destination
root@ubuntu:/home/ubuntu# ping 127.0.0.1 -c 3
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.010 ms
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.034 ms
64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.034 ms
```


### 2.AIM
Allow Access Only to Web Server

Prevent others from sending to this computer, except to the local HTTP web server

### Design
- Packets received -> `INPUT` chain
- HTTP uses TCP -> protocol is `tcp`
- Web server listens on port 80 -> destination port 80
- Set the default policy to DROP
- Target is ACCEPT

### Implementation
<!-- set default as DROP -->
> iptables -P INPUT DROP
<!-- allow the target port as ACCEPT -->
> iptables -A INPUT -p tcp --dport 80 -j ACCEPT


### 3.AIM
DROP all tcp packets to port 12345

### pre-request
- server:
nc -l 12345

- client:
nc 10.0.2.15 12345

and make sure client-server and server-client can communicate each other well

### drop-cmd
> iptables -A OUTPUT -p tcp --dport 12345 -j DROP

### check 
use server/client and try to send msg to the other

> iptables -L FORWARD -v -n
```
root@ubuntu:/home/ubuntu# iptables -L OUTPUT -vn
Chain OUTPUT (policy ACCEPT 95 packets, 8726 bytes)
 pkts bytes target     prot opt in     out     source               destination
   38  2785 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:12345
```

### clear rule
> iptables -D OUTPUT -p tcp --dport 12345 -j DROP

once the rule is deleted the tcp packets would send to the other (due to tcp flow control)


### 4.AIM
Block Packets Through Router

On this router, block all packets arriving on interface eth0 and destined to subnet 2.2.2.0/24 (and then view the rules)

### Design
- Packets forwarded through routers -> FORWARD chain
- Verbose output needed to see interfaces -> -v

### Implementation
<!-- give rule -->
> iptables -A FORWARD -i eth0 -d 2.2.2.0/24 -j DROP

<!-- chek rules -->
> iptables -L FORWARD -n -n

# Notes
1. List the current set of rules, showing actual address (Numeric addresses -> -n)
> iptables -L -n
2. Delete all the previous rules (flush the rules from the default filter talbe, and reset policy to default accept)

<!-- flush -->
> iptables -F

<!-- reset -->
> iptables -P INPUT ACCEPT
<!-- check rules -->
> iptables -L

# Stateful Packet Inspection
- Traditional packet filtering firewall makes decisions based on individual packets;
don't consider past packets (stateless)
- Many applications establish a connection between client/server; group of packets belong to a connection
- Often easier to define rules for connections, rather than individual packets
- Need to store information about past behaviour (stateful)
- Stateful Packet Inspection(SPI) is extension of traditional packet filtering firewalls
- Issues: extra overhead required for maintaining state information


# refer:
- https://www.youtube.com/watch?v=5Rr4Njsajgc
- https://www.youtube.com/watch?v=wg8Hosr20yw
- https://zh.wikipedia.org/wiki/Iptables

ubuntu上運行iptables
- https://magiclen.org/ubuntu-server-iptables-save-permanently/