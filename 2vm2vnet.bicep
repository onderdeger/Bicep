param virtualMachineSize string
param adminUsername string

@secure()
param adminPassword string
param storageAccountType string
param location string = resourceGroup().location

var virtualMachineName1 = 'Test01-VM'
var virtualMachineName2 = 'Test02-VM'
var nic1Name = '${virtualMachineName1}-nic01'
var nic2Name = '${virtualMachineName2}-nic01'
var virtualNetworkName1 = 'Test01-VNET'
var virtualNetworkName2 = 'Test02-VNET'
var subnet1Name = 'Test01-SB01'
var subnet2Name = 'Test01-SB02'
var subnet3Name = 'Test02-SB01'
var subnet4Name = 'Test02-SB02'
var publicIPAddressName1 = '${virtualMachineName1}-pip1'
var publicIPAddressName2 = '${virtualMachineName2}-pip2'
var diagStorageAccountName1 = 'diags1${uniqueString(resourceGroup().id)}'
var diagStorageAccountName2 = 'diags2${uniqueString(resourceGroup().id)}'
var networkSecurityGroupName1 = '${subnet1Name}-nsg'
var networkSecurityGroupName2 = '${subnet3Name}-nsg'


// This is the Vm01
resource vm1 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: virtualMachineName1
  location: location
  properties: {
    osProfile: {
      computerName: virtualMachineName1
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nic1.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount1.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount1 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: diagStorageAccountName1
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
}

// This is the Vm02
resource vm2 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: virtualMachineName2
  location: location
  properties: {
    osProfile: {
      computerName: virtualMachineName2
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nic2.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount2.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount2 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: diagStorageAccountName2
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
}

// This will build VNET1.
resource vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName1
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.10.0.0/24'
          networkSecurityGroup: {
            id: nsg1.id
          }
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

// This will build VNET2.
resource vnet2 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName2
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '20.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet3Name
        properties: {
          addressPrefix: '20.20.0.0/24'
          networkSecurityGroup: {
            id: nsg2.id
          }
        }
      }
      {
        name: subnet4Name
        properties: {
          addressPrefix: '20.20.1.0/24'
        }
      }
    ]
  }
}

// This will be your VM01 NIC
resource nic1 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nic1Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet1.id}/subnets/${subnet1Name}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip1.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg1.id
    }
  }
}

// This will be your VM02 NIC
resource nic2 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet2.id}/subnets/${subnet3Name}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip2.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg2.id
    }
  }
}


// Public IP for your VM01
resource pip1 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIPAddressName1
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Public IP for your VM02
resource pip2 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIPAddressName2
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}


// Network Security Group (NSG) for VM01
resource nsg1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName1
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Network Security Group (NSG) for VM02
resource nsg2 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName2
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// VNET Peering 1
resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: '${vnet1.name}/${vnet1.name}-${vnet2.name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}

// VNET Peering 1
resource VnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: '${vnet2.name}/${vnet2.name}-${vnet1.name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}
output publicIp1 string = pip1.properties.ipAddress
output publicIp2 string = pip2.properties.ipAddress
