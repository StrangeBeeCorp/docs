# MISP

## Introduction

!!! Info
    An account and an API key are required on a MISP server to define a connection.

* One or more MISP instances can be connected to TheHive.
* For each one:
  * MISP events can be **imported** as Alerts in TheHive. A set of filter can refine the imported events
  * Observables flagged as IOCs in a Case can be **exported** in a new event in MISP


## Manage MISP connections

### Add a new MISP server

![](../images/administration-guides/platform-management-misp-1.png)

Specify:

* A name for this connection, for example: `misp`[^1]
* The URL of MISP server to connect with, for example: ` https://misp.mycompany.com` 
* The API key of the dedicated MISP account
* The purpose of this connection: *Import only*, *Export Only*, or both, *Import & Export*
* Proxy settings if required for TheHive to connect with MISP


### Advanced settings

![](../images/administration-guides/platform-management-misp-2.png)

By default, **ALL** organizations in TheHive benefit from this connection.
Additionaly, 2 options are available:

* Make this connection **available ONLY** to a subset of existing organizations in TheHive
* Make this connection **unavailable** to a subset of existing organizations in TheHive

Additional options let you:

* Define *tags* that will be appended to Alerts when importing MISP events
* When exporting IOCs in MISP, also export tags from the Case in the new MISP event
* When exporting IOCs in MISP, also export tags from the observables


### Filters

![](../images/administration-guides/platform-management-misp-3.png)

When importing MISP events as TheHive *Alerts*, several options are available:

* Define the maximum age of a MISP event allowed to be imported
* Specify a list of organizations *owner* of the MISP events allowed to be imported
* Specify a list of organizations *owner* of the MISP events that are not allowed to be imported
* Define a limit for the number of attributes (~observables) included in the MISP event to import it
* Specify a list of tags that should exist in the MISP event to import it
* Specify a list of tags that should exist in the MISP event to ignore it

### Delete a Connection

![](../images/administration-guides/platform-management-misp-4.png)

[^1]:
    If you have several connections, this is useful to give explicit names

    ---
    hide:
      - navigation
    ---
    
    # MISP Integration
    
    TheHive in strongly integrated with MISP (Malware Information Sharing Platform).
    
    Using it's connector, TheHive has the capabilities to:
    
    - Receive MISP events and ingest them as alerts
    - Send TheHive `Cases` to MISP as events
    
    This integration is highly configurable and allows TheHive to synchronize with one or multiple MISP servers.
    
    ## Configuration
    
    To add or configure a MISP server, open the Admin organization page (1), go to the Platform Management menu (2) and navigate to the MISP tab (3).
    
    Click the "+" button to add a new MISP server (4).
    
    ![MISP Connector configuration](../images/how-to/misp/configure_misp.png)
    
    ### General settings
    
    This configuration is common to all MISP servers connected to TheHive.
    
    - Interval: define the time interval between each events polling from TheHive to MISP
    
    ### Servers General settings
    
    While clicking on add or edit a MISP server, a drawer will appear where you can define the following settings:
    
    - Server name: MISP server name to display within TheHive
    - Server URL: URL of the MISP server
    - API Key: secret with sufficient permission to get & create MISP events
    - Purpose: Chose the synchronization way; Import: only import events from MISP to TheHive. Export: only exports cases from TheHive to MISP. Import and Export allow both ways synchronization
    
    ![MISP Server General Settings](../images/how-to/misp/misp_general_settings.png)
    
    ### Server Proxy Settings
    
    Proxy settings should be set only if a proxy is required to reach the MISP server from TheHive.
    
    - Type of protocol: Define on which protocol (HTTP/HTTPS) the proxy is listening
    - Address: Define the proxy address
    - Authentication: If the proxy require authentication, check this box. Username and password to authenticate must be provided when this box is checked.
    - Do not check certificate authority: Do not verify the certificate authority when communicating with the proxy (not recommended, for HTTPS connection only)
    - Disable hostname verification: Do not verify the hostname match with the certificate hostname.
    
    ![MISP Server Proxy Settings](../images/how-to/misp/misp_proxy_settings.png)
    
    ### Server Advanced Settings
    
    - Chose the filter on TheHive organizations: For each server, you can define which TheHive organization(s) to include or exclude of the synchronization (excluded or not included organizations will not receive the MISP events as `Alerts`)
    - Tags: Append one or several tags to each MISP event ingested as `Alert` 
    - Export case tags: If enabled, the export will include the `Case` tags. 
    - Export observables tags: If enabled, the exported `Observables` will include the `Observables` tags.
    
    ![MISP Server Advanced Settings](../images/how-to/misp/misp_advanced_settings.png)
    
    ### Server Filter Settings
    
    This section allows to define filters for MISP events import. 
    
     - Maximum age: define the maximum age (based on creation date) for an event to be imported in TheHive.
     - Organizations to include: Import only events created by the MISP organization(s) defined in this field.
     - Organizations to exclude: Import only events NOT created by the MISP organization(s) defined in this field.
     - Maximum number of attributes: Define a maximum number of MISP attributes (observables) per event to import. 
     - List of allowed tags: Import only events that contains the tags defined in this field
     - Prohibited tags list: Import only events that DON'T contains the tags defined in this field
    
    ![MISP Server Filters Settings](../images/how-to/misp/misp_filter_settings.png)