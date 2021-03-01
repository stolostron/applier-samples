[comment]: # ( Copyright Contributors to the Open Cluster Management project )

# [Applier Samples For RHACM](#getting-started)

To install the applier:
```bash
git clone https://github.com/open-cluster-management/library-go.git
cd library-go
make build
mv bin/applier /usr/local/bin
```

for more information about the applier visit [Applier Documentation](https://github.com/open-cluster-management/library-go/blob/master/docs/applier.md)

## Scenarios
### Cluster Life Cycle

- [Import an existing cluster](./import-cluster)
- [Create and import a cluster](./create-cluster)
