# This resource installs the tomee functionality in a tomcat instance.
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
define tomcatlegacy::webapp::tomee ($instance = $name, $version = 'LATEST') {
    include tomcatlegacy

#    tomcatlegacy::listener { "${name}:org.apache.tomee.loader.OpenEJBListener":
#        instance    => $instance,
#        class_name  => 'org.apache.tomee.loader.OpenEJBListener',
#    }
#
#    tomcatlegacy::lib::maven { "${name}:mbean-annotation-api-4.5.2.jar":
#        instance    => $instance,
#        groupid     => 'org.apache.openejb',
#        artifactid  => 'mbean-annotation-api',
#        version     => '4.5.2',
#        lib         => 'mbean-annotation-api-4.5.2.jar',
#    }
#
#    tomcatlegacy::lib::maven { "${name}:cxf-rt-databinding-jaxb-2.6.4.jar":
#        instance    => $instance,
#        groupid     => 'org.apache.cxf',
#        artifactid  => 'cxf-rt-databinding-jaxb',
#        version     => '2.6.4',
#        lib         => 'cxf-rt-databinding-jaxb-2.6.4.jar',
#    }
#
#    tomcatlegacy::lib::maven { "${name}:jaxb-impl.jar":
#        instance    => $instance,
#        groupid     => 'org.glassfish.metro',
#        artifactid  => 'webservices-osgi-aix',
#        version     => '2.3-b259',
#        lib         => 'jaxb-impl.jar',
#    }

    tomcatlegacy::webapp::maven { "${name}:tomee-plus-webapp.war":
        instance    => $instance,
        webapp      => 'tomee',
        groupid     => 'org.apache.openejb',
        artifactid  => 'tomee-plus-webapp',
        version     => $version,
    }
}
