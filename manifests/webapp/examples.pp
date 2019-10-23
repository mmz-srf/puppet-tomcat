# This resource enables the tomcat examples for an instance.
#
# === Parameters
#
# Document parameters here.
#
# [*instance*]  The instance this application should be installed in (see tomcatlegacy::instance). Defaults to $name.
#
# === Variables
#
# === Examples
#
#  tomcatlegacy::webapp::examples { 'instance_1': }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::webapp::examples ($instance = $name) {
    include tomcatlegacy

    if (!defined(Package["tomcat${tomcatlegacy::version}-examples"])) {
        package { "tomcat${tomcatlegacy::version}-examples": ensure => held, }
    }

    tomcatlegacy::context { "${instance}:examples.xml":
        content  => "<Context path=\"/manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcatlegacy::version}-examples/examples\"></Context>",
        context  => 'examples',
        instance => $instance,
        require  => Tomcatlegacy::Instance[$instance],
    }
}
