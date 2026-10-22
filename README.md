# SUP-4381 module network repro lab (Instruqt 2.0)

Repro lab for Unthread ticket #4381 (Digital.ai, Ben Hählen, lab `deploy-102-setting-the-stage`).

Ben declares one `lab-network` module in the lab and passes its network id into two other modules with `depends_on` + `variables`. The lab fails to start with:

```
unable to convert reference module.lab-network to context variable: no cty.Type for interface {}
  modules.hcl:6  module "deploy-image-build"
  modules.hcl:16 module "jbossas-image-build"
```

This lab copies his wiring as closely as possible, so we can check whether it fails for us too before escalating to L2.

## How it matches Ben's lab

| Piece | Ben (from the thread) | This lab |
| --- | --- | --- |
| Lab module blocks | `depends_on = [module.lab-network]` + `variables = { network_id = module.lab-network.output.lab-network-id }` | Same (`modules.hcl`) |
| `lab-network` outputs | `lab-network` (whole resource) + `lab-network-id` (`.meta.id`) | Same (`modules/lab-network/outputs.hcl`) |
| Image-build modules | `variable "network_id"`, container `network { id = variable.network_id }` | Same (one ubuntu container each, IPs 10.60.0.10 / .20) |
| Module source | Registry: `digitalai/...` with `version = ">= ..."` | Local: `./modules/...`, no `version` (version isn't allowed on local sources) |
| Images | `resource "build"` images | Plain `ubuntu:22.04` (the error is raised at the module blocks, before any image is used) |

## Deploy

1. Create an empty GitHub repo and put the **contents** of this folder at the repo root (lab files must be at the root, not in a subfolder):
   ```bash
   cd sup-4381-module-network-repro
   git init && git branch -m main
   git add . && git commit -m "SUP-4381 module network repro lab"
   git remote add origin git@github.com:<you>/sup-4381-module-network-repro.git
   git push -u origin main
   ```
2. In team `instruqt-support`: **Labs → Import lab** → repo → branch `main` → folder `/` → **Import lab**.
3. Start it with **Play** in the web UI.

## Test matrix

Run variant A first. Change one thing per variant, push, let the lab sync, then start a fresh session.

| Variant | Change from A | What it isolates |
| --- | --- | --- |
| **A: exact** | none | Does Ben's wiring fail for us? |
| **B: no whole-resource output** | In `modules/lab-network/outputs.hcl`, delete the `output "lab-network"` block | Is the output holding a whole resource the problem? |
| **C: no bare depends_on** | Restore B. In `modules.hcl`, delete both `depends_on = [module.lab-network]` lines | Is the bare `module.lab-network` reference the problem? |
| **D: registry modules** | Only if A starts fine. Publish the three modules to the `instruqt-support` registry and switch `source` to `instruqt-support/<module>` with a `version` | Does it only fail with registry modules, like Ben's? |

How to read the results:

- **A fails with Ben's error, B starts:** the whole-resource output breaks a bare module reference.
- **A fails, C starts but B doesn't:** `depends_on = [module.lab-network]` itself breaks. The module docs say a bare module name is a valid dependency reference, so this is a docs-vs-runtime bug.
- **A starts:** no repro with local modules. Try D.
- **Started fine:** the page shows the two `getent hosts` checks that confirm both containers share one network.

Record each run:

| Variant | Started? | Error text (if any) | Session ID |
| --- | --- | --- | --- |
| A | | | |
| B | | | |
| C | | | |
| D | | | |

## Unrelated errors to ignore

ENG-1136: on small labs, the sandbox create can run twice in the same sandbox. If you see `container name ... is already in use` or `overlaps with the subnet`, that's ENG-1136, not this bug. Start a new session.

Lab logs: `instruqt lab logs --session <id>`, or Manage → Logs filtered by session ID.
