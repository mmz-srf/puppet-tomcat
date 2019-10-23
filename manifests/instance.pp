# This resource installs a tomcat instance.
#
# === Parameters
#
# Document parameters here.
#
# [*shutdown_port*] The port the shutdown command can be issued to. Defaults to 8005.
# [*apr_enabled*]   Enable apr. Defaults to true.
# [*max_heap*]      Max heap space to use. Defaults to 1024m.
# [*min_heap*]      Min heap space to use. Defaults to 1024m.
# [*min_perm*]      Min permgen space. Defaults to 384m.
# [*max_perm*]      Max permgen space. Defaults to 384m.
# [*unpack_wars*]   Unpack wars. Defaults to true.
# [*auto_deploy*]   Auto deploy wars. Defaults to true.
#
# === Variables
#
# === Examples
#
#  tomcatlegacy::instance { 'instance_1':
#   shutdown_port => '8006',
#   apr_enabled   => true,
#   max_heap      => '2048m',
#   min_heap      => '1024m',
#   min_perm      => '384m',
#   max_perm      => '512m',
#   unpack_wars   => false,
#   auto_deploy   => true,
#  }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::instance (
    $shutdown_port     = 8005,
    $apr_enabled       = true,
    $pidfile_enabled   = true,
    $jmx_enabled       = false,
    $jmx_ip            = '127.0.0.1',
    $jmx_port          = 8050,
    $jmx_ssl           = false,
    $jmx_authenticate  = false,
    $max_heap          = '1024m',
    $min_heap          = '1024m',
    $min_perm          = '384m',
    $max_perm          = '384m',
    $java_opts         = false,
    $unpack_wars       = true,
    $auto_deploy       = true,
    $deploy_on_startup = true,
    $priority          = undef,
    $ensure            = present,
    $svc_provider      = 'base',
    $systemd_restart   = false,
    $user_id           = undef,
    $user_groups       = [],
    $version           = 8,
 ) {
    include tomcatlegacy

    $instance_home = "${tomcatlegacy::params::home}/${name}"

    tomcatlegacy::service { $name:
        ensure => $ensure ? {
            present => 'running',
            absent  => 'stopped',
            default => 'running',
        },
        provider        => $svc_provider,
        systemd_restart => $systemd_restart,
        version         => $version,
    }

    tomcatlegacy::connector::init { $name:
        ensure => $ensure,
        notify => Tomcatlegacy::Service[$name],
    }

    tomcatlegacy::listener::init { $name:
        ensure => $ensure,
        notify => Tomcatlegacy::Service[$name],
    }

    tomcatlegacy::jndi::init { $name:
        ensure => $ensure,
        notify => Tomcatlegacy::Service[$name],
    }

    tomcatlegacy::realm::init { $name:
        ensure => $ensure,
        notify => Tomcatlegacy::Service[$name],
    }

    tomcatlegacy::valve::init { $name:
        ensure => $ensure,
        notify => Tomcatlegacy::Service[$name],
    }

    tomcatlegacy::cluster::init { $name:
        ensure => $ensure,
        notify => Tomcatlegacy::Service[$name],
    }

    if (!defined(Tomcatlegacy::Connector[$name])) {
        tomcatlegacy::connector::http { $name: ensure => $ensure, }
    }

    if ($apr_enabled) {
        tomcatlegacy::listener { "${name}:org.apache.catalina.core.AprLifecycleListener":
            instance   => $name,
            class_name => 'org.apache.catalina.core.AprLifecycleListener',
            attributes => [{
                    'SSLEngine' => 'on',
                }
                ],
        }
    }

    if ($jmx_enabled and $jmx_authenticate) {
        tomcatlegacy::jmx::init { $name: }
    }

    if ($tomcatlegacy::version < 8) {
        tomcatlegacy::listener { "${name}:org.apache.catalina.core.JasperListener":
            instance   => $name,
            class_name => 'org.apache.catalina.core.JasperListener',
        }
    }

    tomcatlegacy::listener { "${name}:org.apache.catalina.core.JreMemoryLeakPreventionListener":
        instance   => $name,
        class_name => 'org.apache.catalina.core.JreMemoryLeakPreventionListener',
    }

    if ($tomcatlegacy::version < 7) {
        tomcatlegacy::listener { "${name}:org.apache.catalina.mbeans.ServerLifecycleListener":
            instance   => $name,
            class_name => 'org.apache.catalina.mbeans.ServerLifecycleListener',
        }
    }

    tomcatlegacy::listener { "${name}:org.apache.catalina.mbeans.GlobalResourcesLifecycleListener":
        instance   => $name,
        class_name => 'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener',
    }

    file { [$instance_home, "${instance_home}/tomcat", "${instance_home}/tomcat/bin", "${instance_home}/tomcat/conf",
        "${instance_home}/tomcat/conf/Catalina", "${instance_home}/tomcat/conf/Catalina/localhost", "${instance_home}/tomcat/lib",
        "${instance_home}/tomcat/logs", "${instance_home}/tomcat/temp", "${instance_home}/tomcat/webapps", "${instance_home}/tomcat/work"
        ]:
        ensure  => directory,
        owner   => $name,
        group   => $name,
        mode    => '0640',
        require => User[$name],
    }

    file { "${instance_home}/tomcat/bin/bootstrap.jar":
        ensure => link,
        target => "/usr/share/tomcat${tomcatlegacy::version}/bin/bootstrap.jar",
        notify => Tomcatlegacy::Service[$name],
    }

    # For using apparmor profiles per instance it needs a file instead of a symlink
    file { "${instance_home}/tomcat/bin/catalina.sh":
        ensure => file,
        source => "/usr/share/tomcat${tomcatlegacy::version}/bin/catalina.sh",
        owner  => 'root',
        group  => 'root',
        mode   => '755',
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/digest.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcatlegacy::version}/bin/digest.sh",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/setclasspath.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcatlegacy::version}/bin/setclasspath.sh",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/shutdown.sh":
        ensure => file, # file instead of a link so it uses the instance catalina.sh
        source => "/usr/share/tomcat${tomcatlegacy::version}/bin/shutdown.sh",
        owner  => 'root',
        group  => 'root',
        mode   => '755',
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/startup.sh":
        ensure => file, # file instead of a link so it uses the instance catalina.sh
        source => "/usr/share/tomcat${tomcatlegacy::version}/bin/startup.sh",
        owner  => 'root',
        group  => 'root',
        mode   => '755',
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/tool-wrapper.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcatlegacy::version}/bin/tool-wrapper.sh",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/version.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcatlegacy::version}/bin/version.sh",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/catalina.properties":
        ensure => link,
        target => "/etc/tomcat${tomcatlegacy::version}/catalina.properties",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/logging.properties":
        ensure => link,
        target => "/etc/tomcat${tomcatlegacy::version}/logging.properties",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/policy.d":
        ensure => link,
        target => "/etc/tomcat${tomcatlegacy::version}/policy.d",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/web.xml":
        ensure => link,
        target => "/etc/tomcat${tomcatlegacy::version}/web.xml",
        notify => Tomcatlegacy::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/setenv.sh":
        content => template('tomcatlegacy/setenv.sh.erb'),
        notify  => Tomcatlegacy::Service[$name],
        owner   => $name,
        mode    => '0740',
    }

    if $user_id {
      group { $name:
          ensure => present,
          gid    => $user_id,
      }->
      user { $name:
          ensure    => present,
          allowdupe => true,
          uid       => $user_id,
          groups    => $user_groups,
          home      => $instance_home,
          password  => '!',
          comment   => "${name} instance user",
      }
    } else {
        user { $name:
            ensure   => present,
            home     => $instance_home,
            password => '!',
            comment  => "${name} instance user",
        }
    }

    if $priority {
        $instance_file_name = "${priority}@${name}"
    } else {
        $instance_file_name = $name
    }
    file { "/etc/tomcat.d/${instance_file_name}":
        ensure  => $ensure,
        content => '',
        require => User[$name],
        notify  => Tomcatlegacy::Service[$name],
        mode    => '0640',
    }

    file { "${instance_home}/tomcat/conf/server.xml":
        ensure  => $ensure,
        owner   => $name,
        group   => $name,
        content => template('tomcatlegacy/server.xml.erb'),
        require => File["${instance_home}/tomcat"],
        notify  => Tomcatlegacy::Service[$name],
        mode    => '0640',
    }

    file { "${instance_home}/tomcat/conf/context.xml":
        ensure  => $ensure,
        owner   => $name,
        group   => $name,
        content => template('tomcatlegacy/context.xml.erb'),
        require => File["${instance_home}/tomcat"],
        notify  => Tomcatlegacy::Service[$name],
        mode    => '0640',
    }
}
