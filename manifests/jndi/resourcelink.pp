define tomcatlegacy::jndi::resourcelink (
    $instance,
    $type                = 'context',
    $resourcelink_name   = $name,
    $resourelink_factory = '',
    $attributes          = [],) {
    concat::fragment { "Adding JNDI ResourceLink ${resourcelink_name} for ${instance}":
        target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/${type}-jndi-resourcelinks.xml",
        order   => 01,
        content => template('tomcatlegacy/jndi-resourcelinks.xml.erb'),
    }
}
