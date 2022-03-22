# intro
1. yum install -y bind

2. modify named.conf
```vi /etc/named.conf
zone "test.com.tw."{
type master;
file "/var/named/test.com.tw.hosts";     
};
```

3. add extra host zonefile
```vi /var/named/test.com.tw.hosts
$ttl 38400
test.com.tw.    IN    SOA    test.com.tw.    admin.test.com.tw(
                             1271951516
                             10800
                             3600
                             604800
                             38400
)

test.com.tw.    IN    NS    test.com.tw.

www IN A 192.168.1.252
```

# refer:
- https://iammic.pixnet.net/blog/post/6416930