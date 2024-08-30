#! /bin/bash
scratchOrgName="YOUR_ORG_NAME"
npm ci
wget https://raw.githubusercontent.com/j-schreiber/js-salesforce-configs/main/scratch-org-defs/default-scratch-def.json
wget https://raw.githubusercontent.com/j-schreiber/js-salesforce-configs/main/scratch-org-defs/na-scratch-def.json
jq --arg a "${scratchOrgName}" '.orgName = $a' default-scratch-def.json >config/default-scratch-def.json
jq --arg a "${scratchOrgName} (NA)" '.orgName = $a' na-scratch-def.json >config/na-scratch-def.json
rm -f default-scratch-def.json
rm -f na-scratch-def.json
./node_modules/.bin/prettier --write 'config/*.json'
git add config/default-scratch-def.json
git add config/na-scratch-def.json
git commit -m 'ops: update to latest scratch org def'
