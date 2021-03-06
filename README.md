dnsbl-resolver-config
=====================

For those who need to directly query local or remote specialized DNSBL services, not accessible by recursive resolution

*Scroll down to read the Background section if you are not sure this applies to you*


***

BIND
---

My three suggested steps for BIND are:

1. Put your new forwarder definition in a completely separate file and just "include" it optionally into
the named.conf.local file

2. Have a kill switch for the DNSBL. If you follow 1. above, it is as easy as commenting out the line that
includes the named.conf.dnsblname file in named.conf.local. Restart BIND for the change to take effect.

3. A helper script to find the current IP of a host you may have been assigned to query. (This is not 
suitable for all DNSBLs as some are using round robin and other load balancing techniques. Follow the 
instructions given to you by the DNSBL you subscribed to, if different.)

The diagram included in the bind dir here:

https://raw.github.com/secure411dotorg/dnsbl-resolver-config/master/bind/dnsbl-forward-only-zone.png

outlines what is going on between a typical spam filter (in your mail server for example) and the DNSBL
service or your local copy of the DNSBL zone.

Have a look at the code snippets for examples of setting up the forward-only zone.

***
FIXME add other resolver flavors here
***

Background
---

http://en.wikipedia.org/wiki/Dnsbl can explain DNSBLs and they refer to query services that supply information about
a Internet domain name as URI DNSBLs. 

Our examples are going to use domain queries such as example.com.abc123.dnsbl and we are going to use the generic 
term DNSBL instead of URI DNSBL.

In the olden days, DNSBL services were free and you could use any recursive resolver to make your queries.

The recursive resolver likely would be the one specified in your /etc/resolv.conf and you might never have given it
much thought. The resolver might be provided by your hosting company, your ISP or you installed your own resolver 
locally on your machine such as BIND.

More recently, you might have pointed your /etc/resolv.conf to the free Google DNS servers such as 8.8.8.8, or 
OpenDNS servers. DNSBL services that stopped giving free service to anyone still have at times allowed the major 
free DNS services to use their data.

But what if you need to use a SPECIFIC DNSBL server, one that isn't accessible from whatever recursive name servers
your system is pointing to?

I've needed to do this in two typical situations. 

1. I'm rsyncing a copy of a DNSBL zone, which I want to run under rbldnsd for reasons of speed and convenience.

2. I've been assigned a special host to query a DNSBL at, and that DNSBL is firewalled off from all the public 
recursive servers.

For these situations you can configure one or more forwarders for specific "zones" such as abc123.dnsbl, and that 
forwarder can cause the queries to go to a specific resolver IP and port. This could be a local copy of rbldnsd 
or someone else's remote DNSBL query service.

1. and 2. are the situations this repo is intended to address. Hopefully more contributors will come along with 
configs and code snippets for other flavors of resolvers or improve on what I have done as a start.

