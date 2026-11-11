#!/usr/bin/env bash
set -euo pipefail
: "${KAFKA_NAMESPACE:=streaming-demo}"
: "${KAFKA_CLUSTER:=streaming-demo}"
command -v oc >/dev/null || { echo "Erro: comando oc não encontrado." >&2; exit 1; }
echo '=== Cluster e métricas ==='
oc get kafka "$KAFKA_CLUSTER" -n "$KAFKA_NAMESPACE"
oc get cm kafka-metrics -n "$KAFKA_NAMESPACE"
oc get podmonitor kafka-resources-metrics -n "$KAFKA_NAMESPACE"
echo '=== Pods observados ==='
oc get pods -n "$KAFKA_NAMESPACE" -l 'strimzi.io/kind=Kafka' -o wide
echo '=== Endpoints de métricas (via pod) ==='
echo "Selecione um pod Kafka e execute (em outro terminal):"
echo "  oc port-forward -n '$KAFKA_NAMESPACE' pod/<pod-kafka> 9404:9404"
echo "  curl -fsS http://127.0.0.1:9404/metrics | grep -E 'kafka_server_|kafka_controller_' | head"
echo '=== Próxima validação ==='
echo 'Em Observe > Targets, confira se Prometheus descobriu o PodMonitor e os pods estão UP.'
echo 'Consulte depois as expressões de grafana/queries.md.'
