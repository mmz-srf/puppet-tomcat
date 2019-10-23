# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::connector::init (
    $instance = $name,
    $ensure   = present,) {
    if ($ensure != absent) {
        include concat::setup

        concat { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/connectors.xml":
            owner   => $instance,
            group   => $instance,
            mode    => '0640',
            require => File["${tomcatlegacy::params::home}/${instance}/tomcat/conf"],
        }

        concat::fragment { "Adding Default Connector content for ${instance}":
            target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/connectors.xml",
            order   => 00,
            content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>',
        }

    }
}
