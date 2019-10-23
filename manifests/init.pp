# == Class: Tomcatlegacy
#
# === Parameters
#
# [*version*] The tomcat version to install, defaults to 7.
#
# === Variables
#
# === Examples
#
#  class { tomcatlegacy:
#    version  => 6
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
class tomcatlegacy ($version = $tomcatlegacy::params::version) inherits tomcatlegacy::params {

    include concat::setup

    if (versioncmp($facts['os']['distro']['release']['major'], '9') == 0 and $version == 9) {
      # Add needed user/group as it's not created automatically *sigh*
      group { 'tomcat' :
        ensure => present,
        system => true,
      } ->
      user { 'tomcat' :
        ensure => present,
        system => true,
        gid    => 'tomcat',
      }

      # Install tomcat9 from stretch-backports if needed
      package {[
          "tomcat${version}",
          'libtcnative-1',
          'liblog4j1.2-java',
          'libcommons-logging-java',
      ]:
          ensure            => installed,
          install_options   => ["-t","${::lsbdistcodename}-backports"],
          require           => User['tomcat'],
      } -> Tomcatlegacy::Instance <||>
    } else {
      package {[
          "tomcat${version}",
          'libtcnative-1',
          'liblog4j1.2-java',
          'libcommons-logging-java',
      ]:
          ensure            => installed,
      } -> Tomcatlegacy::Instance <||>
    }


    file { [$tomcatlegacy::params::root, $tomcatlegacy::params::home, '/etc/tomcat.d/',]:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    file { '/etc/init.d/tomcat':
        source => 'puppet:///modules/tomcatlegacy/tomcat',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file { '/usr/sbin/tomcat':
        ensure => link,
        target => '/etc/init.d/tomcat',
        owner  => 'root',
        group  => 'root',
    }

    service { "tomcat${version}" :
        ensure   => stopped,
        pattern  => "/var/lib/tomcat${version}",
        enable   => false,
        provider => 'systemd',
        require  => Package["tomcat${version}"],
    }

    profile_d::script { 'CATALINA_HOME.sh':
        ensure  => present,
        content => "export CATALINA_HOME=/usr/share/tomcat${version}",
    }

    profile_d::script { 'CATALINA_BASE.sh':
        ensure  => present,
        content => 'export CATALINA_BASE=$HOME/tomcat',
    }
}
