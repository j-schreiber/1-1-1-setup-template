#! /bin/bash
# shellcheck disable=SC1091
set -e

alias='Scratch_Alias_EU'
duration=7
configFile='config/default-scratch-def.json'

while getopts a:d: option; do
    case "${option}" in
    a) alias=${OPTARG} ;;
    d) duration=${OPTARG} ;;
    *) ;;
    esac
done

./scripts/shell/setup.sh -a "$alias" -d "$duration" -f "$configFile"

echo "sf data import tree -f data/currency-types.json -o $alias"
sf data import tree -f data/currency-types.json -o "$alias"
