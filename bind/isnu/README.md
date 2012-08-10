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
Ensure that you have a current and easily accessible back up of your 
bind configuration files. 

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
---

The instructions assume that your bind configuration has a named.conf
which you do not edit, but which has a line "include"ing named.conf.local

You can see all the includes in your config files by typing in /etc/bind something like:

```
grep include named.conf*
```

Make sure named.conf.local contains the following line, uncommented:

include "/etc/bind/YOUR-FORWARD-ONLY-ZONE-FILE-NAME";

The correct syntax for the line above is part of the output you see when 
you run the helper script.

***
BIND FAILS TO START
***

Edit named.conf.local
to comment out the include line you just added.

Commenting out typically would be done by adding two forward slashes
at the start of the line, like this:

```
// include " some bad syntax or something causing bind to fail "
```

Then issue the bind start command again.

bind is very particular about syntax in config files and will not start 
if you have one character wrong or out of place. Carefully examine your
new forward-only zone file that was created by the helper script and your 
named.conf.local include line for possible syntax erros.

***
QUERIES ARE BEING REFUSED OR TIMING OUT
***



***
CACHING NIGHTMARES
***

You don't see the query results you expect after fixing something. You become 
frustrated and try all kinds of config changes until you are exhausted and have
forgotten all the different things you changed. Still nothing works as it should.

Eventually you realize that you were reading an answer from a cache. 

Remove or add a few characters from your test point domain to avoid caching
if you are doing multiple tests after making changes.

To get a 127.0.0.2 answer, the domain does not need to exist but should end in a 
valid TLD such as .com

Domains that do exist and are more than about 24 hrs old will result in an NXDOMAIN 
answer so they do not make good test points.

***


