#! /bin/sh/

USR=ftps_user #$1
PASS=password #$2
#FTPS_ADDRESS=ftps.domain #$3

# Generate Self signed certificate
sh ssl_key_crt_gen.sh vsftpd

# Backup the default config and setup the new one
mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd_backup.conf
cp /root/vsftpd.conf /etc/vsftpd/vsftpd.conf

# Create a user
echo -e "${PASS}\n${PASS}" | adduser --shell /sbin/nologin ${USR}

# Start ftps server
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
#/usr/sbin/vsftpd -opasv_address=${FTPS_ADDRESS} /etc/vsftpd/vsftpd.conf


# To acccess:	from browser	ftp://container_ip_address
#				from terminal	ftp container_ip_address
