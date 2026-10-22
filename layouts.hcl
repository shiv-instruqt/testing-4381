resource "layout" "workspace" {
  column {
    width = "40"
    instructions {}
  }

  column {
    width = "60"

    tab "deploy" {
      title  = "deploy"
      target = resource.terminal.deploy
      active = true
    }

    tab "jbossas" {
      title  = "jbossas"
      target = resource.terminal.jbossas
    }
  }
}
