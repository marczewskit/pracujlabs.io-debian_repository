class apt_repository::server(
  $aptly_rootdir      = hiera('apt_repository::params::aptly_rootdir'),
  $repo_name          = hiera('apt_repository::params::repo_name'),
  $repo_release       = hiera('apt_repository::params::repo_release'),
  $repo_architecture  = hiera('apt_repository::params::repo_architecture'),
  $server_port        = hiera('apt_repository::params::server_port'),
  $debian_package_dir = hiera('apt_repository::params::debian_package_dir'),
) {

  validate_absolute_path($aptly_rootdir)
  validate_string($repo_name)
  validate_string($repo_release)
  validate_string($repo_architecture)
  validate_integer($server_port)
  validate_absolute_path($debian_package_dir)

  $aptly_cmd = '/usr/bin/aptly'

  file { $debian_package_dir:
    ensure => 'directory',
  }

  class { 'aptly':
    config => {
      rootDir => $aptly_rootdir,
    }
  }

  aptly::repo { $repo_name:
    distribution  => $repo_release,
    architectures => [$repo_architecture],
  }

  file { "/tmp/publish_repo.sh":
    ensure  => "present",
    source  => 'puppet:///modules/apt_repository/publish_repo.sh',
    mode    => "0755",
    require => Aptly::Repo[$repo_name],
  }

  exec { "publish ${repo_name} repo":
    command => "/tmp/publish_repo.sh ${repo_name} ${repo_architecture}",
    require => File['/tmp/publish_repo.sh'],

  }

  class { 'apache': }

  apache::vhost { 'bigdata.aptrepo':
    port    => $server_port,
    docroot => "${aptly_rootdir}/public",
    require => Package['aptly'],
  }

  file { '/usr/bin/update-apt-repository':
    replace => 'yes',
    ensure  => 'present',
    content =>
      "#!/bin/bash\n${aptly_cmd} repo add ${repo_name} ${debian_package_dir}*//*.deb\n${aptly_cmd} -skip-signing=true publish update ${repo_release}",
    mode    => '0755',
  }

  Class['apt::update'] -> Package<| |>
}