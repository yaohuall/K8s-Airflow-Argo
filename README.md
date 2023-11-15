## Using ArgoCD deploy Airflow cluster to remote cluster
### Framework version
- **K3s**: v1.27.7+k3s2+fannel channel
- **Airflow**: Airflow user-community Helm Chart 8.8.0
  - app version: 2.7.1
- **ArgoCD**: Argo-helm Chart 5.30.0
  - app version: 2.90.0

#### Kubectl and ArgoCD add external cluster and context
1. Edit kube config file and add certificate info of external cluster to local cluster.
2. Change context ```kubectl config use-context <your-context>```
3. Run ArgoCD CLI
   ```argocd cluster add <your-context>```
   
> :grey_exclamation:    Users and clusters are tied to a context and can change users and clusters by changing the context.

> :grey_exclamation:    A argocd-manager role & rolebinding & token secret will be added to external cluster.

### ArgoCD trouble-shooting
#### Chart deploy with values.yaml
- To use ArgoCD multi sources, install latest version.
#### Overally delete application
```kubectl patch application/airflow --type json --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]'```
#### When installing the official airflow Chart with Argo CD, Flux, Rancher or Terraform, database migration job is not starting
- MUST set the four following values, or your application will not start as the migrations will not be run:

```
createUserJob:
  useHelmHooks: false
  applyCustomEnv: false
migrateDatabaseJob:
  useHelmHooks: false
  applyCustomEnv: false
```

### Reference
- https://airflow.apache.org/docs/helm-chart/stable/index.html
- https://stackoverflow.com/questions/61462892/how-to-change-users-in-kubectl
- https://argo-cd.readthedocs.io/en/stable/user-guide/multiple_sources/
