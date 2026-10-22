module "lab-network" {
  source = "./modules/lab-network"
}

module "deploy-image-build" {
  source = "./modules/deploy-image-build"

  depends_on = [module.lab-network]
  variables = {
    network_id = module.lab-network.output.lab-network-id
  }
}

module "jbossas-image-build" {
  source = "./modules/jbossas-image-build"

  depends_on = [module.lab-network]
  variables = {
    network_id = module.lab-network.output.lab-network-id
  }
}
