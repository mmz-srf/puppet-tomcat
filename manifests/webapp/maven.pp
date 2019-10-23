# This resource installs a web application from a maven repository in an instance.
#
# === Parameters
#
# Document parameters here.
#
# [*webapp*]        The name of the application (context). Defaults to $name
# [*instance*]      The instance this application should be installed in (see tomcatlegacy::instance).
# [*groupid*]       The groupid of the application to install.
# [*artifactid*]    The artifact of the application to install.
# [*version*]       The version of the application to install.
#
# === Variables
#
# === Examples
#
#  tomcatlegacy::webapp::maven { 'ROOT':
#   instance   => 'instance_1',
#   groupid    => 'org.sonatype.nexus',
#   artifactid => 'nexus-webapp',
#   version    => '2.3.1-01',
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
define tomcatlegacy::webapp::maven (
    $webapp = "${name}.war",
    $instance,
    $groupid,
    $artifactid,
    $version,
    $repos  = []) {
    include maven
    include tomcatlegacy

    maven { "${tomcatlegacy::params::home}/${instance}/tomcat/webapps/${webapp}.war":
        groupid    => $groupid,
        artifactid => $artifactid,
        version    => $version,
        packaging  => 'war',
        repos      => $repos,
        require    => [File["${tomcatlegacy::params::home}/${instance}/tomcat/webapps"], Package['maven']],
        notify     => $notify,
    }
}
