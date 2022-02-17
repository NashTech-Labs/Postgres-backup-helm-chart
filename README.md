# Postgres Backup
![Helm](https://cncf-branding.netlify.app/img/projects/helm/icon/color/helm-icon-color.png)

This Helm chart runs a cronjob and creates backup at a regular interval in the form of `.tar.gz` and upload the `tar.gz` file to GCS bucket. The chart is designed in such a manner that the Kubernetes Cluster need not be hotsed on GKE. In case of GKE cluster, the chart provides options to utilize the GKE `workload identity` feature to map GCS service account to Kuberentes Service Account.
* [Prerequisites](postgres-backup/README.md)