# This resource installs default realm resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::listener::init (
    $instance = $name,
    $ensure   = present,) {
    if ($ensure != absent) {
        include concat::setup

        concat { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/server-listeners.xml":
            owner   => $instance,
            group   => $instance,
            mode    => '0640',
            require => File["${tomcatlegacy::params::home}/${instance}/tomcat/conf"],
        }

        concat::fragment { "Adding Default Server Listeners topcontent for ${instance}":
            target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/server-listeners.xml",
            order   => 00,
            content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>
',
        }
    }
}
