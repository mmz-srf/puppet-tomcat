# This resource enables the tomcat docs for an instance.
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
#  tomcatlegacy::webapp::docs { 'instance_1': }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcatlegacy::webapp::docs ($instance = $name) {
    include tomcatlegacy

    if (!defined(Package["tomcat${tomcatlegacy::version}-docs"])) {
        package { "tomcat${tomcatlegacy::version}-docs": ensure => held, }
    }

    tomcatlegacy::context { "${instance}:docs.xml":
        content  => "<Context path=\"/manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcatlegacy::version}-docs/docs\"></Context>",
        context  => 'docs',
        instance => $instance,
        require  => Tomcatlegacy::Instance[$instance],
    }
}
