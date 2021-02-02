# Applier Samples For RHACM

To install the applier:
```bash
git clone https://github.com/open-cluster-management/library-go.git
make build
mv bin/applier /usr/local/bin
```

for more information about the applier visit [README.md](https://github.com/open-cluster-management/library-go/blob/master/docs/applier.md)

## Import an existing cluster

The scriptss [hub.sh](./import-cluster/hub.sh) and [managedcluster.sh](./import-cluster/managedcluster.sh) use the applier to apply a number of yamls on the hub and managed cluster in order to import an existing cluster.

Templates: [import-cluster](./import-cluster)

1. `cd import-cluster`
2. Create a values.yaml files like [values.yaml](./import-cluster/values.yaml) with your own cluster name to import.
3. run `./hub.sh <clusterName>` clusterName being the name of the cluster you want to import.
4. log on the managedcluster
5. run `./managedcluster.sh <clusterName>` clusterName being the name of the cluster you want to import.