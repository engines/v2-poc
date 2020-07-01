#IPv6

I've set a local IPv6 network up because, well it's 2020 and we actually ran
out of IPv4 addresses years ago.

I generated this using: [UltraTools Range Generator](https://www.ultratools.com/tools/rangeGeneratorResult?globalId=&subnetId=&as_sfid=AAAAAAW8OW0H-MZrcmotWNwt3vgEnkqqI6AVsSBjGtMPqjq-ujFV7g9aGJpegXQIzF9ImjgAc3jOINgombthgq6eqlfP6X98ZTsISO2qQ9jd7eapPCTvdB5NkEoPQWoGBnYaI0M%3D&as_fid=5f870f4c59e6f7b9f42e9a4b6662a8a1f545e4ce) which results in this:

```
      Prefix/L:  fd
     Global ID:  61d02574d7
     Subnet ID:  f46a
   Combine/CID:  fd61:d025:74d7:f46a::/64
IPv6 addresses:  fd61:d025:74d7:f46a::/64:XXXX:XXXX:XXXX:XXXX
   Start Range:  fd61:d025:74d7:f46a:0:0:0:0
     End Range:  fd61:d025:74d7:f46a:ffff:ffff:ffff:ffff
  No. of hosts:  18446744073709551616
```

and a radvd config (`/etc/radvd.conf`) that looks like this:

```
interface eth0 {
  AdvSendAdvert on;
  MinRtrAdvInterval 3;
  MaxRtrAdvInterval 30;
  prefix fd61:d025:74d7:f46a::/64
  {
    AdvOnLink on;
    AdvAutonomous on;
  };

  RDNSS fd61:d025:74d7:f46a::ffff
  {
    AdvRDNSSLifetime 30;
  };

  DNSSL int.engines.org
  {
    AdvDNSSLLifetime 30;
  };
};
```

You will also need to enable IPv6 forwarding:

```bash
echo "net.ipv6.conf.all.forwarding=1" > /etc/sysctl.d/ipv6.conf
sysctl -p /etc/sysctl.d/ipv6.conf
```

This enables IPv6 forwarding on all interfaces. This may or may not be what you want.


#IPv4

It appears that the Terraform LXD plugin doesn't support IPv6 only
installations plus I'm the only person who has IPv6 so I've installed
dnsmasq to provide DHCPv4.

The dnsmasq config is (`/etc/dnsmasq.conf`):

```
domain-needed
bogus-priv
no-resolv
filterwin2k
expand-hosts

domain=int.engines.org
local=/int.engines.org/

listen-address=127.0.0.1
listen-address=192.168.134.2

server=208.67.222.222
server=208.67.220.220

dhcp-option=option:router,192.168.134.1

# DHCP range
dhcp-range=192.168.134.10,192.168.134.80,1h
dhcp-lease-max=25
```
