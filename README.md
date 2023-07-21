# vmss-vm-metatdata-retrival-sample

This repository serves as a practical demonstration of how to use [`cloud-init`](https://cloudinit.readthedocs.io/en/latest/). Amongst many other things, it allows you to  for Linux VMs and [Azure Custom Script Extension](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows). for Windows VMs to create a .env file on the VM containing VM metadata from [VM metadata service](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service?tabs=windows) when using [Azure VM Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview). Currently, the .env file only includes the VM name.

With these methods, you can easily set up and manage VMs with customized configurations, making it a versatile solution for various deployment scenarios.

## Run Sample

1. Create a resources group of choose one you want to deploy this into.
   To creat one you can use following comand:

2. Deploy VMSS

```bash
cd <os-name>
az deployment group create -g "<rg-name>" --template-file <os-name>-vmss.bicep
```
