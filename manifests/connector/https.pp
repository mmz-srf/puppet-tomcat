# ==== Resource: tomcatlegacy::connector::https
#
# This resource creates a tomcat connector, see : http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
#
# === Parameters
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::connector::https (
    $ensure               	= present,
    $instance             	= $name,
    $address              	= '0.0.0.0',
    $port                 	= 8443,
    $scheme               	= 'https',
    $secure               	= true,
    $ssl_enabled          	= true,
    $ssl_certificate_file 	= '',
    $ssl_certificate_key_file 	= '',
    $uri_encoding         	= 'UTF-8',) {
    tomcatlegacy::connector { $name:
        ensure       => $ensure,
        instance     => $instance,
        port         => $port,
        uri_encoding => $uri_encoding,
        attributes   => [{
                'address' => $address
            }
            , {
                'scheme' => $scheme
            }
            , {
                'secure' => $secure
            }
            , {
                'SSLEnabled' => $ssl_enabled
            }
            , {
                'SSLCertificateFile' => $ssl_certificate_file
            }
            , {
		'SSLCertificateKeyFile' => $ssl_certificate_key_file
	    },
	]
    }
}
