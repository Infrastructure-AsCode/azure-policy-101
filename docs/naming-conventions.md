# Conventions

For this workshop we use the following conventions:

* we use `iac` as a prefix for all resources
* we call our workload `ws7`
 
## Naming conventions

We will use the following naming convention during this workshop.

| Resource type | Naming convention | Examples |
|--|--|--|
| Resource Group | {prefix}-{workload-name}-rg | iac-ws7-rg, iac-ws7-test-rg |
| Azure Virtual Network | {prefix}-{workload-name}-vnet | iac-ws7-vnet,  |
| Azure Virtual Network Subnet | {subnet name}-snet | workload-snet |
| Network Security Group | {prefix}-{vnet-or/and-subnet-name}-nsg | iac-ws7-vnet-workload-nsg |
| Managed Identity | {prefix}-{workload-name}-mi | iac-ws7-mi, iac-ws7-test-mi |


