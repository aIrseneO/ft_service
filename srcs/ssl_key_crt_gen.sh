#! /bin/sh/
#
# Usage: sh ssl_key_crt_gen.sh [options]
#	options:
#		-n, --name: key and certificate name to be created
#		-i, --ip: ip address or domain name
#		-d, --dir: directory where to save key and certif
#
# Set the default values
NAME=cert
IP=localhost
DIR=/etc/ssl/certificates
#
# Extract the arguments if any
for i in "$@"
	do
	case $i in
		-n=*|--name=*)
			NAME="${i#*=}"
		;;
		-i=*|--ip=*)
			IP="${i#*=}"
		;;
		-d=*|--dir=*)
			DIR="${i#*=}"
		;;
		-h|--help)
			echo Usage: sh ssl_key_crt_gen.sh [option=...]
			echo options: 
			echo -n, --name: key and certificate name to be created
			echo -i, --ip: ip address or domain name
			echo -d, --dir: directory where to save key and certificate
			exit
		;;
		*)
			echo Error, Check help
			exit
		;;
	esac
done
#
# Create the directory for the self-signed key
mkdir -p $DIR
#
#Create the configuration file
cat << EOF > openssl.conf
[ req ]
distinguished_name = req_distinguished_name
x509_extensions     = req_ext
default_md         = sha256
prompt             = no
encrypt_key        = no

[ req_distinguished_name ]
countryName            = "US"
localityName           = "California"
organizationName       = "42"
organizationalUnitName = "SV"
commonName             = "$IP"
emailAddress           = "ft_service@project.42.us.org"

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS = "$IP"
EOF
#
# Create a new Self-Signed SSL Certificate, use the openssl req command
#
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
            -days 365 \
            -out $DIR/$NAME.crt \
            -keyout $DIR/$NAME.key \
			-config openssl.conf
#			--subj "/C=US/ST=California/L=Fremont/O=42/OU=SV/CN=$IP"
#
# Make the key and the certificate readable by all users
chmod +r $DIR/$NAME.crt $DIR/$NAME.key
#
# Remove the config file
rm -f openssl.conf
