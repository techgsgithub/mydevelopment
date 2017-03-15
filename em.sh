#echo print 1 for i= i+1 {
# for diskimage=bs 104104768
# changing the header 
# .keep secrets
#Recommended minimum configuration:
#acl manager proto cache_object
#acl localhost src 127.0.0.1/32
#acl to_localhost dst 127.0.0.0/8
#acl localnet src 0.0.0.0/8 192.168.100.0/24 192.168.101.0/24
#acl SSL_ports port 443
#acl Safe_ports port 80  	# http
#acl Safe_ports port 21		# ftp
#acl Safe_ports port 443		# https
#acl Safe_ports port 70		# gopher
#acl Safe_ports port 210		# wais
# acl Safe_ports port 1025-65535	# unregistered ports
# acl Safe_ports port 280		# http-mgmt
# acl Safe_ports port 488		# gss-http
# acl Safe_ports port 591		# filemaker
# acl Safe_ports port 777		# multiling http

# acl CONNECT method CONNECT

# http_access allow manager localhost
# http_access deny manager
# http_access deny !Safe_ports

# http_access deny to_localhost
#  icp_access deny all
#  htcp_access deny all

# http_port 3128
#hierarchy_stoplist cgi-bin ?
#access_log /var/log/squid3/access.log squid


#Suggested default:
#refresh_pattern ^ftp:		1440	20%	10080
#refresh_pattern ^gopher:	1440	0%	1440
#refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
#refresh_pattern .		0	20%	4320
# Leave coredumps in the first cache dir
#coredump_dir /var/spool/squid3

# Allow all machines to all sites
#http_access allow all 
qemu-img convert -f qcow2 -O vdi 101-disk-1.qcow2 xxx.vdi
# 
# acl CONNECT method CONNECT

# http_access allow manager localhost
# http_access deny manager
# http_access deny !Safe_ports

# http_access deny to_localhost
#  icp_access deny all
#  htcp_access deny all

# http_port 3128
#hierarchy_stoplist cgi-bin ?
#access_log /var/log/squid3/access.log squid


#Suggested default:
#refresh_pattern ^ftp:		1440	20%	10080
#refresh_pattern ^gopher:	1440	0%	1440
#refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
#refresh_pattern .		0	20%	4320
# Leave coredumps in the first cache dir
#coredump_dir /var/spool/squid3

