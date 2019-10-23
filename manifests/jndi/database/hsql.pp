define tomcatlegacy::jndi::database::hsql (
    $instance,
    $resource_name = 'jdbc/HsqlPool',
    $url           = 'jdbc:hsqldb:data',
    $max_active    = '8',
    $max_idle      = '4',
) {
    tomcatlegacy::jndi::resource { "${instance}:${resource_name}":
        instance      => $instance,
        resource_name => $resource_name,
        attributes    => [
            {'auth'              => 'Container' },
            {'username'          => 'sa' },
            {'password'          => '' },
            {'driverClassName'   => 'org.hsqldb.jdbcDriver' },
            {'url'               => $url },
            {'max_active'        => $max_active },
            {'max_idle'          => $max_idle },
        ],
    }

    tomcatlegacy::lib::maven { "${instance}:hsqldb-2.2.9":
        lib        => 'hsqldb-2.2.9.jar',
        instance   => $instance,
        groupid    => 'org.hsqldb',
        artifactid => 'hsqldb',
        version    => '2.2.9',
    }
}
