resource "lab" "sup_4381_module_network_repro" {
  title       = "SUP-4381 module network repro"
  description = "Support repro lab for ticket #4381 (Digital.ai): one shared network module passed into two modules with depends_on + variables."

  settings {
    timelimit {
      duration = "1h"
    }

    idle {
      enabled = true
      timeout = "30m"
    }
  }

  layout = resource.layout.workspace

  content {
    chapter "repro" {
      title = "SUP-4381 repro"

      page "check" {
        title     = "Check the shared network"
        reference = resource.page.check
      }
    }
  }
}
