
{{/*
Create the full name used by the Kubernetes resources.
*/}}
{{- define "app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels used by the Kubernetes resources.
*/}}
{{- define "app.labels" -}}
app.kubernetes.io/name: {{ include "app.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Labels used to connect resources to the application Pods.
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.fullname" . }}
{{- end }}


{{/*
ServiceAccount name used by the cert-manager workload.
This exact name is also used by the EKS Pod Identity association.
*/}}
{{- define "app.serviceAccountName" -}}
cert-manager
{{- end }}

