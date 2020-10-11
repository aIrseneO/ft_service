#! /bin/sh/

USR=ftps_user #$1
PASS=password #$2
#FTPS_ADDRESS=ftps.domain #$3

# Copy localhost server configuration file to Nginx
cp localhost /etc/nginx/sites-available/localhost

# Remove the default symbolic link to nginx welcome page
rm -f /etc/nginx/sites-enabled/default

# Create a symbolic link to activate localhost sites
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

# Create the directory for the self-signed key
mkdir -p /etc/ssl/certificates

# Create a new Self-Signed SSL Certificate by using the openssl req command
#	-newkey rsa:4096 - Creates a new certificate request and 4096 bit RSA key.
#		The default one is 2048 bits
#	-x509 - Creates a X.509 Certificate
#	-sha256 - Use 265-bit SHA (Secure Hash Algorithm)
#	-days 3650 - The number of days to certify the certificate is ten years
#	-nodes - Creates a key without a passphrase
#	-out example.crt - Specifies the filename of the certificate to create
#	-keyout example.key - Specifies the filename of the private key to create
#	-subj - For configuration
#		-C= - Country name. The two-letter ISO abbreviation
#		-ST= - State or Province name
#		-L= - Locality Name. The name of the city where you are located
#		-O= - The full name of your organization
#		-OU= - Organizational Unit
#		-CN= - The fully qualified domain name
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 365 \
            -nodes \
            -out /etc/ssl/certificates/vsftpd.crt \
            -keyout /etc/ssl/certificates/vsftpd.key \
			-subj "/C=US/ST=California/L=Fremont/O=42/OU=42_SV/CN=localhost"

# Reload Nginx server to include new changes
service nginx reload
service nginx start
service nginx status

# Start php-fpm
#/etc/init.d/php7.3-fpm start
#/etc/init.d/php7.3-fpm status

# Display latest accesses logging and errors logging to ease administration
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
