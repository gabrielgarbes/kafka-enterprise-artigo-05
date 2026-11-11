"""Validação estática dos exemplos do Artigo 5 (não acessa cluster)."""
from pathlib import Path
import json
import re
import yaml

ROOT = Path(__file__).resolve().parents[1]
paths = sorted((ROOT/'manifests').glob('*.yaml'))
assert len(paths) >= 3, "Esperados ConfigMap, PodMonitor e alertas opcionais"
for path in paths:
    docs = [item for item in yaml.safe_load_all(path.read_text(encoding='utf8')) if item]
    assert docs and all('kind' in x and 'apiVersion' in x for x in docs), path
print('YAML: OK', len(paths))
cm = yaml.safe_load((ROOT/'manifests/01-kafka-metrics-configmap.yaml').read_text(encoding='utf8'))
inner = yaml.safe_load(cm['data']['kafka-metrics-config.yml'])
assert isinstance(inner['rules'],list) and len(inner['rules']) >= 5
assert any('raft-metrics' in rule['pattern'] for rule in inner['rules'])
assert cm['metadata']['name']=='kafka-metrics'
print('Regras JMX: OK', len(inner['rules']))
podmon = yaml.safe_load((ROOT/'manifests/02-podmonitor.yaml').read_text(encoding='utf8'))
assert podmon['spec']['podMetricsEndpoints'][0]['port']=='tcp-prometheus'
assert podmon['spec']['selector']['matchLabels']['strimzi.io/kind']=='Kafka'
print('PodMonitor: OK')
db = json.loads((ROOT/'grafana/kafka-operational-health.json').read_text(encoding='utf8'))
assert db['title'] and len(db['panels'])>=10
assert all('targets' in p for p in db['panels'] if p['type'] not in ['row'])
assert any('kafka_consumergroup_lag' in str(p['targets']) for p in db['panels'] if 'targets' in p)
print('Dashboard JSON: OK',len(db['panels']),'painéis')
for img in ['dashboard-saudavel-sintetico.png','dashboard-falha-sintetico.png']:
    assert (ROOT/'examples'/img).stat().st_size>10000
print('Imagens sintéticas: OK')
for script in (ROOT/'scripts').glob('*.sh'):
    assert 'set -euo pipefail' in script.read_text()
print('Scripts: OK')
