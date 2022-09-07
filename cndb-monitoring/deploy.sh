#!/bin/bash
set -euo pipefail
cd -P -- "$(dirname -- "$0")" # switch to this dir

echoerr() { echo "$@" 1>&2; }
badopt() { echoerr "$@"; help='true'; }
opt() { if [[ -z ${2-} ]]; then badopt "$1 flag must be followed by an argument"; fi; export $1="$2"; }
required_args() { for arg in $@; do if [[ -z "${!arg-}" ]]; then badopt "$arg is a required argument"; fi; done; }

while [[ $# -gt 0 ]]; do
  arg="$1"
  case $arg in
    -e|--environment)   shift; opt environment "$1"; shift;;
    -h|--help)                 opt help true; shift;;
    *) shift;;
  esac
done

if [[ -z ${help-} ]]; then
  required_args environment
fi

if [[ -n ${help-} ]]; then
  echoerr "Usage: $0"
  echoerr "    -e, --environment   <environment>    environment to apply to"
  echoerr "    -h, --help"
  exit 1
fi

# https://github.com/riptano/helm-chart-repository/ must be added as "datastax" repository
helm upgrade cndb-monitoring datastax/cndb-monitoring --install --namespace monitor --history-max 5 --version "0.1.0+beb9ffc"  -f "./cndb-monitoring-${environment}-values.yaml"
