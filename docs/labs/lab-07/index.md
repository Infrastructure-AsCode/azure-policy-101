# lab-07 - cleaning up resources

This is the most important part of the workshop. We need to clean up all resources that we provisioned during the workshop to avoid unexpected bills.

## Task #1 - delete lab infrastructure

Remove all resources that were created during the workshop by running the following command:

```powershell
# Get policy assignment name for assignment created from the portal
$assignmentName = (az policy assignment list --query "[?displayName=='[IAC] - Require a IAC-Department tag on resource groups'].name" -otsv)
az policy assignment delete -n $assignmentName
az policy assignment delete -n '[IAC] - Enforce NamingConvention for ResourceGroups'

as group delete --name iac-ws7-test-rg --yes
az group delete --name iac-ws7-rg --yes
az group delete --name iac-ws72-rg --yes
az group delete --name cloud-shell-storage-1 --yes
```

