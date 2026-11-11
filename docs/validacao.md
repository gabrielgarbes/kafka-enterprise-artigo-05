# Validação da observabilidade

Antes de executar, confirme o `oc` autenticado, o Kafka Operator instalado e a
existência do Kafka CR `streaming-demo` no namespace `streaming-demo`.

## 1. Verificações no OpenShift

```bash
oc get kafka,kafkanodepool,podmonitor,configmap -n streaming-demo
oc get pods -n streaming-demo -l 'strimzi.io/kind=Kafka' -o wide
oc describe podmonitor kafka-resources-metrics -n streaming-demo
```

## 2. Verificar a porta JMX Exporter

```bash
oc get pods -n streaming-demo -l 'strimzi.io/kind=Kafka'
oc port-forward -n streaming-demo pod/<nome-do-pod-kafka> 9404:9404
# Em outro terminal:
curl -fsS http://localhost:9404/metrics | head
```

O pod escolhido deve expor a porta `tcp-prometheus`. O teste por port-forward
é diagnóstico, não exposição pública da API de métricas.

## 3. Validar o Prometheus

- User Workload Monitoring deve estar habilitado no OpenShift.
- Confirme as métricas em Observe > Metrics (se permitido) ou no Prometheus.
- Execute `up{namespace="streaming-demo"}` e procure targets iguais a `1`.
- Verifique se a regra de seleção do PodMonitor corresponde aos labels dos pods.
- Se a PrometheusRule opcional não for carregada, confira os seletores de regras
  da instância de Prometheus e a política do cluster.

## 4. Validar no Grafana

1. Importe `grafana/kafka-operational-health.json`.
2. Selecione o datasource Prometheus na importação.
3. Escolha o namespace fictício `streaming-demo`.
4. Confira os painéis de saúde, quórum e tráfego.
5. `No data` **não** significa valor zero. Confira o nome da série no Explore.
6. Em cenários multi-tenant, revise os seletores de namespace e o acesso a dados.

## 5. Diagnóstico de métricas ausentes

| Sintoma | Ação recomendada |
|---|---|
| `No data` em todos os painéis | Verificar Prometheus targets, labels `namespace`, datasource e intervalo |
| Painéis do broker funcionam, KRaft não | Verificar métricas `raft-metrics`, versão do broker e expressão de filtro dos controllers |
| Lag não aparece | Conferir `spec.kafkaExporter`, consumer groups, commits e autorização da credencial do Exporter |
| PodMonitor não seleciona pods | Conferir `strimzi.io/kind=Kafka` e porta `tcp-prometheus` |
| Métrica disponível com outro nome | Adequar regras de JMX e consultas PromQL ao Kafka instalado |

**Cuidado:** métricas de metadados, tópicos e grupos podem ter alta cardinalidade.
Revise o escopo de coleta em ambientes grandes. Não exponha `/metrics` publicamente.
