




terraform apply -auto-approve  -var-file=vars.tfvars



Classless Inter-Domain Routing (CIDR) blocks are for specifying a range to IP addresses in format of IPv4 or IPv6. For the sake of simplicity I will explain rest of this in format of IPv4 however it is applicable to IPv6.

General format for CIDR Blocks: x.y.z.t/p

x, y, z and t are numbers from 0 to 255. Basically, each represents an 8 bit binary number. That's why it is range is up to 255. Combination of this numbers becomes an IPv4 IP address that must be unique to be able to identify a specific instance.

In case of AWS, p is a number from 16 to 28. It represents the number of bits that are inherited from given IP address. For example: 10.0.0.0/16 represents an IP address in following format: 10.0.x.y where x and y are any number from 0 to 255. So, actually it represents a range of IP addresses, starting from 10.0.0.0 to 10.0.255.255.

However for each CIDR block, AWS prohibits 5 possible IP addresses. Those are the first 4 available addresses and the last available address. In this case:

10.0.0.0: Network address
10.0.0.1: Reserved for VPC router
10.0.0.2: DNS server
10.0.0.3: Reserved for future use
10.0.255.255: Network broadcast


Actually this is one of the main reasons why AWS permits numeric value of p up to /28. Because for p=30, there will be 4 available values however AWS needs 5 IP address to use. In my opinion for p=29, they might found it inefficient to occupy 5 addresses to provide 3 possible IP address.

Number of possible IP addresses can be calculated by using this formula: