metadata name = 'Private DNS Zones'
metadata description = 'This module deploys a Private DNS zone.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Private DNS zone name.')
param name string

@description('Optional. Array of A records.')
param a array = []

@description('Optional. Array of AAAA records.')
param aaaa array = []

@description('Optional. Array of CNAME records.')
param cname array = []

@description('Optional. Array of MX records.')
param mx array = []

@description('Optional. Array of PTR records.')
param ptr array = []

@description('Optional. Array of SOA records.')
param soa array = []

@description('Optional. Array of SRV records.')
param srv array = []

@description('Optional. Array of TXT records.')
param txt array = []

@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties \'vnetResourceId\' and \'registrationEnabled\'. The \'vnetResourceId\' is a resource ID of a vNet to link, \'registrationEnabled\' (bool) enables automatic DNS registration in the zone for the linked vNet.')
param virtualNetworkLinks array = []

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DNS Resolver Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0f2ebee7-ffd4-4fc0-b3b7-664099fdad5d')
  'DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'befefa01-2a29-4197-83a8-272ff33ce314')
  'Domain Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'eeaeda52-9324-47f6-8069-5d5bade478b2')
  'Domain Services Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '361898ef-9ed1-48c2-849c-a832951106bb')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Private DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b12aa53e-6015-4669-85d0-8515ebb3ae7f')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: location
  tags: tags
}

module privateDnsZone_A 'a/main.bicep' = [for (aRecord, index) in a: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-ARecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: aRecord.name
    aRecords: contains(aRecord, 'aRecords') ? aRecord.aRecords : []
    metadata: contains(aRecord, 'metadata') ? aRecord.metadata : {}
    ttl: contains(aRecord, 'ttl') ? aRecord.ttl : 3600
    roleAssignments: contains(aRecord, 'roleAssignments') ? aRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_AAAA 'aaaa/main.bicep' = [for (aaaaRecord, index) in aaaa: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-AAAARecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: aaaaRecord.name
    aaaaRecords: contains(aaaaRecord, 'aaaaRecords') ? aaaaRecord.aaaaRecords : []
    metadata: contains(aaaaRecord, 'metadata') ? aaaaRecord.metadata : {}
    ttl: contains(aaaaRecord, 'ttl') ? aaaaRecord.ttl : 3600
    roleAssignments: contains(aaaaRecord, 'roleAssignments') ? aaaaRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_CNAME 'cname/main.bicep' = [for (cnameRecord, index) in cname: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-CNAMERecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: cnameRecord.name
    cnameRecord: contains(cnameRecord, 'cnameRecord') ? cnameRecord.cnameRecord : {}
    metadata: contains(cnameRecord, 'metadata') ? cnameRecord.metadata : {}
    ttl: contains(cnameRecord, 'ttl') ? cnameRecord.ttl : 3600
    roleAssignments: contains(cnameRecord, 'roleAssignments') ? cnameRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_MX 'mx/main.bicep' = [for (mxRecord, index) in mx: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-MXRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: mxRecord.name
    metadata: contains(mxRecord, 'metadata') ? mxRecord.metadata : {}
    mxRecords: contains(mxRecord, 'mxRecords') ? mxRecord.mxRecords : []
    ttl: contains(mxRecord, 'ttl') ? mxRecord.ttl : 3600
    roleAssignments: contains(mxRecord, 'roleAssignments') ? mxRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_PTR 'ptr/main.bicep' = [for (ptrRecord, index) in ptr: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-PTRRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: ptrRecord.name
    metadata: contains(ptrRecord, 'metadata') ? ptrRecord.metadata : {}
    ptrRecords: contains(ptrRecord, 'ptrRecords') ? ptrRecord.ptrRecords : []
    ttl: contains(ptrRecord, 'ttl') ? ptrRecord.ttl : 3600
    roleAssignments: contains(ptrRecord, 'roleAssignments') ? ptrRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_SOA 'soa/main.bicep' = [for (soaRecord, index) in soa: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-SOARecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: soaRecord.name
    metadata: contains(soaRecord, 'metadata') ? soaRecord.metadata : {}
    soaRecord: contains(soaRecord, 'soaRecord') ? soaRecord.soaRecord : {}
    ttl: contains(soaRecord, 'ttl') ? soaRecord.ttl : 3600
    roleAssignments: contains(soaRecord, 'roleAssignments') ? soaRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_SRV 'srv/main.bicep' = [for (srvRecord, index) in srv: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-SRVRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: srvRecord.name
    metadata: contains(srvRecord, 'metadata') ? srvRecord.metadata : {}
    srvRecords: contains(srvRecord, 'srvRecords') ? srvRecord.srvRecords : []
    ttl: contains(srvRecord, 'ttl') ? srvRecord.ttl : 3600
    roleAssignments: contains(srvRecord, 'roleAssignments') ? srvRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_TXT 'txt/main.bicep' = [for (txtRecord, index) in txt: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-TXTRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: txtRecord.name
    metadata: contains(txtRecord, 'metadata') ? txtRecord.metadata : {}
    txtRecords: contains(txtRecord, 'txtRecords') ? txtRecord.txtRecords : []
    ttl: contains(txtRecord, 'ttl') ? txtRecord.ttl : 3600
    roleAssignments: contains(txtRecord, 'roleAssignments') ? txtRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module privateDnsZone_virtualNetworkLinks 'virtual-network-link/main.bicep' = [for (virtualNetworkLink, index) in virtualNetworkLinks: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-VirtualNetworkLink-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: contains(virtualNetworkLink, 'name') ? virtualNetworkLink.name : '${last(split(virtualNetworkLink.virtualNetworkResourceId, '/'))}-vnetlink'
    virtualNetworkResourceId: virtualNetworkLink.virtualNetworkResourceId
    location: contains(virtualNetworkLink, 'location') ? virtualNetworkLink.location : 'global'
    registrationEnabled: contains(virtualNetworkLink, 'registrationEnabled') ? virtualNetworkLink.registrationEnabled : false
    tags: virtualNetworkLink.?tags ?? tags
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource privateDnsZone_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: privateDnsZone
}

resource privateDnsZone_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(privateDnsZone.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: privateDnsZone
}]

@description('The resource group the private DNS zone was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the private DNS zone.')
output name string = privateDnsZone.name

@description('The resource ID of the private DNS zone.')
output resourceId string = privateDnsZone.id

@description('The location the resource was deployed into.')
output location string = privateDnsZone.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
