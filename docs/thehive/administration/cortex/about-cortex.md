# About Cortex

[Cortex](https://github.com/thehive-project/Cortex/) is an open-source analysis and response engine designed for SOCs, CSIRTs, and security researchers to automate threat intelligence gathering and incident response. Through its RESTful API, it allows teams to analyze observables—such as IP addresses, hashes, and domains—at scale and automate response actions.

This topic explains what Cortex is and the benefits of using it with TheHive.

!!! info "Not connected by default"
    By default, TheHive isn't connected to any Cortex server.

{!includes/cortex-support-thehive-55.md!}

## Cortex features

Cortex addresses two common challenges faced by SOCs, CSIRTs, and security researchers in threat intelligence, digital forensics, and incident response:

* Efficient observable analysis: Instead of manually querying multiple tools, Cortex enables centralized, automated analysis.
* Automated threat response: Teams can take active measures against threats and interact with other teams or external services.

Cortex offers the following features:

* Comprehensive analysis: Leverage a wide range of analyzers to enrich observables.
* Automated security response: Use responders to take action on alerts, cases, tasks, and observables.
* Scalability: Analyze large volumes of data efficiently.
* Multi-tenancy support: Manage multiple organizations with role-based access control.
* Performance optimization: Avoid redundant analysis with configurable caching.
* Rate limiting: Prevent excessive API usage by defining quotas per organization.

## Connecting Cortex to TheHive

!!! warning "Establishing a connection with Cortex"
    To connect to Cortex, you need an account and an API key on a Cortex server.

!!! info "Multiple Cortex instances"
    You can connect one or more Cortex instances to TheHive.

Connect TheHive to Cortex to gather intelligence on observables with analyzers and automate actions using responders:

* Analyzers enrich observables with detailed, contextual intelligence.
* Responders execute actions on cases, alerts, observables, tasks, and task logs to support investigations and incident response.

## Permissions

{!includes/administrator-access-manage-cortex-connection.md!}

## Next steps

* [Edit Cortex Connection Settings](edit-cortex-connection-settings.md)
* [Add a Cortex Server](add-a-cortex-server.md)
* [Remove a Cortex Server](remove-a-cortex-server.md)