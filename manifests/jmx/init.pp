define tomcatlegacy::jmx::init (
    $instance = $name) {
    include concat::setup

    concat { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/jmxremote.password":
        owner   => $instance,
        group   => $instance,
        mode    => '0600',
        require => File["${tomcatlegacy::params::home}/${instance}/tomcat/conf"],
    }

    concat { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/jmxremote.access":
        owner   => $instance,
        group   => $instance,
        mode    => '0640',
        require => File["${tomcatlegacy::params::home}/${instance}/tomcat/conf"],
    }
}
