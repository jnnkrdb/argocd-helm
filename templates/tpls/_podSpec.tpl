{{/*
Special Pod Meta
Usage:
  {{- include "argocd.podMeta" ( dict "name" "name" "pod" $pod "context" $ ) }}  
*/}}
{{- define "argocd.podMeta" -}}
{{- $pod := .pod -}}
{{- $name := .name -}}
{{- $ctx := .context -}}
annotations:
  {{/* Adding checksums for all configs, because the apps use all configs... */}}
  checksum/argocd-cm: {{ include "argocd.checksumTemplate" (dict "path" "/config/configmap.argocd-cm.yaml" "context" $ctx ) | quote }}
  checksum/argocd-cmd-params-cm: {{ include "argocd.checksumTemplate" (dict "path" "/config/configmap.argocd-cmd-params-cm.yaml" "context" $ctx ) | quote }}
  checksum/argocd-gpg-keys-cm: {{ include "argocd.checksumTemplate" (dict "path" "/config/configmap.argocd-gpg-keys-cm.yaml" "context" $ctx ) | quote }}
  checksum/argocd-rbac-cm: {{ include "argocd.checksumTemplate" (dict "path" "/config/configmap.argocd-rbac-cm.yaml" "context" $ctx ) | quote }}
  checksum/argocd-secret: {{ include "argocd.checksumTemplate" (dict "path" "/config/secret.argocd-secret.yaml" "context" $ctx ) | quote }}
  checksum/argocd-ssh-known-hosts-cm: {{ include "argocd.checksumTemplate" (dict "path" "/config/configmap.argocd-ssh-known-hosts-cm.yaml" "context" $ctx ) | quote }}
  checksum/argocd-tls-certs-cm: {{ include "argocd.checksumTemplate" (dict "path" "/config/configmap.argocd-tls-certs-cm.yaml" "context" $ctx ) | quote }}
  checksum/argocd-redis-auth: {{ include "argocd.checksumTemplate" (dict "path" "/redis/secret.yaml" "context" $ctx ) | quote }}
  {{- include "argocd.keyValues" ( dict "kvs" ( list $pod.annotations) ) | nindent 2 }}
labels: 
  app.kubernetes.io/component: {{ $name | quote }}
  {{- include "argocd.selectorLabels" $ctx | nindent 2 }}
  {{- include "argocd.keyValues" ( dict "kvs" ( list $pod.labels) ) | nindent 2 }}
{{- end }}



{{/*
Special Pod Spec
Usage:
  {{- include "argocd.podSpec" ( dict "podSpec" .Values.argocdserver.pod ) }}  
*/}}
{{- define "argocd.podSpec" }}
{{- $ps := .podSpec -}}
{{/* ------------------------------------------------ Scheduling constraints */}}
{{- with $ps.affinity }}
affinity:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- with $ps.nodeSelector }}
nodeSelector:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- with $ps.tolerations }}
tolerations:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{/* ------------------------------------------------ Scheduling & identity */}}
{{- with $ps.nodeName }}
nodeName: {{ . | quote }}
{{- end }}
{{- with $ps.hostname }}
hostname: {{ . | quote }}
{{- end }}
{{- with $ps.subdomain }}
subdomain: {{ . | quote }}
{{- end }}
{{- with $ps.automountServiceAccountToken }}
automountServiceAccountToken: {{ . }}
{{- end }}
{{/* ------------------------------------------------ Network */}}
{{- with $ps.hostNetwork }}
hostNetwork: {{ . }}
{{- end }}
{{- with $ps.dnsPolicy }}
dnsPolicy: {{ . | quote }}
{{- end }}
{{- with $ps.dnsConfig }}
dnsConfig:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- with $ps.hostAliases }}
hostAliases:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{/* ------------------------------------------------ Pod-level security context */}}
{{- with $ps.securityContext }}
securityContext:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{/* ------------------------------------------------ Runtime, priority, scheduler */}}
{{- with $ps.runtimeClassName }}
runtimeClassName: {{ . | quote }}
{{- end }}
{{- with $ps.priorityClassName }}
priorityClassName: {{ . | quote }}
{{- end }}
{{- with $ps.priority }}
priority: {{ . }}
{{- end }}
{{- with $ps.schedulerName }}
schedulerName: {{ . | quote }}
{{- end }}
{{/* ------------------------------------------------ Process & service-related settings */}}
{{- with $ps.shareProcessNamespace }}
shareProcessNamespace: {{ . }}
{{- end }}
{{- with $ps.enableServiceLinks }}
enableServiceLinks: {{ . }}
{{- end }}
{{- with $ps.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
{{- end }}
{{- with $ps.activeDeadlineSeconds }}
activeDeadlineSeconds: {{ . }}
{{- end }}
{{/* ------------------------------------------------ Pod readiness gates: additional conditions required for Pod to be "Ready" */}}
{{- with $ps.readinessGates }}
readinessGates:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{/* ------------------------------------------------ scheduling constraints for topology spreading */}}
{{- with $ps.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- end }}