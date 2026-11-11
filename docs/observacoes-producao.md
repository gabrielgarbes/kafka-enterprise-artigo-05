# Notas para produção

Este repositório é **educacional**. Ele não é uma configuração pronta ou
certificada para qualquer ambiente OpenShift.

- Aplique o ConfigMap no mesmo namespace do Kafka CR.
- Se o Artigo 2 já estiver instalado, o ConfigMap e o PodMonitor existentes
  podem ser atualizados; faça um diff e planeje a mudança antes de aplicar.
- O patch de Kafka altera somente `spec.kafka.metricsConfig`, mas uma mudança
  pode desencadear reconciliação; use controle de mudanças e revise o estado Ready.
- O Kafka Exporter pode exigir permissão de leitura sobre grupos e offsets;
  métricas de lag dependem dos commits feitos pelos consumidores.
- Confirme os endpoints e labels **reais** antes de habilitar alertas.
- Ajuste limiares por workload; algumas partições podem mudar de estado
  durante rebalanceamentos normais e produzir alertas transitórios.
- O namespace `streaming-demo` é fictício; altere-o se necessário em todos os
  manifests e consultas de exemplo.
- O Prometheus precisa selecionar o PodMonitor. Em clusters corporativos,
  seletores, políticas e RBAC variam entre instalações.
- Use RBAC e acesso interno para evitar coleta/exposição não autorizada.
- Grafana requer acesso ao datasource Prometheus, que não é provisionado pelo
  repositório.
- Não publique screenshots reais de namespaces, endpoints internos, URLs,
  nomes de tópicos sensíveis ou métricas de negócio sem autorização.
- As figuras em `examples/` são **sintéticas**, não capturas reais do Grafana.
