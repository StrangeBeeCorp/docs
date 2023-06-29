# Resource group name
secops-resource-group-name = "SecOps"
secops-dns-resource-group-name = "SharedResources"
# Target region
secops-location = "France Central"

## Virtual Network
secops-virtual-network-name = "secops-vnet"
# Subnet names
secops-appgw-frontend-public-subnet-name = "secops-appgw-frontend-public-subnet"
secops-backend-private-subnet-name = "secops-backend-private-subnet"
secops-public-subnet-name = "secops-public-subnet"
# Subnets CIDRs
secops-vnet = "10.0.0.0/8"
secops-appgw-frontend-public-subnet = "10.1.0.0/16"
secops-backend-private-subnet = "10.2.0.0/16"
secops-public-subnet = "10.3.0.0/16"
# Public IPs
secops-bastion-public-ip-name = "secops-bastion-public-ip"
secops-myNVA-public-ip-name = "secops-mynva-public-ip"
secops-appgw-public-ip-name = "secops-appgw-public-ip"
# DNS zones
secops-dns-zone-name       = "azure.mydomain.com"
secops-private-zone-name  = "private.mydomain.com"

## Instances
# Bastion
secops-bastion-computer-name = "secops-bastion"
secops-bastion-vm-size = "Standard_B2s"
secops-bastion-admin-user = "azureuser"
secops-bastion-public-key-path = "~/.ssh/id_rsa.pub"
# myNVA
secops-myNVA-computer-name = "secops-myNVA"
secops-myNVA-vm-size = "Standard_DS2_v2"
secops-myNVA-admin-user = "azureuser"
secops-myNVA-public-key-path = "~/.ssh/id_rsa.pub"
# Common: managed OS Disk type - possible values are either Standard_LRS, StandardSSD_LRS, Premium_LRS
secops-os-disk-type   = "Standard_LRS"

# Data disks for TheHive and Cortex instances
secops-th-data-disk-name = "secops-thehive-data-disk" 
secops-th-data-disk-type = "StandardSSD_LRS" 
secops-th-data-disk-size = "16" 
secops-th-docker-disk-name = "secops-thehive-docker-disk" 
secops-th-docker-disk-type = "StandardSSD_LRS" 
secops-th-docker-disk-size = "32" 
secops-cortex-data-disk-name = "secops-cortex-data-disk" 
secops-cortex-data-disk-type = "StandardSSD_LRS" 
secops-cortex-data-disk-size = "16" 
secops-cortex-docker-disk-name = "secops-cortex-docker-disk" 
secops-cortex-docker-disk-type = "StandardSSD_LRS" 
secops-cortex-docker-disk-size = "32" 

# IP filtering whitelist 
secops-users = ["1.2.3.4/32","1.2.3.4/32"]

# KeyVault name
secops-key-vault-name = "my-keyvault-name"
