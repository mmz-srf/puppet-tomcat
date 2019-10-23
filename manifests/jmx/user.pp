define tomcatlegacy::jmx::user (
    $username = $name,
    $instance,
    $password,
    $permission) {
    concat::fragment { "${instance}:jmx:${username}:password":
        target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/jmxremote.password",
        order   => 00,
        content => "${username} ${password}",
    }

    concat::fragment { "${instance}:jmx:${username}:access":
        target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/jmxremote.access",
        order   => 00,
        content => "${username} ${permission}",
    }
}
