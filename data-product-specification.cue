package generic_dp

// All the data types that starts with OM_ are imported from OpenMetadata definitions

import "strings"

#Version:       string & =~"^[0-9]+\\.[0-9]+\\..+$"
#Id:            string & =~"^[a-zA-Z0-9:._-]+$"
#DataProductId: #Id & =~"^urn:dmb:dp:\(domain):[a-zA-Z0-9_-]+:\(majorVersion)$"
#ComponentId:   #Id & =~"^urn:dmb:cmp:\(domain):[a-zA-Z0-9_-]+:\(majorVersion):[a-zA-Z0-9_-]+$"
#URL:           string & =~"^https?://[a-zA-Z0-9@:%._~#=&/?]*$"
#OM_DataType:   string & =~"(?i)^(NUMBER|TINYINT|SMALLINT|INT|BIGINT|BYTEINT|BYTES|FLOAT|DOUBLE|DECIMAL|NUMERIC|TIMESTAMP|TIME|DATE|DATETIME|INTERVAL|STRING|MEDIUMTEXT|TEXT|CHAR|VARCHAR|BOOLEAN|BINARY|VARBINARY|ARRAY|BLOB|LONGBLOB|MEDIUMBLOB|MAP|STRUCT|UNION|SET|GEOGRAPHY|ENUM|JSON)$"
#OM_Constraint: string & =~"(?i)^(NULL|NOT_NULL|UNIQUE|PRIMARY_KEY)$"

#OM_TableData: {
  columns: [... string]
  rows: [... [...]]
}

#OM_Tag: {
  tagFQN:       string
  description?: string | null
  source:       string & =~"(?i)^(Tag|Glossary)$"
  labelType:    string & =~"(?i)^(Manual|Propagated|Automated|Derived)$"
  state:        string & =~"(?i)^(Suggested|Confirmed)$"
  href?:        string | null
}

