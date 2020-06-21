# PARAMS
Param(
    [Alias("k")]
    [parameter(
        Mandatory=$true,
        HelpMessage="The package installation key"
    )][string]$installationKey,
    [Alias("u")]
    [string]$username = 'YourUsernameAlias',
    [Alias("v")]
    [string]$devhubusername = 'YourDevhubUsernameAlias',
    [Alias("p")]
    [string]$packageId = 'PackageId',
    [Alias("i")]
    [parameter(
        HelpMessage="Install only flag: Does not build a new package version and only installs the latest package version."
    )][switch]$installOnly = $false
)

if (!$installOnly) {
    Write-Host "sfdx force:package:version:create -p $packageId -v $devhubusername -w 20 -k $installationKey"
    sfdx force:package:version:create -p $packageId -v $devhubusername -w 20 -k $installationKey
}

Write-Host "../lib/install-latest-version.ps1 -k $installationKey -u $username -v $devhubusername -p $packageId"
../lib/scripts/build/install-latest-version.ps1 -k $installationKey -u $username -v $devhubusername -p $packageId

Write-Host "sfdx force:apex:test:run -w 10 -c -r human -u $username"
sfdx force:apex:test:run -w 10 -c -r human -u $username