#! /bin/bash
# shellcheck disable=SC1091
set -e

targetOrg='YourScratchOrgAlias'

while getopts o: option; do
    case "${option}" in
    o) targetOrg=${OPTARG} ;;
    *) ;;
    esac
done

KEYS=scripts/.config/keys.env
if [ -f "$KEYS" ]; then
    set -o allexport
    source scripts/.config/keys.env
    set +o allexport
fi

if [ -z "$INSTALLATION_KEY_ONE" ]; then
    echo 'Installation key for the FIRST dependency not set. Export key as environment variable with "export INSTALLATION_KEY_ONE=key" to avoid this prompt.'
    read -rp 'Enter installation key for the FIRST dependency: ' INSTALLATION_KEY_ONE
fi
if [ -z "$INSTALLATION_KEY_TWO" ]; then
    echo 'Installation key for the SECOND dependency not set. Export key as environment variable with "export INSTALLATION_KEY_TWO=key" to avoid this prompt.'
    read -rp 'Enter installation key for the SECOND dependency: ' INSTALLATION_KEY_TWO
fi
if [ -z "$INSTALLATION_KEY_ONE" ] || [ -z "$INSTALLATION_KEY_TWO" ]; then
    echo "At least one installation key not set. Exiting ..." >&2
    exit 1
fi

echo "sf package install -p \"FIRST Dependency Package Version\" -o $targetOrg -w 10 -k $INSTALLATION_KEY_ONE --json"
sf package install -p "FIRST Dependency Package Version" -o "$targetOrg" -w 10 -k "$INSTALLATION_KEY_ONE" --json

echo "sf package install -p \"SECOND Dependency Package Version\" -o $targetOrg -w 10 -k $INSTALLATION_KEY_TWO --json"
sf package install -p "SECOND Dependency Package Version" -o "$targetOrg" -w 10 -k "$INSTALLATION_KEY_TWO" --json
