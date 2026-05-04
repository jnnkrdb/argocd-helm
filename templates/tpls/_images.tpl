
{{/*
Return the proper image name.
If image tag and digest are not defined, termination fallbacks to chart appVersion.
{{ include "argocd.image" ( dict "imageRoot" .Values.path.to.the.image "global" .Values.global "chart" .Chart ) }}
*/}}
{{- define "argocd.image" -}}
{{- $registryName := default .imageRoot.registry ((.global).imageRegistry) -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := .imageRoot.tag | toString -}}

{{- if not .imageRoot.tag }}
  {{- if .chart }}
    {{- $termination = .chart.AppVersion | toString -}}
  {{- end -}}
{{- end -}}

{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}

{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s"  $repositoryName $separator $termination -}}
{{- end -}}
{{- end -}}

{{/*
Return the list of imagePullSecrets, formatted as objects:
imagePullSecrets: (this key has to be added)
  - name: sec-1
  - name: sec-2
  - name: sec-global
{{ include "argocd.imagePullSecrets" ( 
   dict "imagePullSecrets" ( concat .Values.imagePullSecrets1, 
                                    .Values.imagePullSecrets2
                                    .Value.global.imagePullSecrets )) }}
*/}}
{{- define "argocd.imagePullSecrets" -}}
  {{- $finalImagePullSecrets := list -}}
  {{- range .imagePullSecrets -}}
    {{- if kindIs "map" . -}}
      {{- $finalImagePullSecrets = append $finalImagePullSecrets .name -}}
    {{- else -}}
      {{- $finalImagePullSecrets = append $finalImagePullSecrets . -}}
    {{- end -}}
  {{- end -}}
  {{- if (not (empty $finalImagePullSecrets)) -}}
    {{- range $finalImagePullSecrets | uniq }}
- name: {{ . | quote }}
    {{- end -}}
  {{- end -}}
{{- end -}}
