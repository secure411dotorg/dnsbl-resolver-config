Purpose
---
The helper script 
 - writes the forward-only zone file
 - runs a test query
 - suggests syntax of config files

Typical use of the helper script is during first time setup 
of a new forward-only zone.

The helper script would also be used to fix or troubleshoot after 
the IP of your assigned query host has changed or 
your assigned host name has changed.

***

First time configuration
---
Place the helper script into your bind config directory, such as /etc/bind

```
vi overwrite-isnu-fwdr-zone.sh
```

and look for the comments that tell you to CHANGE THE NEXT LINE ... 

Save and execute the helper script. Do not expect all the tests to work yet.

From the output of the script, copy the "include" line similar to this:

```
include "/etc/bind/named.conf.abc123.isnu.us";
```

and insert that as a new line in your /etc/bind/named.conf.local file.

Restart bind, such as on Ubuntu /etc/init.d/bind9 restart

Here's how it would look to restart bind if everything went well:

```
/etc/init.d/bind9 restart
 * Stopping domain name service... bind9
waiting for pid 9391 to die
   ...done.
 * Starting domain name service... bind9
   ...done.
```

***

Testing
---

Run the helper script again to see the tests execute
or just copy and paste the dig test lines and run manually.

***

Troubleshooting & Tips
***


