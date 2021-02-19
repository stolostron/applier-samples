# Import an existing cluster

The scriptss [hub.sh](./hub.sh) and [managedcluster.sh](./managedcluster.sh) use the [applier](https://github.com/open-cluster-management/library-go/blob/master/docs/applier.md) to apply a number of yamls on the hub and managed cluster in order to import an existing cluster.

1. Make this directory your current directory
2. Create a values.yaml based on [values-template.yaml](./values-template.yaml) by setting your cluster name and your options for the different addons.
3. run `./hub.sh`
4. if not auto-import then log on the future managed cluster
5. run `./managedcluster.sh`

# hub.sh options

```
hub.sh [-i values.yaml] [-o output-file] [-d] [-v [0-99]]
-i: the path to the values.yaml, default values.yaml
-o: output-file: generate an output-file instead of applying
-d: When set the managed-cluster will be removed
-v: verbose level
-h: this help
```

# managedcluster.sh options

```
hub.sh [-i values-file] [-o output-file] [-d] [-v [0-99]]
-i: the path to the values.yaml, default values.yaml
-o: output-file: generate an output-file instead of applying
-v: verbose level
-h: this help
```