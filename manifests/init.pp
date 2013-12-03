#
# Class: jenkins
#
# Installs the Jenkins CI server, http://jenkins-ci.org/.
#
# Usage:
#
#   # Install and run jenkins.
#   include jenkins
#
class jenkins {

    $key_url = "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key"
    $repo_url = "deb http://pkg.jenkins-ci.org/debian binary/"
    $apt_sources = "/etc/apt/sources.list"

    exec { "install jenkins key":
        command     => "wget -q -O - ${key_url} | apt-key add -; echo '${repo_url}' >> ${apt_sources}",
        onlyif      => "test 0 -ne $(grep -Fcxq '${repo_url}' ${apt_sources})",
        path        => ["/bin", "/usr/bin"],
    }

    exec { "jenkins-apt-update":
        command => "/usr/bin/aptitude -y update",
        require => Exec["install jenkins key"],
    }

    package { "jenkins":
        ensure      => present,
        provider    => "aptitude",
        require     => Exec["jenkins-apt-update"],
    }

    service { "jenkins":
        enable      => true,
        ensure      => running,
        hasrestart  => true,
        hasstatus   => true,
        require     => Package["jenkins"],
    }

}
