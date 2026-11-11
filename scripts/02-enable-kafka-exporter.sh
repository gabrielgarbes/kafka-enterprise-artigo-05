#!/usr/bin/env bash
set -euo pipefail
: "${KAFKA_NAMESPACE:=streaming-demo}"
: "${KAFKA_CLUSTER:=streaming-demo}"
command -v oc >/dev/null || { echo "Erro: oc não está no PATH" >&2; exit 1; }
oc get kafka "$KAFKA_CLUSTER" -n "$KAFKA_NAMESPACE" >/dev/null
cat <<'EOF'
ATENÇÃO: este comando altera a spec.kafkaExporter do cluster.
Se já existir Kafka Exporter configurado, confira a configuração antes de continuar.
EOF
if [[ "${CONFIRM_ENABLE_EXPORTER:-}" != "yes" ]]; then
  echo 'Para aplicar, exporte CONFIRM_ENABLE_EXPORTER=yes e execute novamente.'
  exit 2
fi
oc patch kafka "$KAFKA_CLUSTER" -n "$KAFKA_NAMESPACE" --type=merge -p \
  '{"spec":{"kafkaExporter":{"groupRegex":".*","topicRegex":".*","showAllOffsets":false,"resources":{"requests":{"cpu":"100m","memory":"128Mi"},"limits":{"cpu":"500m","memory":"256Mi"}}}}}'
echo 'Kafka Exporter configurado; verifique permissão e leitura dos consumer groups.'
