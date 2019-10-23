# This resource enables the tomcat manager and host-manager for an instance.
#
# === Parameters
#
# [*instance*]  The instance this application should be installed in (see tomcatlegacy::instance). Defaults to $name.
#
# === Variables
#
# === Examples
#
#  tomcatlegacy::webapp::manager { 'instance_1': }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::webapp::manager ($instance = $name) {
    include tomcatlegacy

    if (!defined(Package["tomcat${tomcatlegacy::version}-admin"])) {
        package { "tomcat${tomcatlegacy::version}-admin": ensure => held, }
    }

    tomcatlegacy::context { "${name} manager.xml":
        content  => "<Context path=\"/manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcatlegacy::version}-admin/manager\"></Context>",
        context  => 'manager',
        instance => $instance,
        require  => Package["tomcat${tomcatlegacy::version}-admin"],
    }

    tomcatlegacy::context { "${name} host-manager.xml":
        content  => "<Context path=\"/host-manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcatlegacy::version}-admin/host-manager\"></Context>",
        context  => 'host-manager',
        instance => $instance,
        require  => Package["tomcat${tomcatlegacy::version}-admin"],
    }
}
