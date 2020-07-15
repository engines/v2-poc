# ------------------------------------------------------------
# Let terraform know about LXD.
# ------------------------------------------------------------
provider "lxd" {
  # This works using the local unix domain socket. You MUST be in the lxd group.
  generate_client_certificates = true
  accept_remote_certificate    = true
}


provider "consul" {
  address    = "[fd61:d025:74d7:f46a:216:3eff:fe0f:ec40]:8500"
  datacenter = "dh"
}

resource "consul_key_prefix" "myapp_config" {
  datacenter = "dh"

  # Prefix to add to prepend to all of the subkey names below.
  path_prefix = "clientid/config/"

  subkeys = {
    "database/hostname" = "postgres.clientid.engines.org"
    "database/port"     = 5432
    "database/username" = "foo"
    "database/name"     = "bar"
  }

  subkey {
    path  = "database/password"
    value = "bob"
    flags = 2
  }
}


module "turtle-container" {
  source  = "./modules/turtle-container"
  name    = "ns"
  image   = "engines/beowulf/base/20200623/1143/ac"
}


module "consul1" {
  source  = "./modules/turtle-container"
  name    = "consul1"
  image   = "engines/beowulf/base/20200701/0710"
}


module "consul2" {
  source  = "./modules/turtle-container"
  name    = "consul2"
  image   = "engines/beowulf/base/20200701/0710"
}


module "consul3" {
  source  = "./modules/turtle-container"
  name    = "consul3"
  image   = "engines/beowulf/base/20200701/0710"
}

# ------------------------------------------------------------
# postgres container
# ------------------------------------------------------------

module "postgres" {
  source  = "./modules/turtle-container"
  name    = "postgres"
  image   = "engines/beowulf/base/20200701/0249/ci"
}

module "rails" {
  source  = "./modules/turtle-container"
  name    = "rails"
  image   = "engines/beowulf/base/20200701/0710"
}

module "wap" {
  source  = "./modules/turtle-container"
  name    = "wap"
  image   = "engines/beowulf/base/20200701/0710"
}
