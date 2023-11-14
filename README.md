## Using ArgoCD deploy Airflow cluster to remote cluster

#### When installing the Chart with Argo CD, Flux, Rancher or Terraform, database migration job is not starting
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
