resource "container" "jbossas" {
  image {
    name = "ubuntu:22.04"
  }

  command = ["tail", "-f", "/dev/null"]

  network {
    id         = variable.network_id
    ip_address = "10.60.0.20"
    aliases    = ["jbossas"]
  }

  resources {
    cpu    = 500
    memory = 512
  }
}
