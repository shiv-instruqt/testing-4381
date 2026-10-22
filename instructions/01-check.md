# SUP-4381: shared network check

If you can read this page, the lab **started**. That means this variant did **not** reproduce Ben's error.

Ben's error, for comparison:

```
unable to convert reference module.lab-network to context variable: no cty.Type for interface {}
```

## Check that both containers share one network

In the **deploy** tab:

```bash
hostname -I
getent hosts jbossas
```

Expected: `10.60.0.10`, then `10.60.0.20  jbossas`.

In the **jbossas** tab:

```bash
hostname -I
getent hosts deploy
```

Expected: `10.60.0.20`, then `10.60.0.10  deploy`.

If both lookups resolve, the two modules are on the same network, which is what Ben is trying to build.
