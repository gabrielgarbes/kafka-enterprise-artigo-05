# Referências oficiais

- [Red Hat — Streams for Apache Kafka 3.2: metrics e observabilidade](https://docs.redhat.com/en/documentation/red_hat_streams_for_apache_kafka/3.2/html/deploying_and_managing_streams_for_apache_kafka_on_openshift/assembly-metrics-str)
- [Red Hat — Streams for Apache Kafka 3.2: API Reference](https://docs.redhat.com/en/documentation/red_hat_streams_for_apache_kafka/3.2/html/streams_for_apache_kafka_api_reference/)
- [Strimzi — Exemplo de Kafka e JMX Exporter](https://github.com/strimzi/strimzi-kafka-operator/blob/main/packaging/examples/metrics/kafka-metrics.yaml)
- [Strimzi — Exemplo PodMonitor](https://github.com/strimzi/strimzi-kafka-operator/blob/main/packaging/examples/metrics/prometheus-install/pod-monitors/kafka-resources-metrics.yaml)
- [Prometheus — PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana — Dashboard import](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/import-dashboards/)

Os manifestos foram escritos de forma independente para fins didáticos,
seguindo os conceitos e padrões das referências indicadas. Métricas e nomes
podem variar por versão Kafka, conjunto de MBeans e regras JMX Exporter.
