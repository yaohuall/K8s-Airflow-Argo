## Using ArgoCD deploy Airflow cluster to remote cluster

### Prerequisite
- **Helm Chart**: v3.12.0
- **Terraform**: v1.6.1 on linux_amd64
### Need to update
1. Secret management

### Framework version
- **K3s**: v1.27.7+k3s2+fannel channel
- **Airflow**: Airflow user-community Helm Chart 8.8.0
  - app version: 2.7.1
- **ArgoCD**: Argo-helm Chart 5.30.0
  - app version: 2.90.0

### How to implement this repo?
#### Install ArgoCD with Terraform
1. Config your terraform backend in argocd/main.tf
   
```
terraform {
 backend "s3" {
   bucket         = "<your-tfstate-bucket>""
   key            = "<your-bucket-key>""
   region         = "<your-aws-region>"
 }
}
```
2. Run ```terraform init``` and  ```terraform apply --auto-approve```
3. Get ArgoCD UI password
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
#### Kubectl and ArgoCD add external cluster and context
1. Edit kube config file and add certificate info of external cluster to local cluster.
2. Change context ```kubectl config use-context <your-context>```
3. Run ArgoCD CLI
   ```argocd cluster add <your-context>```
   
> :grey_exclamation:    Users and clusters are tied to a context and can change users and clusters by changing the context.

> :grey_exclamation:    A argocd-manager role & rolebinding & token secret will be added to external cluster.

#### Deploy Airflow
- Run ```kubectl apply -f airflow-app.yaml```
  - You can config node-port/ingress settings in values.yaml in root path.
  - You can connect external database in production environment.
  - You can specify gitsync function in values.yaml in root path.

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
- https://github.com/airflow-helm/charts/tree/main/charts/airflow
- https://stackoverflow.com/questions/61462892/how-to-change-users-in-kubectl
- https://argo-cd.readthedocs.io/en/stable/user-guide/multiple_sources/
