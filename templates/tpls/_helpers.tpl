{{/*
Expand the name of the chart.
*/}}
{{- define "argocd.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "argocd.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "argocd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "argocd.defaultLabels" -}}
helm.sh/chart: {{ include "argocd.chart" . }}
{{ include "argocd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "argocd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "argocd.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the first non-empty value from a list.
The list is ordered by priority: the first non-empty item wins.

Usage:
spec: 
  storageClassName: {{ include "argocd.firstOf" (
                       list .Values.global.storageClassName
                            .Values.persistence.storageClassName ) }}
*/}}
{{- define "argocd.firstOf" -}}
{{- $result := "" -}}
{{- range . -}}
  {{- if and (not $result) . -}}
    {{- $result = . -}}
  {{- end -}}
{{- end -}}
{{- if $result -}}
{{ $result | quote }}
{{- end -}}
{{- end -}}

{{/*
Append all received labels from the listed items.
Usage:
  {{- include "argocd.keyValues" ( 
      dict "kvs" (list .Values.global.labels 
                          .Values.labels
                          .Values.pod.labels ) ) }}  
*/}}
{{- define "argocd.keyValues" }}
{{- range .kvs }}
{{- if . }}
{{ . | toYaml }}
{{- end }}
{{- end }}
{{- end }}