# == Class: tomcatlegacy::params
#
# This class manages Tomcat parameters.
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
class tomcatlegacy::params {
    $root       = '/opt/tomcat'
    $home       = "${root}/sites"
    $version    = 7
}