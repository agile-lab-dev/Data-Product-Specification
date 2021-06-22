# Data-Product-Specification

This repository wants to define an open specification to define data products with the following principles in mind:
- DP as an indipendent unit of deployment
- Technology indipendence
- extensibility

With an open specification will be possible to create services for automatic deployment and interoperable components to build a dat amesh platform.


# Data Product structure

The DP is composed by a general section with DP level information and four sub-structures:
* Environment: where the DP will be deployed, containing all the specific information of the physical environment.
* Output Ports: representing all the different interfaces of the DP to expose the data
* Workloads: Internal jobs/processes to feed the DP and to perform housekeeping ( GDPR, regulation, audit, data quality, etc )
* Observability: provides transparency to the data conusmer about how the DP is currently working. this is not declarative, but exposing runtime data.

Each DP Trait ( Outputport, workload, observability ) will have a well defined and fixed structure and a specific one to handle technology specific stuff.
The fixed structure must be technology agnostic.


### Environment



### Output Ports



### Workloads



### Observability


