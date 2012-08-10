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
MD5PATH="md5sum" # works on most Linux
#MD5PATH=/sbin/md5 # works on most Mac
# On most systems you can find the path by typing:
# which md5 or which md5sum
#
# CHANGE THE NEXT LINE to match your assigned query host
MYFQDN="abc123.isnu.us"
# EXAMPLE: MYFQDN="abc123.isnu.us"
#
# CHANGE THE NEXT LINE TO whatever you want as a zone name
MYZONENAME="isnu.us"
#
# NOTHING TO CONFIGURE BELOW HERE
# Do our part to prevent overwriting of common bind configuration files
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
# Get the current IP address for your assigned query host
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
echo "To test your forwarding zone:"
echo ""
echo "Make the new configuration active, by issuing an"
echo "rndc reload"
echo ""
echo "After that if you see: server reload successful"
echo ""
echo "dig @localhost ${MYTESTPOINT}.${MYZONENAME} A"
echo "Should return 127.0.0.2 if your forwarding zone is working"
dig @localhost ${MYTESTPOINT}.${MYZONENAME} +short A
echo ""
echo "Additional configuration is needed the first time you create"
echo "a forwarding zone. See instructions and troubleshooting tips at"
echo "https://github.com/secure411dotorg/dnsbl-resolver-config"
echo ""
echo "The line you should have in named.conf.local to enable this zone:"
echo "include \"/etc/bind/named.conf.${MYFQDN}\";"
echo ""
echo "The include lines you actually have in named.conf.local:"
grep include named.conf.local

