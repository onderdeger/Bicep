param adminUsername string

@secure()
param adminPassword string
param location string = resourceGroup().location

var availabilitySet1 = 'FrondEndAVS01'
var availabilitySet2 = 'BackEndAVS01'
var availabilitySet3 = 'SQLAVS03'
var virtualMachineName1 = 'WebFrontEnd01'
var virtualMachineName2 = 'WebFrontEnd02'
var virtualMachineName3 = 'WebBackEnd01'
var virtualMachineName4 = 'WebBackEnd02'
var virtualMachineName5 = 'SQL01'
var virtualMachineName6 = 'SQL02'
var nic1Name = '${virtualMachineName1}-nic01'
var nic2Name = '${virtualMachineName2}-nic01'
var nic3Name = '${virtualMachineName3}-nic01'
var nic4Name = '${virtualMachineName4}-nic01'
var nic5Name = '${virtualMachineName5}-nic01'
var nic6Name = '${virtualMachineName6}-nic01'
var virtualNetworkName1 = 'App01-VNET'
var subnet1Name = 'DMZ-Subnet'
var subnet2Name = 'Application-Subnet'
var subnet3Name = 'DB-Subnet'
var publicIPAddressName1 = '${virtualMachineName1}-pip1'
var publicIPAddressName2 = '${virtualMachineName2}-pip1'
var publicIPAddressName3 = '${virtualMachineName3}-pip1'
var publicIPAddressName4 = '${virtualMachineName4}-pip1'
var publicIPAddressName5 = '${virtualMachineName5}-pip1'
var publicIPAddressName6 = '${virtualMachineName6}-pip1'
var diagStorageAccountName1 = 'diags1${uniqueString(resourceGroup().id)}'
var diagStorageAccountName2 = 'diags2${uniqueString(resourceGroup().id)}'
var diagStorageAccountName3 = 'diags3${uniqueString(resourceGroup().id)}'
var diagStorageAccountName4 = 'diags4${uniqueString(resourceGroup().id)}'
var diagStorageAccountName5 = 'diags5${uniqueString(resourceGroup().id)}'
var diagStorageAccountName6 = 'diags6${uniqueString(resourceGroup().id)}'
var networkSecurityGroupName1 = '${subnet1Name}-nsg'
var networkSecurityGroupName2 = '${subnet2Name}-nsg'
var networkSecurityGroupName3 = '${subnet3Name}-nsg'

//Availability Set for WebFrontEnd Servers
resource avs1 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: availabilitySet1
  location: location
  sku:{
    name: 'Aligned'
   }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 3
  }
}

//Availability Set for WebFrontEnd Servers
resource avs2 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: availabilitySet2
  location: location
  sku:{
    name: 'Aligned'
   }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 3
  }
}

//Availability Set for WebFrontEnd Servers
resource avs3 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: availabilitySet3
  location: location
  sku:{
    name: 'Aligned'
   }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 3
  }
}

// This is the WebFrontEnd01
resource vm1 'Microsoft.Compute/virtualMachines@2021-07-01' = {
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
      vmSize: 'Standard_D2_v3'
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
    availabilitySet: {
      id: avs1.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount1.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount1 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: diagStorageAccountName1
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

// This is the WebFrontEnd02
resource vm2 'Microsoft.Compute/virtualMachines@2021-07-01' = {
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
      vmSize: 'Standard_D2_v3'
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
    availabilitySet: {
      id: avs1.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount2.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount2 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: diagStorageAccountName2
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

// This is the WebBackEnd01
resource vm3 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachineName3
  location: location
  properties: {
    osProfile: {
      computerName: virtualMachineName3
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_D2_v3'
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
          id: nic3.id
        }
      ]
    }
    availabilitySet: {
      id: avs2.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount3.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount3 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: diagStorageAccountName3
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

// This is the WebBackEnd02
resource vm4 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachineName4
  location: location
  properties: {
    osProfile: {
      computerName: virtualMachineName4
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_D2_v3'
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
          id: nic4.id
        }
      ]
    }
    availabilitySet: {
      id: avs2.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount4.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount4 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: diagStorageAccountName4
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

// This is the SQL01
resource vm5 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachineName5
  location: location
  properties: {
    osProfile: {
      computerName: virtualMachineName5
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_D2_v3'
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
          id: nic5.id
        }
      ]
    }
    availabilitySet: {
      id: avs3.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount5.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount5 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: diagStorageAccountName5
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

// This is the SQL02
resource vm6 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachineName6
  location: location
  properties: {
    osProfile: {
      computerName: virtualMachineName6
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_D2_v3'
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
          id: nic6.id
        }
      ]
    }
    availabilitySet: {
      id: avs3.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagsAccount6.properties.primaryEndpoints.blob
      }
    }
  }
}

resource diagsAccount6 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: diagStorageAccountName6
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}
// This will build VNET.
resource vnet1 'Microsoft.Network/virtualNetworks@2021-03-01' = {
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
          networkSecurityGroup: {
            id: nsg2.id
          }
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: '10.10.2.0/24'
          networkSecurityGroup: {
            id: nsg3.id
          }
        }
      }
    ]
  }
}


// This will be your FrontEnd01 NIC
resource nic1 'Microsoft.Network/networkInterfaces@2021-03-01' = {
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

// This will be your FrontEnd02 NIC
resource nic2 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic2Name
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
            id: pip2.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg1.id
    }
  }
}

// This will be your BackEnd01 NIC
resource nic3 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic3Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet1.id}/subnets/${subnet2Name}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip3.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg2.id
    }
  }
}

// This will be your BackEnd02 NIC
resource nic4 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic4Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet1.id}/subnets/${subnet2Name}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip4.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg2.id
    }
  }
}


// This will be your SQL01 NIC
resource nic5 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic5Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet1.id}/subnets/${subnet3Name}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip5.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg3.id
    }
  }
}

// This will be your SQL01 NIC
resource nic6 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic6Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet1.id}/subnets/${subnet3Name}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip6.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg3.id
    }
  }
}

// Public IP for your FrontEnd01
resource pip1 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddressName1
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Public IP for your FrontEnd02
resource pip2 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddressName2
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Public IP for your BackEnd01
resource pip3 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddressName3
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Public IP for your BackEnd02
resource pip4 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddressName4
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Public IP for your SQL01
resource pip5 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddressName5
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Public IP for your SQL02
resource pip6 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddressName6
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Network Security Group (NSG1)
resource nsg1 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
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

// Network Security Group (NSG2)
resource nsg2 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
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

// Network Security Group (NSG3)
resource nsg3 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: networkSecurityGroupName3
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

