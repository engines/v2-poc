# ------------------------------------------------------------
# Let terraform know about LXD.
# ------------------------------------------------------------
provider "lxd" {
  # This works using the local unix domain socket. You MUST be in the lxd group.
  generate_client_certificates = true
  accept_remote_certificate    = true
}


locals {
  domain      = "${var.datacentre}.${var.zone}"
  entrypoint  = "app.${var.datacentre}.${var.zone}"
}


provider "powerdns" {
  api_key    = var.pdns_api_key
  server_url = var.pdns_server_url
}


provider "consul" {
  address    = "[fd61:d025:74d7:f46a:216:3eff:fe0f:ec40]:8500"
  datacenter = var.datacentre
}


module "engines" {
  source      = "./modules/dns"
  zone        = local.domain
}


# ------------------------------------------------------------
# Network Services container -- bootstrap
# ------------------------------------------------------------
module "turtle-container" {
  source  = "./modules/turtle-container"
  name    = "ns"
  image   = "engines/beowulf/base/20200623/1143/ac"
  zone    = local.domain
}


# ------------------------------------------------------------
# Consul containers -- bootstrap
# ------------------------------------------------------------
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
