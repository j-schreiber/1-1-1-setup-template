# PARAMS
Param(
    [Alias("u")]
    [string]$username = 'YourUsernameAlias',
    [Alias("v")]
    [string]$devhubusername = 'YourDevhubUsernameAlias',
    [Alias("k")]
    [parameter(
        Mandatory=$true,
        HelpMessage="Package Installation Key"
    )][string]$installationKey,
    [Alias("p")]
    [parameter(
        Mandatory=$true,
        HelpMessage="Package Id"
    )][string]$packageId
)

$query = "SELECT SubscriberpackageVersionId FROM Package2Version WHERE Package2Id = '$packageId' ORDER BY MajorVersion DESC,MinorVersion DESC,PatchVersion DESC,BuildNumber DESC LIMIT 1"
$queryResult = sfdx force:data:soql:query -q $query -u $devhubusername -t --json | ConvertFrom-Json
$SubscriberPackageVersionId = $queryResult.result.records[0].SubscriberPackageVersionId
sfdx force:package:install -w 10 -b 10 -u $username -k $installationKey -p $SubscriberPackageVersionId -r