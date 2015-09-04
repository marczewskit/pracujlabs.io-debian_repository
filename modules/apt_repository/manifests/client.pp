class apt_repository::client (
  $repo_release            = hiera('apt_repository::params::repo_release'),
  $repo_architecture       = hiera('apt_repository::params::repo_architecture'),
  $server_port             = hiera('apt_repository::params::server_port'),
  $server_address          = hiera('apt_repository::params::server_address'),
) {

  validate_string($repo_release)
  validate_string($repo_architecture)
  validate_ipv4_address($server_address)
  validate_integer($server_port)




  host { 'apt-repository-server':
    ip => $server_address,
  }

  apt::source { 'atplyrepo':
    location       => "http://apt-repository-server:${server_port}/",
    architecture   => $repo_architecture,
    release        => $repo_release,
    repos          => 'main',
    allow_unsigned => true,
    require        => Host['apt-repository-server'],
  }

}