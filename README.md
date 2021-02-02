# Applier Samples For RHACM

To install the applier:
```bash
git clone https://github.com/open-cluster-management/library-go.git
make build
mv bin/applier /usr/local/bin
```
## Import an existing cluster

Templates: [import-cluster](./import-cluster)
1. `cd import-cluster`
2. Create a values.yaml files like [values.yaml](./import-cluster/values.yaml)
3. `applier -d hub -values values.yaml`
4. `oc get secret -n <myClustName> <myClustName>-import -o yaml > import-secret.yaml` 
    Replace `myClusterName` by your clusrer name to retreive the import.yaml
5. log on the managedcluster
6. `applier -f managedcluster/import.yaml --values import-secret.yaml`