# About Cortex

[Cortex](https://github.com/thehive-project/Cortex/) is an open-source analysis and response engine designed for SOCs, CSIRTs, and security researchers to automate threat intelligence gathering and incident response. Through its RESTful API, it allows teams to analyze observables—such as IP addresses, hashes, and domains—at scale and automate response actions.

This topic explains what Cortex is and the benefits of using it with TheHive.

!!! note "Not connected by default"
    By default, TheHive isn't connected to any Cortex server.

!!! info "Cortex support"
    <!-- md:version 5.5 --> Cortex 3.1.5 and earlier are no longer supported since version 5.5.

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

!!! warning "Cortex connection requirements"
    Establishing a connection with Cortex requires an existing account and a valid API key on a Cortex server.

!!! info "Support for multiple Cortex instances"
    TheHive supports connecting to one or more Cortex instances simultaneously. Connecting to multiple instances requires a paid license.

[Connect TheHive to Cortex](add-a-cortex-server.md) to gather intelligence on observables with analyzers and automate actions using responders:

* Analyzers enrich observables with detailed, contextual intelligence, generating a report with the results.
* Responders execute actions on cases, alerts, observables, tasks, and task logs to support investigations and incident response, generating a report with the results.

## Permissions

{!includes/administrator-access-manage-cortex-connection.md!}

<h2>Next steps</h2>

* [Add a Cortex Server](add-a-cortex-server.md)
* [Remove a Cortex Server](remove-a-cortex-server.md)
* [Import Analyzer Templates](../../administration/analyzer-templates/import-analyzer-templates.md)
* [Customize an Analyzer Template](../../administration/analyzer-templates/customize-an-analyzer-template.md)