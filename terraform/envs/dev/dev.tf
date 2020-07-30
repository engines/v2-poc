# ------------------------------------------------------------
# Let terraform know about LXD.
# ------------------------------------------------------------
provider "lxd" {
  # This works using the local unix domain socket. You MUST be in the lxd group.
  generate_client_certificates = true
  accept_remote_certificate    = true
}


locals {
  domain = "${var.datacentre}.${var.zone}"
}


provider "powerdns" {
  api_key    = var.pdns_api_key
  server_url = var.pdns_server_url
}


module "engines" {
  source      = "./modules/dns"
  zone        = local.domain
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
  zone    = local.domain
}


module "consul1" {
  source  = "./modules/turtle-container"
  name    = "consul1"
  image   = "engines/beowulf/base/20200701/0710"
  zone    = local.domain
}


module "consul2" {
  source  = "./modules/turtle-container"
  name    = "consul2"
  image   = "engines/beowulf/base/20200701/0710"
  zone    = local.domain
}


module "consul3" {
  source  = "./modules/turtle-container"
  name    = "consul3"
  image   = "engines/beowulf/base/20200701/0710"
  zone    = local.domain
}

# ------------------------------------------------------------
# postgres container
# ------------------------------------------------------------

module "postgres" {
  source  = "./modules/turtle-container"
  name    = "postgres"
  image   = "engines/beowulf/base/20200701/0249/ci"
  zone    = local.domain
}

module "rails" {
  source  = "./modules/turtle-container"
  name    = "rails"
  image   = "engines/beowulf/base/20200701/0710"
  zone    = local.domain
}

module "wap" {
  source  = "./modules/turtle-container"
  name    = "wap"
  image   = "engines/beowulf/base/20200701/0710"
  zone    = local.domain
}
