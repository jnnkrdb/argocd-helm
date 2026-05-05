{{/*
Pod Spec
*/}}
{{- define "argocd.redis.podSpec" -}}
{{- $v := .Values -}}
{{- $global := $v.global -}}
{{- $img := $v.images -}}
{{- $main := $v.redis -}}
{{- $pod := $main.pod -}}
{{- $svc := $main.service -}}
{{- $pvc := $main.persistence -}}
{{- $ctrs := $main.containers -}}
{{- include "argocd.podSpec" ( dict "podSpec" $pod ) }}
serviceAccountName: sa-{{ include "argocd.fullname" . }}-redis
imagePullSecrets:
  {{- include "argocd.imagePullSecrets" ( 
      dict "imagePullSecrets" (concat $global.imagePullSecrets
                                      $pod.imagePullSecrets
                                      $img.argocd.imagePullSecrets
                                      $img.redis.imagePullSecrets )) | nindent 2 }}
initContainers:
  {{- with (concat $pod.initContainers) }}
  {{- . | toYaml | nindent 2 }} 
  {{- end }}
  - name: secretinit
    image: {{ include "argocd.image" ( dict "imageRoot" $img.argocd "global" $global ) }}
    {{- with $ctrs.secretinit.command }}
    command: 
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.secretinit.args }}
    args: 
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.secretinit.securityContext }}
    securityContext: 
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.secretinit.workingDir }}
    workingDir: {{ . | quote }}
    {{- end }}
    {{- with $ctrs.secretinit.resources }}
    resources:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with ( concat $ctrs.secretinit.extraEnvs 
                      $pod.extraEnvs) }}
    env:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with ( concat $ctrs.secretinit.extraEnvFrom 
                      $pod.extraEnvFrom) }}
    envFrom:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with ( concat $ctrs.secretinit.extraVolumeMounts 
                      $pod.extraVolumeMounts
                      $global.extraVolumeMounts) }}
    volumeMounts:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
{{- with (concat $global.extraVolumes 
                 $pod.extraVolumes) }}
volumes:
  {{- . | toYaml | nindent 2 }} 
{{- end }}
containers:
  {{- with (concat $pod.sidecarContainers) }}
  {{- . | toYaml | nindent 2 }}
  {{- end }}
  - name: redis
    image: {{ include "argocd.image" ( dict "imageRoot" $img.redis "global" $global ) }}
    {{- with $ctrs.redis.command }}
    command: 
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.redis.args }}
    args: 
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.redis.securityContext }}
    securityContext: 
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.redis.workingDir }}
    workingDir: {{ . | quote }}
    {{- end }}
    {{- with $ctrs.redis.resources }}
    resources:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with ( concat $ctrs.redis.extraEnvs 
                      $pod.extraEnvs) }}
    env:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    envFrom:
      {{- with ( concat $ctrs.redis.extraEnvFrom 
                        $pod.extraEnvFrom) }}
      {{- . | toYaml | nindent 6 }}
      {{- end }}
      - secretRef:
          name: {{ include "argocd.fullname" . }}-redis-auth
    ports:
      {{- range $portName, $portSpecs := $svc.ports }}
      - name: {{ $portName | quote }}
        containerPort: {{ $portSpecs.port }}
        protocol: {{ $portSpecs.protocol | quote }}
        {{- with $portSpecs.hostPort }}
        hostPort: {{ . }}
        {{- end }}
      {{- end }}
    {{- with ( concat $ctrs.redis.extraVolumeMounts 
                      $pod.extraVolumeMounts
                      $global.extraVolumeMounts) }}
    volumeMounts:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.redis.startupProbe }}
    startupProbe:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.redis.livenessProbe }}
    livenessProbe:
      {{- . | toYaml | nindent 6 }}
    {{- end }}
    {{- with $ctrs.redis.readinessProbe }}
    readinessProbe:
      {{- . | toYaml | nindent 6 }}
    {{- end }}

{{- end }}