#OM_Column: {
  name:     string
  dataType: #OM_DataType
  if dataType =~ "(?i)^(ARRAY)$" {
    arrayDataType: #OM_DataType
  }
  if dataType =~ "(?i)^(CHAR|VARCHAR|BINARY|VARBINARY)$" {
    dataLength: number
  }
  dataTypeDisplay?:    string | null
  description?:        string | null
  fullyQualifiedName?: string | null
  tags?: [... #OM_Tag]
  businessTerms?: [... #OM_Tag]
  constraint?:      #OM_Constraint | null
  ordinalPosition?: number | null
  if dataType =~ "(?i)^(JSON)$" {
    jsonSchema: string
  }
  if dataType =~ "(?i)^(MAP|STRUCT|UNION)$" {
    children: [... #OM_Column]
  }
}

#DataContract: {
  schema: [... #OM_Column]
  SLA: {
    intervalOfChange?: string | null
    timeliness?:       string | null
    upTime?:           string | null
    ...
  }
  endpoint?:           #URL | null
  dataSharingAgreement: #DataSharingAgreement
  ...
}

#DataSharingAgreement: {
  termsAndConditions?: string | null
  purpose?:         string | null
  billing?:         string | null
  security?:        string | null
  intendedUsage?:   string | null
  limitations?:     string | null
  lifeCycle?:       string | null
  confidentiality?: string | null
  ...
}

#OutputPort: {
  id:                       #ComponentId
  name:                     string
  fullyQualifiedName?:      string | null
  description:              string
  version:                  #Version & =~"^\(majorVersion)+\\..+$"
  infrastructureTemplateId: string
  useCaseTemplateId?:       string | null
  dependsOn: [...#ComponentId]
  platform?:            string | null
  technology?:          string | null
  outputPortType:       string
  creationDate?:        string | null
  startDate?:           string | null
  retentionTime?:       string | null
  processDescription?:  string | null
  dataContract:         #DataContract
  biTempBusinessTs?:   string | null
  biTempWriteTs?:      string | null
  tags: [... #OM_Tag]
  sampleData?:      #OM_TableData | null
  sampleQuery?:      string | null
  semanticLinking?: {...} | null
  specific: {...}
  ...
}

#Workload: {
  id:                       #ComponentId
  name:                     string
  fullyQualifiedName?:      string | null
  description:              string
  version:                  #Version & =~"^\(majorVersion)+\\..+$"
  infrastructureTemplateId: string
  useCaseTemplateId?:       string | null
  dependsOn: [...#ComponentId]
  platform?:       string | null
  technology?:     string | null
  workloadType?:   string | null
  connectionType?: string & =~"(?i)^(housekeeping|datapipeline)$" | null
  tags: [... #OM_Tag]
  readsFrom: [... string]
  specific: {...} | null
  ...
}

#Storage: {
  id:                  #ComponentId
  name:                string
  fullyQualifiedName?: string | null
  description:         string
  version:             #Version & =~"^\(majorVersion)+\\..+$"
  owners: [...string]
  infrastructureTemplateId: string
  useCaseTemplateId?:       string | null
  dependsOn: [...#ComponentId]
  platform?:    string | null
  technology?:  string | null
  storageType?: string | null
  tags: [... #OM_Tag]
  specific: {...} | null
  ...
}

#Observability: {
  id:                       #ComponentId
  name:                     string
  fullyQualifiedName:       string
  description:              string
  version:                  #Version & =~"^\(majorVersion)+\\..+$"
  infrastructureTemplateId: string
  useCaseTemplateId?:       string | null
  dependsOn: [...#ComponentId]
  endpoint:      #URL
  completeness:  {...} | null
  dataProfiling: {...} | null
  freshness:     {...} | null
  availability:  {...} | null
  dataQuality:   {...} | null
  specific:      {...} | null
  ...
}

#Component: {
  kind: string & =~"(?i)^(outputport|workload|storage|observability)$"
  if kind != _|_ {
    if kind =~ "(?i)^(outputport)$" {
      #OutputPort
    }
    if kind =~ "(?i)^(workload)$" {
      #Workload
    }
    if kind =~ "(?i)^(storage)$" {
      #Storage
    }
    if kind =~ "(?i)^(observability)$" {
      #Observability
    }
  }
  ...
}

id:                  #DataProductId
name:                string
fullyQualifiedName?: string | null
description:         string
kind:                string & =~"(?i)^(dataproduct)$"
domain:              string
version:             #Version
let majorVersion = strings.Split(version, ".")[0]
environment:                 string
dataProductOwner:            string
dataProductOwnerDisplayName: string
devGroup:                    string
ownerGroup:                  string
email?:                      string | null
supportSLA: {
  supportHours:             string | null
  responseTime:             string | null
  resolutionTime:           string | null
  informationTime:          string | null
}
status?:                     string & =~"(?i)^(draft|published|retired)$" | null
maturity?:                   string & =~"(?i)^(tactical|strategic)$" | null
billing?:                    {...} | null
businessInfo: {
  valueProposition: string | null
  valueGeneration?:            string & =~"(?i)^(Foundation|RevenueGeneration|OperationMonitoring)$" | null
  strategicInitiatives: [... string] | null
  stakeholderRoles: [... string] | null
  pricingType: string & =~"(?i)^(PayPerUse|Subscription)$" | null
  pricingInfo: {...} | null
  ...
}
securityInfo: {
  confidentiality: string & =~"(?i)^(Public|Internal|Confidential|Restricted|Secret)$"| null
  visibility: string & =~"(?i)^(Global|Department)$" | null
  GDPR: string & =~"(?i)^(Yes|No)$" | null
  ...
}
contacts: {
  ownerContact: string
  suportContact: string
}
targetConsumption: [... string] | null
tags: [... #OM_Tag]
businessConcepts: [... #OM_Tag]
specific: {...}
components: [#Component, ...#Component]
