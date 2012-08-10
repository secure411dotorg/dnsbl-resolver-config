#!/bin/bash
# PURPOSE: A helper script for writing
# an example forwarder zone for a
# specialized DNSBL query service
# May be used after initial sign up
# or when your assigned host FQDN
# has changed.
#
# change directory to the location of your named.conf.local
cd /etc/bind
#
# CHANGE NEXT LINE to path/executable for your md5 program
# On most systems you can find the path by typing:
# which md5 or which md5sum
MD5PATH="md5sum" # works on most Linux
#MD5PATH=/sbin/md5 # works on most Mac
#
# CHANGE THE NEXT LINE to match your assigned query host
# EXAMPLE: MYFQDN="abc123.isnu.us"
MYFQDN="abc123.isnu.us"
# CHANGE THE NEXT LINE TO whatever you want as a zone name
MYZONENAME="isnu.us"
#
# NOTHING TO CONFIGURE BELOW HERE
if [ -z "${MYFQDN}" ];then
	echo "MYFQDN cannot be blank"
	echo "Edit this script to set MYFQDN=your-assigned-host.isnu.us"
	exit 1
fi
if [ "${MYFQDN}" = "options" ];then
        echo "MYFQDN variable is not allowed to have the value 'options'"
        echo "Edit this script to set MYFQDN=your-assigned-host.isnu.us"
        exit 1
fi
if [ "${MYFQDN}" = "local" ];then
        echo "MYFQDN variable is not allowed to have the value 'local'"
        echo "Edit this script to set MYFQDN=your-assigned-host.isnu.us"
        exit 1
fi
#
ARECORD=`dig +short ${MYFQDN} A|head -n1`
#
# DELETE ANY PREVIOUS TEMP FILE NAMED THE SAME
rm -f named.conf.${MYFQDN}.tmp
#
# APPEND LINES TO A TEMPORARY FILE
echo "zone \"${MYZONENAME}\" {" >> named.conf.${MYFQDN}.tmp
echo "        type forward;" >> named.conf.${MYFQDN}.tmp
echo "        forward only;" >> named.conf.${MYFQDN}.tmp
echo "        forwarders { ${ARECORD}; };" >> named.conf.${MYFQDN}.tmp
echo "};" >> named.conf.${MYFQDN}.tmp
#
# RENAME THE TEMP FILE, OVERWRITING ANY FILE CALLED named.conf.[your isnu fqdn]
mv named.conf.${MYFQDN}.tmp named.conf.${MYFQDN}
#
# CREATE AN INTERNET DOMAIN NAME FOR TESTING
# THE DOMAIN NAME WE CREATE SHOULD NOT EXIST
MYFQDNMD5=`echo "${MYFQDN}"|${MD5PATH}|sed 's/ //g'`
echo "MYFQDNMD5 is $MYFQDNMD5"
MYTESTPOINT="${MYFQDNMD5}-isnu-test-point.com"
#
echo "To test your connection to the query server:"
echo "dig @${MYFQDN} ${MYTESTPOINT} A"
echo "Should return 127.0.0.2 if you can reach the query server"
# Run the test query
dig @${MYFQDN} ${MYTESTPOINT} +short A
#
echo "To test the forwarding zone you just created:"
echo ""
echo "Make sure named.conf.local contains the following line, uncommented:"
echo ""
echo "include \"/etc/bind/named.conf.${MYFQDN}\";"
echo ""
echo "Restart bind, such as sudo /etc/init.d/bind9 restart on Ubuntu"
echo ""
echo "If bind fails to start, edit named.conf.local" 
echo "to comment out the include line you just added." 
echo "Then issue the bind start command again"
echo ""
echo "If bind started OK with the include, test the forwarding zone:"
echo ""
echo "To make the new configuration active, issue an"
echo "rndc reload"
echo ""
echo "After that if you see: server reload successful"
echo ""
echo "dig @localhost ${MYTESTPOINT}.${MYZONENAME} A"
echo "Should return 127.0.0.2 if your forwarding zone is working"
dig @localhost ${MYTESTPOINT}.${MYZONENAME} +short A
echo ""
echo "Remove or add a few characters from your test point domain to avoid caching"
echo "if you are doing multiple tests after making changes"
echo ""
