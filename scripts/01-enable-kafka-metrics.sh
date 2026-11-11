#!/usr/bin/env bash
set -euo pipefail

: "${KAFKA_NAMESPACE:=streaming-demo}"
: "${KAFKA_CLUSTER:=streaming-demo}"
command -v oc >/dev/null || { echo "Erro: oc não está no PATH" >&2; exit 1; }
oc get namespace "$KAFKA_NAMESPACE" >/dev/null
oc get configmap kafka-metrics -n "$KAFKA_NAMESPACE" >/dev/null
oc get kafka "$KAFKA_CLUSTER" -n "$KAFKA_NAMESPACE" >/dev/null

echo "Aplicando metricsConfig no Kafka existente: ${KAFKA_NAMESPACE}/${KAFKA_CLUSTER}"
echo "Nenhuma outra propriedade do Kafka será substituída pelo patch de merge."
oc patch kafka "$KAFKA_CLUSTER" -n "$KAFKA_NAMESPACE" --type=merge -p \
  '{"spec":{"kafka":{"metricsConfig":{"type":"jmxPrometheusExporter","valueFrom":{"configMapKeyRef":{"name":"kafka-metrics","key":"kafka-metrics-config.yml"}}}}}}'
echo 'Verifique Ready e targets; alterações podem provocar reconciliação de pods.'
oc get kafka "$KAFKA_CLUSTER" -n "$KAFKA_NAMESPACE"
