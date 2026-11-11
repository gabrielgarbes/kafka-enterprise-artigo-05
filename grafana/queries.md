# Consultas PromQL do dashboard

### Brokers com métricas

```promql
count(kafka_server_replicamanager_leadercount{namespace=~"$namespace"})
```

### Controllers ativos

```promql
sum(kafka_controller_kafkacontroller_activecontrollercount{namespace=~"$namespace"})
```

### Partições sub-replicadas

```promql
sum(kafka_server_replicamanager_underreplicatedpartitions{namespace=~"$namespace"})
```

### Partições offline

```promql
sum(kafka_controller_kafkacontroller_offlinepartitionscount{namespace=~"$namespace"})
```

### Mensagens recebidas / segundo

```promql
sum(rate(kafka_server_brokertopicmetrics_messagesin_total{namespace=~"$namespace",topic=""}[$__rate_interval]))
```

### Bytes de entrada / segundo

```promql
sum(rate(kafka_server_brokertopicmetrics_bytesin_total{namespace=~"$namespace",topic=""}[$__rate_interval]))
```

### Bytes de saída / segundo

```promql
sum(rate(kafka_server_brokertopicmetrics_bytesout_total{namespace=~"$namespace",topic=""}[$__rate_interval]))
```

### Partições sub-replicadas (evolução)

```promql
sum(kafka_server_replicamanager_underreplicatedpartitions{namespace=~"$namespace"})
```

### Líder KRaft visto pelos controllers

```promql
max by (kubernetes_pod_name) (kafka_server_raftmetrics_current_leader{namespace=~"$namespace",kubernetes_pod_name=~".*-controllers-.*"})
```

### Epoch KRaft por controller

```promql
max by (kubernetes_pod_name) (kafka_server_raftmetrics_current_epoch{namespace=~"$namespace",kubernetes_pod_name=~".*-controllers-.*"})
```

### Mudanças de líder (janela de 15 min)

```promql
max by (kubernetes_pod_name) (changes(kafka_server_raftmetrics_current_leader{namespace=~"$namespace",kubernetes_pod_name=~".*-controllers-.*"}[15m]))
```

### Número de votantes reportados

```promql
max by (kubernetes_pod_name) (kafka_server_raftmetrics_number_of_voters{namespace=~"$namespace",kubernetes_pod_name=~".*-controllers-.*"})
```

### Consumer lag por grupo

```promql
topk(10, sum by (consumergroup) (kafka_consumergroup_lag{namespace=~"$namespace"}))
```

### Request Handler Idle (%)

```promql
100 * avg(kafka_server_kafkarequesthandlerpool_requesthandleravgidle_percent{namespace=~"$namespace"})
```

### CPU utilizada por container Kafka

```promql
sum by (pod) (rate(container_cpu_usage_seconds_total{namespace=~"$namespace",container="kafka"}[$__rate_interval]))
```

### Uso de PVC Kafka

```promql
sum by (persistentvolumeclaim) (kubelet_volume_stats_used_bytes{namespace=~"$namespace"})
```

**Importante:** valide se as séries existem no Prometheus. `No data` não equivale a zero. O filtro de controllers pressupõe o NodePool `controllers`.
