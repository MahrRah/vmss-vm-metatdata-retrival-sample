param adminPassword string ='235-dsbluebla'
param prefix string = 'vmmetadata'
var bePoolName = '${prefix}Bepool'
var loadBalancerName = '${prefix}VmssLB'
var nsgName = '${prefix}Nsg'
var vmssName = '${prefix}Vmss'
var vmssLBPublicIPName = '${prefix}vmssLBPublicIP'
var lbPoolID = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, bePoolName)
var frontEndIPConfigID = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancerName, 'loadBalancerFrontEnd')
var nsgGroupID = resourceId('Microsoft.Network/networkSecurityGroups', nsgName)
param location string = resourceGroup().location

param cloudInitScript string = loadFileAsBase64('./cloud-init.yaml')


resource vmssVNET 'Microsoft.Network/virtualNetworks@2015-06-15' = {
  name: 'vmssVNET'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'vmssSubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource vmssLBPublicIP 'Microsoft.Network/publicIPAddresses@2018-01-01' = {
  name: vmssLBPublicIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource vmssLB 'Microsoft.Network/loadBalancers@2018-01-01' = {
  name: loadBalancerName
  location: location
  dependsOn: [
    vmssVNET
    vmssLBPublicIP
  ]
  sku: {
    name: 'Standard'
  }
  properties: {
    backendAddressPools: [
      {
        name: bePoolName
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'loadBalancerFrontEnd'
        properties: {
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses',  vmssLBPublicIPName)
          }
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'LBRule'
        properties: {
          frontendIPConfiguration: {
            id: frontEndIPConfigID
          }
          backendAddressPool: {
            id: lbPoolID
          }
          protocol: 'tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
        }
      }
    ]
  }
}

resource vmssNSG 'Microsoft.Network/networkSecurityGroups@2015-06-15' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-ssh'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2022-03-01' = {
  name: vmssName
  location: location
  dependsOn: [
    vmssLB
    vmssNSG
  ]
  sku: {
    name: 'Standard_DS1_v2'
    capacity: 1
  }
  properties: {
    singlePlacementGroup: null
    platformFaultDomainCount: 1
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: null
          }
        }
        imageReference: {
          publisher: 'Canonical'
          offer: 'UbuntuServer'
          sku: '18.04-LTS'
          version: 'latest'
        }
      }
      osProfile: {
        computerNamePrefix: 'vmss'
        adminUsername: 'azureuser'
        adminPassword: adminPassword
        customData: cloudInitScript
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'vmss33ac4Nic'
            properties: {
              ipConfigurations: [
                {
                  name: 'vmss33ac4IPConfig'
                  properties: {
                    subnet: {
                      id: vmssVNET.properties.subnets[0].id
                    }
                    publicIPAddressConfiguration: {
                      name: 'instancepublicip'
                      properties: {
                        idleTimeoutInMinutes: 10
                      }
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: lbPoolID
                      }
                    ]
                  }
                }
              ]
              networkSecurityGroup: {
                id: nsgGroupID
              }
              primary: true
            }
          }
        ]
        networkApiVersion: '2020-11-01'
      }
    }
    orchestrationMode: 'Flexible'
  }
}

output VMSS object = vmss
