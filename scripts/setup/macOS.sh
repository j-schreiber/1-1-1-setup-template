#!bin/bash
set -e

alias=
duration=7
configFile=config/default-scratch-def.json
devhubusername=

while getopts a:d:f:v: option
do
    case "${option}" in
        a )             alias=${OPTARG};;
        d )             duration=${OPTARG};;
        f )             configFile=${OPTARG};;
        v )             devhubusername=${OPTARG};;
    esac
done

if [ -z "$alias" ]; then
    echo "Missing required parameter: Alias. Use '-a MyAlias'"
    exit 1
fi
if [ -z "$INSTALLATION_KEY_FIRSTDEP" ]; then 
    echo 'Installation key for the converter dependency not set. Export key as environment variable with "export INSTALLATION_KEY_FIRSTDEP=key" to avoid this prompt.'
    read -p 'Enter installation key for the converter dependency: ' firstDepKey
    export INSTALLATION_KEY_FIRSTDEP=$firstDepKey
fi
if [ -z "$INSTALLATION_KEY_SECONDDEP" ]; then 
    echo 'Installation key for the core dependency not set. Export key as environment variable with "export INSTALLATION_KEY_SECONDDEP=key" to avoid this prompt.'
    read -p 'Enter installation key for the core dependency: ' secondDepKey
    export INSTALLATION_KEY_SECONDDEP=$secondDepKey
fi

if [ -z "$INSTALLATION_KEY_SECONDDEP" ] || [ -z "$INSTALLATION_KEY_FIRSTDEP" ]
then
    echo "At least one installation key is empty. Exiting ..." >&2
    exit 1
fi

echo "mkdir -p force-app"
mkdir -p force-app

if [ -z "$devhubusername" ]; then
    echo "sfdx force:org:create -d $duration -f $configFile -a $alias -s"
    sfdx force:org:create -d $duration -f $configFile -a $alias -s
else
    echo "sfdx force:org:create -v $devhubusername -d $duration -f $configFile -a $alias -s"
    sfdx force:org:create -v $devhubusername -d $duration -f $configFile -a $alias -s
fi

echo "sfdx force:package:install -p \"First Dependency Package Version\" -u $alias -w 10 -k $INSTALLATION_KEY_FIRSTDEP"
sfdx force:package:install -p "Second Dependency Package Version" -u $alias -w 10 -k $INSTALLATION_KEY_FIRSTDEP

echo "sfdx force:package:install -p \"Second Dependency Package Version\" -u $alias -w 10 -k $INSTALLATION_KEY_SECONDDEP"
sfdx force:package:install -p "Second Dependency Package Version" -u $alias -w 10 -k $INSTALLATION_KEY_SECONDDEP

echo "sfdx force:source:push -u $alias"
sfdx force:source:push -u $alias

echo "sfdx force:data:tree:import -p data/plans/standard-plan.json -u $alias"
sfdx force:data:tree:import -p data/plans/standard-plan.json -u $alias

echo "sfdx force:apex:execute -f scripts/apex/post-setup-script.apex -u $alias > /dev/null"
sfdx force:apex:execute -f scripts/apex/post-setup-script.apex -u $alias > /dev/null

echo "sfdx force:org:open -u $alias"
sfdx force:org:open -u $alias