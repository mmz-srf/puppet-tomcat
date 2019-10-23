# ==== Resource: tomcatlegacy::connector
#
# This resource creates a tomcat connector, see : http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
#
# === Parameters
#
# [*instance*]
# [*port*]
# [*uri_encoding*]
# [*attributes*]
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::connector (
    $ensure       = present,
    $instance     = $name,
    $port         = 0,
    $uri_encoding = 'UTF-8',
    $attributes   = [],) {
    if ($ensure != absent) {
        concat::fragment { "Adding ${name} Connector for ${instance}":
            target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/connectors.xml",
            order   => 01,
            content => template('tomcatlegacy/connector.xml.erb'),
        }

    }
}
