define tomcatlegacy::realm::userdatabase (
    $instance      = $name,
    $class_name    = 'org.apache.catalina.realm.UserDatabaseRealm',
    $resource_name = 'UserDatabase',
    $type          = 'engine',) {
    include concat::setup

    concat::fragment { "Adding ${type} UserDatabase Realm content for ${instance}":
        target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/${type}-realms.xml",
        order   => 01,
        content => "<Realm className=\"${class_name}\" resourceName=\"${resource_name}\" />",
    }

    if (!defined(Tomcatlegacy::Jndi::Resource["${instance}:${resource_name}"])) {
        tomcatlegacy::jndi::resource { "${instance}:${resource_name}":
            resource_name => $resource_name,
            instance      => $instance,
            type          => 'server',
            resource_type => 'org.apache.catalina.UserDatabase',
            attributes    => [{
                    'factory' => 'org.apache.catalina.users.MemoryUserDatabaseFactory'
                }
                , {
                    'conf' => 'conf/tomcat-users.xml'
                }
                ],
        }

        concat { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml":
            owner   => $instance,
            group   => $instance,
            require => File["${tomcatlegacy::params::home}/${instance}/tomcat/conf"],
        }

        concat::fragment { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml:header":
            target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
            order   => 00,
            content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>
<tomcat-users>
',
        }

        concat::fragment { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml:footer":
            target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
            order   => 03,
            content => '
</tomcat-users>',
        }
    }
}

define tomcatlegacy::realm::userdatabase::user (
    $instance,
    $password,
    $username = $name,
    $roles    = '',) {
    concat::fragment { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml:user:${username}":
        target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
        order   => 02,
        content => "<user username=\"${username}\" password=\"${password}\" roles=\"${roles}\"/>",
    }
}

define tomcatlegacy::realm::userdatabase::role (
    $instance,
    $role = $name,) {
    concat::fragment { "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml:role:${role}":
        target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
        order   => 01,
        content => "<role rolename=\"${role}\"/>",
    }
}
