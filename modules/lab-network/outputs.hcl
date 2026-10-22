output "lab-network" {
  description = "Network used by the labs"
  value = resource.network.lab
}

output "lab-network-id" {
  description = "Network ID"
  value = resource.network.lab.meta.id
}
