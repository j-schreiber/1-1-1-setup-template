# PARAMS
Param(
    [Alias("a")]
    [parameter(
        Mandatory=$true,
        HelpMessage="Scratch Org Alias that will be used for this Org"
    )][string]$alias,
    [Alias("ak")]
    [parameter(
        Mandatory=$true,
        HelpMessage="Installation key for the first Dependency'"
    )][string]$dependencyInstallationKey1,
    [Alias("bk")]
    [parameter(
        Mandatory=$true,
        HelpMessage="Installation key for the second Dependency'"
    )][string]$dependencyInstallationKey2,
    [Alias("d")]
    [int]$duration = 7,
    [Alias("f")]
    [string]$configFile = 'config/default-scratch-def.json',
    [Alias("v")]
    [string]$devhubusername = 'YourDevhubUsernameAlias'
)

# always silently create force-app folder
Write-Host "md -Force force-app | Out-Null"
md -Force force-app | Out-Null

Write-Host "sfdx force:org:create -v $devhubusername -d $duration -f $configFile -a $alias -s"
sfdx force:org:create -v $devhubusername -d $duration -f $configFile -a $alias -s

Write-Host "sfdx texei:package:dependencies:install -v $devhubusername -k ""1:$dependencyInstallationKey1 2:$dependencyInstallationKey2"" -u $alias -w 10 -r"
sfdx texei:package:dependencies:install -v $devhubusername -k "1:$dependencyInstallationKey1 2:$dependencyInstallationKey2" -u $alias -w 10 -r

Write-Host "sfdx force:source:push -u $alias"
sfdx force:source:push -u $alias

# Write-Host "sfdx force:user:permset:assign -n Permission_Set_Developer_Name -u $alias"
# sfdx force:user:permset:assign -n Permission_Set_Developer_Name -u $alias

Write-Host "sfdx force:data:tree:import -p data/plans/standard-plan.json -u $alias"
sfdx force:data:tree:import -p data/plans/standard-plan.json -u $alias

Write-Host "sfdx force:apex:execute -f scripts/apex/post-setup-script.apex -u $alias | out-null"
sfdx force:apex:execute -f scripts/apex/post-setup-script.apex -u $alias | out-null

Write-Host "sfdx force:org:open -u $alias"
sfdx force:org:open -u $alias