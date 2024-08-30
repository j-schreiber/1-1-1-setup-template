#! /bin/bash
# shellcheck disable=SC1091
set -e

alias='NaYourScratchOrgAlias'
duration=7
configFile='config/na-scratch-def.json'
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
    echo "sf org create scratch -d $duration -f $configFile -a $alias -s"
    sf org create scratch -d "$duration" -f "$configFile" -a "$alias" -s
else
    echo "sf org create scratch -v $devhubusername -d $duration -f $configFile -a $alias -s"
    sf org create scratch -v "$devhubusername" -d "$duration" -f "$configFile" -a "$alias" -s
fi

echo "Installing dependencies on $alias..."
bash scripts/shell/dependency-install.sh -u "$alias"

echo "sf project deploy start -u $alias"
sf project deploy start -u "$alias"

echo "sf data import tree -p data/plans/standard-plan.json -u $alias"
sf data import tree -p data/plans/standard-plan.json -u "$alias"

echo "sf org open -u $alias -p \"/lightning/setup/SetupOneHome/home\""
sf org open -u "$alias" -p "/lightning/setup/SetupOneHome/home"
