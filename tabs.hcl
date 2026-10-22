# Each terminal targets a container exposed by its module's output.
resource "terminal" "deploy" {
  target            = module.deploy-image-build.output.deploy
  shell             = "/bin/bash"
  working_directory = "/root"
}

resource "terminal" "jbossas" {
  target            = module.jbossas-image-build.output.jbossas
  shell             = "/bin/bash"
  working_directory = "/root"
}
