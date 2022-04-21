# Data Product Specification

This repository wants to define an open specification to define data products with the following principles in mind:
- DP as an indipendent unit of deployment
- Technology indipendence
- Extensibility

With an open specification will be possible to create services for automatic deployment and interoperable components to build a Data Mesh platform.


# Data Product structure

The DP is composed by a general section with DP level information and four sub-structures:
* **Storage Areas**: where the DP will be deployed, containing all the specific information of the physical environment.
* **Output Ports**: representing all the different interfaces of the DP to expose the data
* **Workloads**: Internal jobs/processes to feed the DP and to perform housekeeping ( GDPR, regulation, audit, data quality, etc )
* **Observability**: provides transparency to the data conusmer about how the DP is currently working. this is not declarative, but exposing runtime data.

Each DP Trait ( Outputport, workload, observability ) will have a well defined and fixed structure and a "specific" one to handle technology specific stuff.
The fixed structure must be technology agnostic.

### General

* `ID: [String]` the unique identifier of the Data Product --> this will never change in the life of a DP
* * Constraints:
* * * Allowed characters are `[a-zA-Z]` and `[_-]`
* * * Data product ID is made of `$DPDomain.$DPIdentifier.$DPMajorVersion`
* `Name: [String]` the name of DP
* `FullyQualifiedName: [String]` Human-readable that uniquely identifies an entity
* `Domain: [String]` the identifier of the domain this DP is belonging to
* `Description: [String]` detailed description about what functional area this DP is representing, what purpose has and business related information.
* `Version: [String]` this is representing the version of the DP, because we consider the DP as an indipendent unit of deployment, so if a breaking change is needed, we create a brand new versionof the DP. If we introduce a new feature or patch it is not necessary create a new version, but we can change Y (new feature) or Z patch. Displayed as X.Y.Z where X is major version, Y is minor and Z is patch. Major version(X) is also shown in the ID and those 2 fields(version and ID) are always aligned with one another. 
* * Constraints:
* * * Major version of the data product is always the same as the major version of the components and it is the same version that is shown in both data product ID and component ID
* `Kind: [String]` type of component. Allowed values: [dataproduct | outputport | workload | storage | resource]
* `DataProductOwner: [String]` Data Product Owner, the id of actual user that receives the notifications about data product
* `DataProductOwnerDisplayName [String]`: The human readable version of `DataProductOwner`
* `Email: [String]` Point of contact, it could be the owner or a distribution list, but must be reliable and responsive.
* `InformationSLA: [String]` Describe what SLA the DP team is providing to answer additional information requests about the DP
* `Status: [String]` This is an enum representing the status of this version of the DP `[Draft|Published|Retired]`
* `Maturity: [String]` This is an enum to let the consumer understand if it is a tactical solution or not. It is really useful during migration from DWH or data lake [Tactical|Strategic]
* `Billing: [Yaml]` This is a free form key-value area where is possible to put information useful for resource tagging and billing.
* `Tags: [Array[Yaml]]` Tag labels at DP level ( please refer to OpenMetadata https://docs.open-metadata.org/metadata-standard/schemas/types/taglabel )
* `Specific: [Yaml]` this is a custom section where we can put all the information strictly related to a specific execution environment. It can also refer to an additional file. At this level we also embed all the information to provision the general infrastructure ( resource groups, networking, etc ) needed for a specific Data Product. For example if a company decide to create a ResourceGroup for each data product and have a subscription reference for each domain and environment, it will be specified at this level. Also it is reccommended to put general security here, Azure Policy or IAM policies, VPC/Vnet, Subnet. THis will be filled merging data from 

The **unique identifier** of a DataProduct is the concatenation of Domain, Name and Version. So we will refer to the `DP_UK` as a string composed in the following way `$DPDomain.$DPID.$DPVersion`


### Output Ports

* `ID: [String]` the unique identifier of the output port --> not modifiable
* * Constraints:
* * * Allowed characters are `[a-zA-Z]` and `[_-]`
* * * Output port ID is made of `$DPDomain.$DPIdentifier.$DPMajorVersion.$OutputPortIdentifier`
* `Name: [String]` the name of the Output Port
* `FullyQualifiedName: [String]` Human-readable that uniquely identifies an entity
* `OutputPortType: [String]` the kind of output port: Files - SQL - Events. This should be extendible with GraphQL or others.
* `Technology: [String]` the underlying technology is useful for the consumer to understand better how to consume the output port and also needed for self serve provisioning specific stuff.
* `Platform`: This represents the vendor: Azure, GCP, AWS, CDP on AWS, etc. It is a free field but it is useful to understand better the platform where the component will be running
* `Description: [String]` detailed explanation about the function and the meaning of the output port
* `Version: [String]` Specific version of the output port. Displayed as X.Y.Z where X is the major version of the data product, Y is minor feature and Z is patch. Major version(X) is also shown in the component ID and those 2 fields(version and ID) are always aligned with one another. 
* * Constraints:
* * * Major version of the data product is always the same as the major version of the components and it is the same version that is shown in both data product ID and component ID
* `Kind: [String]` type of component. Allowed values: [dataproduct | outputport | workload | storage | resource]
* `CreationDate: [String]` when this output port has been created
* `StartDate: [String]` the first business date present in the dataset, leave it null for events or we can use some standard semantic like: "-7D, -1Y"
* `ProcessDescription: [String]` what is the underlying process that contributes to generate the data exposed by this output port
* `BillingPolicy: [String]` how a consumer will be charged back when it consumes this output port
* `SecurityPolicy: [String]` additional information related to security aspects, like restrictions, maskings, sensibile information
* `ConsumerPolicy: [String]` any other information needed by the consumer in order to effectively consume the data, it could be related to technical stuff, regulation, security, etc.
* `SLO:[Yaml]`
  * `IntervalOfChange: [String]` How often changes in the data are reflected
  * `Timeliness: [String]` The skew between the time that a business fact occuts and when it becomes visibile in the data
* `Endpoint: [URL]` this is the API endpoint that self-describe the output port and provide insightful information at runtime about the physical location of the data, the protocol must be used, etc
* `Allows: [Array[String]]` It is an array of user/role/group related to LDAP/AD user. This field is defining who has access in read-only to this specific output port
* `Owners: [Array[String]]` It is an array of user/role/group related to LDAP/AD user. This field defines who has all permissions on this specific output port
* `InfrastructureTemplateId` the id of the microservice responsible for provisioning the component. A microservice may be capable of provisioning several UseCaseTemplateId 
* `UseCaseTemplateId` the id of the template used in the builder to create the component
* `DependsOn: [Array[String]]` An output port could depend on other output ports or storage areas, for example a SQL Output port could be dependent on a Raw Output Port because it is just an external table.
* * Constraints:
* * * This array will only contain ID-s 
* `Tags: [Array[Yaml]]` Tag labels at OutputPort level ( please refer to OpenMetadata https://docs.open-metadata.org/metadata-standard/schemas/types/taglabel )
* `SampleData: [Yaml]` - Provide a sample data of your outputport. See OpenMetadata specification: https://docs.open-metadata.org/openmetadata/schemas/entities/table#tabledata
* `Schema: [Array[Yaml]]` When it comes to describe a schema we propose to leverage OpenMetadata specification: Ref https://docs.open-metadata.org/openmetadata/schemas/entities/table#column. Each column can have a tag array and you can choose between simples LabelTags, ClassificationTags or DescriptiveTags. Here an example of classification Tag https://github.com/open-metadata/OpenMetadata/blob/main/catalog-rest-service/src/main/resources/json/data/tags/piiTags.json
* `SemanticLinKind: [Yaml]` Here we can express semantic relationships between this output port and other outputports ( also coming from other domains and data products ) 
* `Specific: [Yaml]` this is a custom section where we can put all the information strictly related to a specific technology or dependent from a standard/policy defined in the federated governance.


### Workloads

* `ID: [String]` the unique identifier of the workload
* * Constraints:
* * * Allowed characters are `[a-zA-Z]` and `[_-]`
* * * Workload ID is made of `$DPDomain.$DPIdentifier.$DPMajorVersion.$WorkloadIdentifier`
* `Name: [String]` the name of the workload
* `FullyQualifiedName: [String]` Human-readable that uniquely identifies an entity
* `Description: [String]` detailed explaination about the purpose of the workload, what sources is reading, what business logic is apllying, etc
* `Kind: [String]` type of component. Allowed values: [dataproduct | outputport | workload | storage | resource]
* `WorkloadType: [String]` explain what type of workload is: Ingestion ETL, Streaming, Internal Process, etc.
* `ConnectionType: [String]` This is an enum `[HouseKeeping|DataPipeline]`, `Housekeeping` is for all the workloads that are acting on internal data without any external dependency. `DataPipeline` instead is for workloads that are reading from outputport of other DP or external systems.
* `Technology: [String]` this is a list of technologies: Airflow, Spark, Scala. It is a free field but it is useful to understand better how it is behaving
* `Platform`: This represents the vendor: Azure, GCP, AWS, CDP on AWS, etc. It is a free field but it is useful to understand better the platform where the component will be running
* `Version: [String]` Specific version of the workload. Displayed as X.Y.Z where X is the major version of the data product, Y is minor feature and Z is patch. Major version(X) is also shown in the component ID and those 2 fields(version and ID) are always aligned with one another. 
* * Constraints:
* * * Major version of the data product is always the same as the major version of the components and it is the same version that is shown in both data product ID and component ID
* `InfrastructureTemplateId` the id of the microservice responsible for provisioning the component. A microservice may be capable of provisioning several UseCaseTemplateId 
* `UseCaseTemplateId` the id of the template used in the builder to create the component
* `Tags: [Array[Yaml]]` Tag labels at Workload level ( please refer to OpenMetadata https://docs.open-metadata.org/metadata-standard/schemas/types/taglabel )
* `ReadsFrom: [Array[String]]` This is filled only for `DataPipeline` workloads and it represents the list of output ports or external systems that is reading. Output Ports are identified with `DP_UK.OutputPort_ID`, while external systems will be defined by a string `EX_$systemdescription`. Here we can elaborate a bit more and create a more semantic struct.
* * Constraints:
* * * This array will only contain ID-s 
* `Specific: [Yaml]` this is a custom section where we can put all the information strictly related to a specific technology or dependent from a standard/policy defined in the federated governance.


### Storage Area

* `ID: [String]` the unique identifier of the Storage Area.
* * Constraints:
* * * Allowed characters are `[a-zA-Z]` and `[_-]`
* * * Output port ID is made of `$DPDomain.$DPIdentifier.$DPMajorVersion.$OutputPortIdentifier`
* `Name: [String]` the name of the Storage Area
* `FullyQualifiedName: [String]` Human-readable that uniquely identifies an entity
* `StorageType: [String]` the kind of storage: Files - SQL - Events.
* `Technology: [String]` this is a list of technologies: S3, ADLS, SQLServer, Kafka.
* `Platform`: This represents the vendor: Azure, GCP, AWS, CDP on AWS, etc. It is a free field but it is useful to understand better the platform where the component will be running
* `Description: [String]` detailed explanation about the function and the meaning of this storage area
* `Kind: [String]` type of component. Allowed values: [dataproduct | outputport | workload | storage | resource]
* `Allows: [Array[String]]` It is an array of user/role/group related to LDAP/AD user. This field is defining who has access in read-only to this specific storage area
* `Owners: [Array[String]]` It is an array of user/role/group related to LDAP/AD user. This field defines who has all permissions on this specific storage area
* `InfrastructureTemplateId` the id of the microservice responsible for provisioning the component. A microservice may be capable of provisioning several UseCaseTemplateId 
* `UseCaseTemplateId` the id of the template used in the builder to create the component
* `Tags: [Array[Yaml]]` Tag labels at Storage area level ( please refer to OpenMetadata https://docs.open-metadata.org/metadata-standard/schemas/types/taglabel )
* `Specific: [Yaml]` this is a custom section where we can put all the information strictly related to a specific technology or dependent from a standard/policy defined in the federated governance.


### Observability

Observability should be applied to each Outputport and is better to represent it as the Swagger of an API rather than something declarative like a Yaml, because it will expose runtime metrics and statistics.
Anyway is good to formalize what kind of information should be included and verified at deploy time for the observability API:

* `ID: [String]` the unique identifier of the observability API
* `Name: [String]` the name of the observability API
* `FullyQualifiedName: [String]` Human-readable that uniquely identifies an entity
* `Description: [String]` detailed explanation about what this observability is exposing
* `Endpoint: [URL]` this is the API endpoint that will expose the observability for each OutputPort


* Completeness [Yaml]: degree of availability of all the necessary information along the entire history
* DataProfiling: [Yaml] Volume, distribution of volume along time, range of values, column values distribution and other statistics. Please refer to OpenMetadata to get our default implementation https://docs.open-metadata.org/openmetadata/schemas/entities/table#tableprofile. Keep in mind that this is the kind of standard that a company need to set based on its needs.
* Freshness: [Yaml]
* Availability: [Yaml]
* DataQuality: [Yaml] Describe data quality rules will be applied to the data, using the format you prefer.
