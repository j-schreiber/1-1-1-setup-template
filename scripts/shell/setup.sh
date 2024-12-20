#! /bin/bash
# shellcheck disable=SC1091
set -e

alias='YourScratchOrgAlias'
duration=7
configFile='config/default-scratch-def.json'
devhubusername=

while getopts a:d:f:v: option; do
    case "${option}" in
    a) alias=${OPTARG} ;;
    d) duration=${OPTARG} ;;
    f) configFile=${OPTARG} ;;
    v) devhubusername=${OPTARG} ;;
    *) ;;
    esac
done

echo "Installing node dependencies ..."
npm ci

if [ -z "$devhubusername" ]; then
    echo "sf org create scratch -y $duration -f $configFile -a $alias -d --json"
    sf org create scratch -y "$duration" -f "$configFile" -a "$alias" -d --json
else
    echo "sf org create scratch -v $devhubusername -y $duration -f $configFile -a $alias -d --json"
    sf org create scratch -v "$devhubusername" -y "$duration" -f "$configFile" -a "$alias" -d --json
fi

echo "Installing dependencies on $alias..."
bash scripts/shell/dependency-install.sh -u "$alias"

echo "sf project deploy start -u $alias"
sf project deploy start -u "$alias"

echo "sf data import tree -p data/plans/standard-plan.json -u $alias"
sf data import tree -p data/plans/standard-plan.json -u "$alias"

echo "sf org open -u $alias -p \"/lightning/setup/SetupOneHome/home\""
sf org open -u "$alias" -p "/lightning/setup/SetupOneHome/home"
