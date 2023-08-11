{{/*
Expand the name of the chart.
*/}}
{{- define "jenkins-scripts.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenkins-scripts.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jenkins-scripts.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jenkins-scripts.labels" -}}
helm.sh/chart: {{ include "jenkins-scripts.chart" . }}
{{ include "jenkins-scripts.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jenkins-scripts.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jenkins-scripts.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins-scripts.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "jenkins-scripts.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define the jenkins-scripts.namespace template if set with forceNamespace or .Release.Namespace is set
https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/templates/_helpers.tpl
*/}}
{{- define "jenkins-scripts.namespace" -}}
{{- if .Values.forceNamespace -}}
{{ printf "namespace: %s" .Values.forceNamespace }}
{{- else -}}
{{ printf "namespace: %s" .Release.Namespace }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for rbac.
*/}}
{{- define "rbac.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1" }}
{{- print "rbac.authorization.k8s.io/v1" -}}
{{- else -}}
{{- print "rbac.authorization.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for cronjob.
We also add an extra check on the minimum k8s version because not all vendors 
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if and (.Capabilities.APIVersions.Has "batch/v1") (semverCompare ">=1.21.0-0" .Capabilities.KubeVersion.GitVersion) }}
{{- print "batch/v1" -}}
{{- else -}}
{{- print "batch/v1beta1" -}}
{{- end -}}
{{- end -}}
