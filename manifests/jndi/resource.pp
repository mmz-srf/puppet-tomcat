define tomcatlegacy::jndi::resource (
    $resource_name,
    $instance,
    $type          = 'context',
    $resource_type = 'javax.sql.DataSource',
    $attributes    = [],
) {
    concat::fragment { "Adding JNDI Resource ${resource_name} for ${instance}":
        target  => "${tomcatlegacy::params::home}/${instance}/tomcat/conf/${type}-jndi-resources.xml",
        order   => 01,
        content => template('tomcatlegacy/jndi-resources.xml.erb'),
    }
}
