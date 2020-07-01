# ------------------------------------------------------------
# Let terraform know about LXD.
# ------------------------------------------------------------
provider "lxd" {
  # This works using the local unix domain socket. You MUST be in the lxd group.
  generate_client_certificates = true
  accept_remote_certificate    = true
}


module "turtle-container" {
  source  = "./modules/turtle-container"
  name    = "ns"
  image   = "engines/beowulf/base/20200623/1143/ac"
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
