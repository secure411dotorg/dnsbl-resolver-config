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
# CHANGE THE NEXT LINE to match your assigned query host
MYFQDN="abc123.fastflux.org"
# EXAMPLE: MYFQDN="abc123.fastflux.org"
#
# CHANGE THE NEXT LINE to whatever you want as a zone name
MYZONENAME="fastflux.org"
#
# CHANGE THE NEXT LINE to a current fastfluxing domain name
MYTESTPOINT="example.com"
# You can obtain a fresh fastfluxing domain name from https://service.dissectcyber.com 
#
# NOTHING TO CONFIGURE BELOW HERE
# Do our part to prevent overwriting of common bind configuration files
if [ -z "${MYFQDN}" ];then
	echo "MYFQDN cannot be blank"
	echo "Edit this script to set MYFQDN=your-assigned-host.fastflux.org"
	exit 1
fi
if [ "${MYFQDN}" = "options" ];then
        echo "MYFQDN variable is not allowed to have the value 'options'"
        echo "Edit this script to set MYFQDN=your-assigned-host.fastflux.org"
        exit 1
fi
if [ "${MYFQDN}" = "local" ];then
        echo "MYFQDN variable is not allowed to have the value 'local'"
        echo "Edit this script to set MYFQDN=your-assigned-host.fastflux.org"
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
# RENAME THE TEMP FILE, OVERWRITING ANY FILE CALLED named.conf.[your fastflux fqdn]
mv named.conf.${MYFQDN}.tmp named.conf.${MYFQDN}
#
echo "To test your connection to the query server:"
echo "dig @${MYFQDN} ${MYTESTPOINT} A"
echo "Should return 127.0.0.2 if you can reach the query server"
# Run the test query
dig @${MYFQDN} ${MYTESTPOINT} +short A
echo "For reference, the Mannheim score of $MYTESTPOINT is:"
dig @${MYFQDN} ${MYTESTPOINT} +short TXT
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

