dnsbl-resolver-config
=====================

For those who need to directly query local or remote specialized DNSBL services, not accessible by recursive resolution

*Scroll down to read the Background section if you are not sure this applies to you*


***

BIND
---



***
FIXME add other resolver flavors here
***

Background
---

http://en.wikipedia.org/wiki/Dnsbl can explain DNSBLs and they refer to query services that supply information about
a Internet domain name as URI DNSBLs. 

Our examples are going to use domain queries such as example.com.abc123.dnsbl and we are going to use the generic 
term DNSBL instead of URI DNSBL.