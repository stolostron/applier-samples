# Import an existing cluster

The scriptss [hub.sh](./import-cluster/hub.sh) and [managedcluster.sh](./import-cluster/managedcluster.sh) use the [applier](https://github.com/open-cluster-management/library-go/blob/master/docs/applier.md) to apply a number of yamls on the hub and managed cluster in order to import an existing cluster.

Templates: [import-cluster](./import-cluster)

1. Make this directory your current directory
2. Modify the [values.yaml](./import-cluster/values.yaml) by setting your cluster name and your options for the different addons.
3. run `./hub.sh <clusterName>` clusterName being the name of the cluster you want to import.
4. log on the future managed cluster
5. run `./managedcluster.sh <clusterName>` clusterName being the name of the cluster you want to import.