#! /bin/bash
# shellcheck disable=SC1091
set -e

alias=
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

echo "============================================"
echo "Creating Scratch Org with these properties:"
echo "Devhub: $devhubusername"
echo "Config: $configFile"
echo "Duration: $duration"
echo "Alias: $alias"
echo "============================================"

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
bash scripts/shell/dependency-install.sh -o "$alias"

echo "sf project deploy start -o $alias"
sf project deploy start -o "$alias"

# echo "sf project deploy start  -d src/unpackaged-deploy -o $alias"
# sf project deploy start -d src/unpackaged-deploy -o "$alias"

# echo "sf org assign permset -n Package_Full_Access_Perm_Set -o $alias"
# sf org assign permset -n Package_Full_Access_Perm_Set -o "$alias"

echo "sf data import tree -p data/plans/standard-plan.json -o $alias"
sf data import tree -p data/plans/standard-plan.json -o "$alias"

echo "Generating login link for debugging"
sf org open -o "$alias" -r

echo "sf org open -o $alias -p \"/lightning/setup/SetupOneHome/home\""
sf org open -o "$alias" -p "/lightning/setup/SetupOneHome/home"
