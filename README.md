# vmss-vm-metatdata-retrival-sample

This repository provides a practical demonstration of utilizing [`cloud-init`](https://cloudinit.readthedocs.io/en/latest/) for Linux VMs and [Azure Custom Script Extension](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows) for Windows VMs. The goal is to create a `.env` file on the VM that contains VM metadata retrieved from the [VM metadata service](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service?tabs=windows) when using [Azure VM Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview).. Presently, the `.env` file includes the VM name exclusively.

By employing these methods, you can seamlessly establish and oversee VMs with tailored configurations, thereby offering a versatile solution for a range of deployment scenarios.

With these methods, you can easily set up and manage VMs with customised configurations, making it a versatile solution for various deployment scenarios.


## Run Sample

1. Create a resources group or choose one you want to deploy this into.
   To creat one you can use following comand:

2. Deploy VMSS

```bash
cd <os-name>
az deployment group create -g "<rg-name>" --template-file <os-name>-vmss.bicep
```
