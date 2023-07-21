# vmss-vm-metatdata-retrival-sample

This repository serves as a practical demonstration of how to use Azure VM Scale Sets along with cloud-init for Linux VMs and Azure Custom Script Extension for Windows VMs to create a .env file on the VM containing VM metadata. Currently, the .env file only includes the VM name.

With these methods, you can easily set up and manage VMs with customized configurations, making it a versatile solution for various deployment scenarios.

## Run Sample

1. Create a resources group of choose one you want to deploy this into.
   To creat one you can use following comand:

2. Deploy VMSS

```bash
cd <os-name>
az deployment group create -g "<rg-name>" --template-file <os-name>-vmss.bicep
```
