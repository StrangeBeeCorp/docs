---
title: Home
---

<div>
  <figure align="center">
    <img src="./images/cortex-logo.png"width="600"/>  
    <figcaption>Cortex : Installation, operation and user guides</>
  </figure>
</div>
<div>
  <p align="center">
    <a href="https://chat.thehive-project.org" target"_blank"><img src="https://img.shields.io/badge/chat-on%20discord-7289da.svg?sanitize=true&logo=discord" alt="Discord"></a>
    <a href="https://chat.thehive-project.org" target"_blank">
      <img src="https://img.shields.io/discord/779945042039144498" alt="Discord">
    </a>
    <a href="./LICENSE" target"_blank"><img src="https://img.shields.io/github/license/TheHive-Project/Cortex" alt="License"></a>
    <a href><img src="https://img.shields.io/github/v/release/thehive-project/Cortex?style=flat&logo=git-lfs" alt="Version"></a>          
  </p>
</div>


---

**Source Code**: [https://github.com/thehive-project/Cortex/](https://github.com/thehive-project/Cortex/)

**Website**: [https://www.strangebee.com](https://www.strangebee.com)

---


# Cortex 
Cortex solves two common problems frequently encountered by SOCs, CSIRTs and security researchers in the course of threat intelligence, digital forensics and incident response:

- How to analyze observables they have collected, **at scale, by querying a single tool** instead of several?
- How to actively respond to threats and interact with the constituency and other teams?

Thanks to its many _analyzers_ and to its RESTful API, Cortex makes observable analysis a breeze, particularly if called from [TheHive](https://www.strangebee.com/thehive/), the highly popular, Security Incident Response Platform (SIRP). 

TheHive can also leverage Cortex _responders_ to perform specific actions on alerts, cases, tasks and observables collected in the course of the investigation: send an email to the constituents, block an IP address at the proxy level, notify team members that an alert needs to be taken care of urgently and much more.

Many features are included with Cortex: 

* Manage multiple organizations (i.e multi-tenancy)
* Manage users per organizations and roles
* Specify per-org analyzer & responder configuration
* Define rate limits: avoid consuming all your quotas at once
* Cache: an analysis is not re-executed for the same observable if a given analyzer is called on that observable several times within a specific timespan (10 minutes by default, can be adjusted for each analyzer).


## Installation and configuration guides
[This documentation](./installation-and-configuration/index.md) contains step-by-step installation instructions for Cortex for different operating systems as well as corresponding binary archives. 

All aspects of the configuration are aslo detailled in a dedicated section.
s
## User guides
The [first connection](user-guides/first-start.md) to the application requires several actions. 

Cortex supports differents roles for users. Refer to [User roles](user-guides/roles.md) for more details.


## License
Cortex is an open source and free software released under the [AGPL](https://github.com/TheHive-Project/Cortex/blob/master/LICENSE) (Affero General Public License). We, [StrangeBee](https://strangebee.com), are committed to ensure that Cortex will remain a free and open source project on the long-run.

## Updates and community discussions
Information, news and updates are regularly posted on several communication channels:

:fontawesome-brands-twitter: [StrangeBee Twitter account](https://twitter.com/StrangeBee) / [TheHive Project Twitter account](https://twitter.com/thehive_project)

:fontawesome-brands-mastodon:  [TheHive Project Mastodon account](https://infosec.exchange/@TheHive_Project) / [StrangeBee Mastodon account](https://infosec.exchange/@StrangeBee)

:fontawesome-brands-wordpress: [blog at StrangeBee](https://blog.strangebee.com)

:fontawesome-brands-discord: [Join users community on Discord](https://chat.thehive-project.org)


## Professional support

![StrangeBee](./images/strangebee.png){: align=left width=120 }
Since 2018, Cortex is fully developped and maintained by [StrangeBee](https://www.strangebee.com). Should you need specific assistance, be aware that StrangeBee also provides professional services and support.

