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

# ------------------------------------------------------------
# Postgresql container
# ------------------------------------------------------------
resource "lxd_container" "postgres" {
  name      = "postgres"
  image     = "engines/beowulf/base/20200701/0249/ci"
  ephemeral = false

  device {
    name        = "root"
    type        = "disk"

    properties  = {
      "path" = "/"
      "pool" = "default"
    }
  }

  config = {
    "boot.autostart" = true
  }

  # This only exists because the host name is not in DNS so
  # it doesn't know who it is which breaks propellor.
  provisioner "file" {
    content     = "127.0.1.1\t${self.name}.${local.domain} ${self.name}\n127.0.0.1\tlocalhost\n\n::1\tlocalhost\nff02::1\tip6-allnodes\nff02::2i\tip6-allrouters"
    destination = "/etc/hosts"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Copy propellor over to the container
  provisioner "file" {
    source      = "/tmp/propellor-config"
    destination = "/tmp/propellor-config"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Run propellor.
  provisioner "remote-exec" {
    inline = [ "/lib64/ld-linux-x86-64.so.2 /tmp/propellor-config" ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }
}



# ------------------------------------------------------------

resource "consul_node" "postgres_consul_node" {
  name    = lxd_container.postgres.name
  address = lxd_container.postgres.ipv6_address
}

resource "consul_service" "postgres_consul_service" {
  name = "database"
  node = consul_node.postgres_consul_node.name
  port = 5432
}


# ------------------------------------------------------------
# Application containers
# ------------------------------------------------------------
resource "lxd_container" "app0" {
  name      = "app0"
  image     = "engines/beowulf/base/20200701/0710"
  ephemeral = false

  device {
    name        = "root"
    type        = "disk"

    properties  = {
      "path" = "/"
      "pool" = "default"
    }
  }

  config = {
    "boot.autostart" = true
  }

  # This only exists because the host name is not in DNS so
  # it doesn't know who it is which breaks propellor.
  provisioner "file" {
    content     = "127.0.1.1\t${self.name}.${local.domain} ${self.name}\n127.0.0.1\tlocalhost\n\n::1\tlocalhost\nff02::1\tip6-allnodes\nff02::2i\tip6-allrouters"
    destination = "/etc/hosts"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Copy propellor over to the container
  provisioner "file" {
    source      = "/tmp/propellor-config"
    destination = "/tmp/propellor-config"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Run propellor.
  provisioner "remote-exec" {
    inline = [ "/lib64/ld-linux-x86-64.so.2 /tmp/propellor-config" ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }
}

resource "lxd_container" "app1" {
  name      = "app1"
  image     = "engines/beowulf/base/20200701/0710"
  ephemeral = false

  device {
    name        = "root"
    type        = "disk"

    properties  = {
      "path" = "/"
      "pool" = "default"
    }
  }

  config = {
    "boot.autostart" = true
  }

  # This only exists because the host name is not in DNS so
  # it doesn't know who it is which breaks propellor.
  provisioner "file" {
    content     = "127.0.1.1\t${self.name}.${local.domain} ${self.name}\n127.0.0.1\tlocalhost\n\n::1\tlocalhost\nff02::1\tip6-allnodes\nff02::2i\tip6-allrouters"
    destination = "/etc/hosts"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Copy propellor over to the container
  provisioner "file" {
    source      = "/tmp/propellor-config"
    destination = "/tmp/propellor-config"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Run propellor.
  provisioner "remote-exec" {
    inline = [ "/lib64/ld-linux-x86-64.so.2 /tmp/propellor-config" ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }
}

resource "lxd_container" "app2" {
  name      = "app2"
  image     = "engines/beowulf/base/20200701/0710"
  ephemeral = false

  device {
    name        = "root"
    type        = "disk"

    properties  = {
      "path" = "/"
      "pool" = "default"
    }
  }

  config = {
    "boot.autostart" = true
  }

  # This only exists because the host name is not in DNS so
  # it doesn't know who it is which breaks propellor.
  provisioner "file" {
    content     = "127.0.1.1\t${self.name}.${local.domain} ${self.name}\n127.0.0.1\tlocalhost\n\n::1\tlocalhost\nff02::1\tip6-allnodes\nff02::2i\tip6-allrouters"
    destination = "/etc/hosts"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Copy propellor over to the container
  provisioner "file" {
    source      = "/tmp/propellor-config"
    destination = "/tmp/propellor-config"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Run propellor.
  provisioner "remote-exec" {
    inline = [ "/lib64/ld-linux-x86-64.so.2 /tmp/propellor-config" ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }
}


resource "consul_key_prefix" "wap" {
  datacenter  = var.datacentre
  path_prefix = "traefik/"
  subkeys     = {
    "http/routers/app/entrypoints/0"                = "web"
    "http/routers/app/service"                      = "app"
    "http/routers/app/rule"                         = "Host(`${local.entrypoint}`)"
    "http/services/app/loadbalancer/servers/0/url"  = "http://${lxd_container.app0.name}.${local.domain}:3000/"
    "http/services/app/loadbalancer/servers/1/url"  = "http://${lxd_container.app1.name}.${local.domain}:3000/"
    "http/services/app/loadbalancer/servers/2/url"  = "http://${lxd_container.app2.name}.${local.domain}:3000/"
  }
}


# ------------------------------------------------------------
# Reverse HTTP Proxy container
# ------------------------------------------------------------
resource "lxd_container" "wap" {
  name      = "wap"
  image     = "engines/beowulf/base/20200701/0710"
  ephemeral = false

  device {
    name        = "root"
    type        = "disk"

    properties  = {
      "path" = "/"
      "pool" = "default"
    }
  }

  config = {
    "boot.autostart" = true
  }

  # This only exists because the host name is not in DNS so
  # it doesn't know who it is which breaks propellor.
  provisioner "file" {
    content     = "127.0.1.1\t${self.name}.${local.domain} ${self.name}\n127.0.0.1\tlocalhost\n\n::1\tlocalhost\nff02::1\tip6-allnodes\nff02::2i\tip6-allrouters"
    destination = "/etc/hosts"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Copy propellor over to the container
  provisioner "file" {
    source      = "/tmp/propellor-config"
    destination = "/tmp/propellor-config"

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }

  # Run propellor.
  provisioner "remote-exec" {
    inline = [ "/lib64/ld-linux-x86-64.so.2 /tmp/propellor-config" ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = self.ipv6_address
    }
  }
}


# ------------------------------------------------------------
# Application DNS entry
# ------------------------------------------------------------
resource "powerdns_record" "app" {
  zone    = local.domain
  name    = "${local.entrypoint}."
  type    = "AAAA"
  ttl     = var.dns_ttl
  records = ["${lxd_container.wap.ipv6_address}"]
}
