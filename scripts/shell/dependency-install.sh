#! /bin/bash
# shellcheck disable=SC1091
set -e

targetOrg='ERP'

while getopts u: option
do
    case "${option}" in
        u )             targetOrg=${OPTARG};;
        * )
    esac
done

KEYS=scripts/.config/keys.env
if [ -f "$KEYS" ]; then
    set -o allexport
    source scripts/.config/keys.env
    set +o allexport
fi

if [ -z "$INSTALLATION_KEY_APEXUTILS" ]; then 
    echo 'Installation key for the apex utils dependency not set. Export key as environment variable with "export INSTALLATION_KEY_APEXUTILS=key" to avoid this prompt.'
    read -rp 'Enter installation key for the apex utils dependency: ' INSTALLATION_KEY_APEXUTILS
fi
if [ -z "$INSTALLATION_KEY_CORE" ]; then 
    echo 'Installation key for the core dependency not set. Export key as environment variable with "export INSTALLATION_KEY_CORE=key" to avoid this prompt.'
    read -rp 'Enter installation key for the core dependency: ' INSTALLATION_KEY_CORE
fi
if [ -z "$INSTALLATION_KEY_LWCUTILS" ]; then 
    echo 'Installation key for the lwc utils dependency not set. Export key as environment variable with "export INSTALLATION_KEY_LWCUTILS=key" to avoid this prompt.'
    read -rp 'Enter installation key for the lwc utils dependency: ' INSTALLATION_KEY_LWCUTILS
fi
if [ -z "$INSTALLATION_KEY_PIMS" ]; then 
    echo 'Installation key for the PIMS dependency not set. Export key as environment variable with "export INSTALLATION_KEY_PIMS=key" to avoid this prompt.'
    read -rp 'Enter installation key for the PIMS dependency: ' INSTALLATION_KEY_PIMS
fi
if [ -z "$INSTALLATION_KEY_FULFILLMENT" ]; then 
    echo 'Installation key for the FULFILLMENT dependency not set. Export key as environment variable with "export INSTALLATION_KEY_FULFILLMENT=key" to avoid this prompt.'
    read -rp 'Enter installation key for the FULFILLMENT dependency: ' INSTALLATION_KEY_FULFILLMENT
fi
if [ -z "$INSTALLATION_KEY_CORE" ] || [ -z "$INSTALLATION_KEY_APEXUTILS" ] || [ -z "$INSTALLATION_KEY_LWCUTILS" ] || [ -z "$INSTALLATION_KEY_PIMS" ] || [ -z "$INSTALLATION_KEY_FULFILLMENT" ]
then
    echo "At least one installation key not set. Exiting ..." >&2
    exit 1
fi

echo "sfdx force:package:install -p \"Apex Utils Dependency Package Version\" -u $targetOrg -w 10 -k $INSTALLATION_KEY_APEXUTILS"
sfdx force:package:install -p "Apex Utils Dependency Package Version" -u "$targetOrg" -w 10 -k "$INSTALLATION_KEY_APEXUTILS"

echo "sfdx force:package:install -p \"Core Dependency Package Version\" -u $targetOrg -w 10 -k $INSTALLATION_KEY_CORE"
sfdx force:package:install -p "Core Dependency Package Version" -u "$targetOrg" -w 10 -k "$INSTALLATION_KEY_CORE"

echo "sfdx force:package:install -p \"LWC Utils Dependency Package Version\" -u $targetOrg -w 10 -k $INSTALLATION_KEY_LWCUTILS"
sfdx force:package:install -p "LWC Utils Dependency Package Version" -u "$targetOrg" -w 10 -k "$INSTALLATION_KEY_LWCUTILS"

echo "sfdx force:package:install -p \"PIMS Dependency Package Version\" -u $targetOrg -w 10 -k $INSTALLATION_KEY_PIMS"
sfdx force:package:install -p "PIMS Dependency Package Version" -u "$targetOrg" -w 10 -k "$INSTALLATION_KEY_PIMS"

echo "sfdx force:package:install -p \"Fulfillment Dependency Package Version\" -u $targetOrg -w 10 -k $INSTALLATION_KEY_FULFILLMENT"
sfdx force:package:install -p "Fulfillment Dependency Package Version" -u "$targetOrg" -w 10 -k "$INSTALLATION_KEY_FULFILLMENT"
