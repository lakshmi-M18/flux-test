#!/bin/bash
set -euo pipefail

# https://github.com/riptano/helm-chart-repository/ must be added as "datastax" repository
helm upgrade cndb-monitoring datastax/cndb-monitoring --install --namespace monitor --history-max 5 --version "0.1.0+beb9ffc"  -f "./cndb-monitoring-dev-values.yaml"
