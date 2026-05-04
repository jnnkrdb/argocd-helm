
{{/*
Checksum a template at "path" containing a *single* resource (ConfigMap,Secret) for use in pod annotations, excluding the metadata (see #18376).
Usage:
  {{ include "argocd.checksumTemplate" (dict "path" "/configmap.yaml" ) }}
*/}}
{{- define "argocd.checksumTemplate" -}}
{{- $path := .path -}}
{{- $ctx := .context | default $ -}}
{{- $basePath := "" -}}
{{- with .Template -}}
  {{- $basePath = .BasePath -}}
{{- else -}}
  {{- with $ctx.Template -}}
    {{- $basePath = .BasePath -}}
  {{- end -}}
{{- end -}}
{{- $obj := "" -}}
{{- if ne $basePath "" -}}
  {{- $obj = include (print $basePath $path) $ctx | fromYaml -}}
{{- else -}}
  {{- $obj = include $path $ctx | fromYaml -}}
{{- end -}}
{{- omit $obj "apiVersion" "kind" "metadata" | toYaml | sha256sum -}}
{{- end -}}