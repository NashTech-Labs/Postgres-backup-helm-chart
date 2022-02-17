{{ define "isenabled.workloadorserviceaccount" }}
{{- if and (not .Values.workloadIdentity.enabled) (not .Values.gcs_serviceaccount.enabled) }}
{{- fail "Either Workload Identity or GCP service Account secret should be enabled to access the GCS Bucket" -}}
{{- end }}
{{- end -}}

{{ define "backup.serviceaccount" }}
{{- if .workloadIdentity.enabled }}
serviceAccountName: {{ required "Kubernetes service account having workload identity is mandatory" .workloadIdentity.serviceAccountonKuberenetes }}
{{- else }}
serviceAccountName: default
{{- end }}
{{- end }}

{{- define "backup.gcp_serviceaccount" }}
{{- if .Values.gcs_serviceaccount.enabled -}}
{{- if .Values.gcs_serviceaccount.existing_secret.enabled }}
{{- with .Values.gcs_serviceaccount.existing_secret }}
- name: gcloud-key
  secret:
    secretName: {{ required "Secret Name is required containing the service account private key as json" .secretName | quote }}
    items:
      - key: {{ required "Secret Key is required containing the service account private key as json" .secretKey | quote }}
        path: serviceaccount.json
{{- end }}
{{- else }}
- name: gcloud-key
  secret:
    secretName: {{ .Chart.Name }}-serviceaccount-key
    items:
      - key: serviceaccount.json
        path: serviceaccount.json
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "backup.gcp_creds" }}
- name: GOOGLE_APPLICATION_CREDENTIALS
  value: "/gcloud-key/serviceaccount.json"
{{- end -}}

{{ define "postgres.secretresource" }}
{{- with .Values.postgres_existing_secret }}
{{- if .enabled }}
- name: PG_ADMIN_USER
  valueFrom:
    secretKeyRef:
      name: {{ required "Postgres admin user Secret key required" .postgres_admin_user.secretName }}
      key: {{ required "Postgres secret Name required" .postgres_admin_user.secretKey }}
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ required "Postgres admin password secret key required" .postgres_password.secretName }}
      key: {{ required "Postgres secret Name required" .postgres_password.secretKey }}
{{- else }}
- name: PG_ADMIN_USER
  value: {{ default "postgres" $.Values.postgres_admin_user | quote }}
- name: "PGPASSWORD"
  value: {{ required "Postgres Password required" $.Values.postgres_Password | quote }}
{{- end }}
{{- end }}
{{- end }}