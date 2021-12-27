# Data Product Specification

This repository wants to define an open specification to define data products with the following principles in mind:
- DP as an indipendent unit of deployment
- Technology indipendence
- Extensibility

With an open specification will be possible to create services for automatic deployment and interoperable components to build a Data Mesh platform.


# Data Product structure

The DP is composed by a general section with DP level information and four sub-structures:
* **Environment**: where the DP will be deployed, containing all the specific information of the physical environment.
* **Output Ports**: representing all the different interfaces of the DP to expose the data
* **Workloads**: Internal jobs/processes to feed the DP and to perform housekeeping ( GDPR, regulation, audit, data quality, etc )
* **Observability**: provides transparency to the data conusmer about how the DP is currently working. this is not declarative, but exposing runtime data.

Each DP Trait ( Outputport, workload, observability ) will have a well defined and fixed structure and a "specific" one to handle technology specific stuff.
The fixed structure must be technology agnostic.

### General

* `Name: [String]` the identifier of the Data Product
* `Domain: [String]` the identifier of the domain this DP is belonging to
* `Description: [String]` detailed description about what functional area this DP is representing, what purpose has and business related information.
* `Version: [String]` this is representing the version of the DP, because we consider the DP as an indipendent unit of deployment, so if a breaking change is needed, we create a brand new versionof the DP
* `Owner: [String]` Data Product Owner, it could be useful to insert some contact also like the email.
* `Email: [String]` Point of contact, it could be the owner or a distribution list, but must be reliable and responsive.
* `InformationSLA: [String]` Describe what SLA the DP team is providing for additional information about the DP
* `Status: [String]` This is an enum representing the status of this version of the DP `[Draft|Published|Retired]`
* `Maturity: [String]` This is an enum to let the consumer understand if it is a tactical solution or not. It is really useful during migration from DWH or data lake [Tactical|Strategic]
* `Billing: [Yaml]` This is a free form key-value area where is possible to put information useful for resource tagging and billing.
* `Tags: [Array[String]]` Free tags at DP level

The **unique identifier** of a DataProduct is the concatenation of Domain, Name and Version. So we will refer to the `DP_UK` as a string composed in the following way `$DPDomain.$DPName.$DPVersion`


### Environment

* `Name: [String]` The name of the environment
* `Specific: [Yaml]` this is a custom section where we can put all the information strictly related to a specific environment. We use this to set Base Path for API or for bucket names.


### Output Ports

* `Name: [String]` the identifier of the output port
* `ResourceType: [String]` the kind of output port: raw - SQL - Events. This should be extendible with GraphQL or others.
* `Technology: [String]` the underlying technology is useful for the consumer to understand better how to consume the output port and also needed for self serve provisioning specific stuff.
* `Description: [String]` detailed explanation about the function and the meaning of the output port
* `issueDate: [String]` when this output port has been created
* `startDate: [String]` the first business date present in the dataset, leave it null for events or we can use some standard semantic like: "-7D, -1Y"
* `ProcessDescription: [String]` what is the underlying process that contributes to generate the data exposed by this output port
* `BillingPolicy: [String]` how a consumer will be charged back when it consumes this output port
* `SecurityPolicy: [String]` additional information related to security aspects, like restrictions, maskings, sensibile information
* `ConsumerPolicy: [String]` any other information needed by the consumer in order to effectively consume the data, it could be related to technical stuff, regulation, security, etc.
* `SLO:[Yaml]`
  * `IntervalOfChange: [String]` How often changes in the data are reflected
  * `Timeliness: [String]` The skew between the time that a business fact occuts and when it becomes visibile in the data
* `Endpoint: [URL]` this is the API endpoint that self-describe the output port and provide insightful information at runtime about the physical location of the data, the protocol must be used, etc
* `Allow: [Array[String]]` It is an array of user/role/group related to the specific technology ( each technology will have an associated authentication system ( Azure AD, AWS IAM, etc ). This field is defining who has access in read-only to this specific output port
* `Owner: [String]` It is the user/role/group with write privileges for this outputport. This identity can be used only by DP internal processes and the provisioning service.
* `DependsOn: [Array[String]]` An output port could depend on other output ports, for example a SQL Output port could be dependent on a Raw Output Port because it is just an external table.
* `Tags: [Array[String]]` Free tags at OutputPort level
* `Specific: [Yaml]` this is a custom section where we can put all the information strictly related to a specific technology or dependent from a standard/policy defined in the federated governance.
 


### Workloads

* `Name: [String]` the identifier of the workload
* `ResourceType: [String]` explain what type of workload is, at the moment: batch or streaming
* `Type: [String]` This is an enum `[HouseKeeping|DataPipeline]`, `Housekeeping` is for all the workloads that are acting on internal data without any external dependency. `DataPipeline` instead is for workloads that are reading from outputport of other DP or external systems.
* `Technology: [String]` this is a list of technologies: Airflow, Spark, Scala. It is a free field but it is useful to understand better how it is behaving
* `Description: [String]` detailed explaination about the purpose of the workload, what sources is reading, what business logic is apllying, etc
* `DependsOn: [Array[String]]` This is filled only for `DataPipeline` workloads and it represents the list of output ports or external systems that is reading. Output Ports are identified with `DP_UK.OutputPort_Name`, while external systems will be defined by a string `EX_$systemdescription`. Here we can elaborate a bit more and create a more semantic struct.
* `Tags: [Array[String]]` Free tags at Workload level
* `Specific: [Yaml]` this is a custom section where we can put all the information strictly related to a specific technology or dependent from a standard/policy defined in the federated governance.


### Observability

Observability should be applied to each Outputport and is better to represent it as the Swagger of an API rather than something declarative like a Yaml, because it will expose runtime metrics and statistics.
Anyway is good to formalize what kind of information should be included and verified at deploy time for the observability API:

* Completeness: degree of availability of all the necessary information along the entire history
* DataProfiling: Volume, distribution of volume along time, range of values, column values distribution and other statistics
* Freshness: 
* Availability:
* DataQuality: DataQuality is something that should be customizable but well standardized by the Federated Governance.







