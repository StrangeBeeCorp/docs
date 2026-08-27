---
title: Home
---

<div>
  <figure align="center">
    <img src="./images/cortex-logo.png" width="600"/>  
    <figcaption>Cortex: Installation, operation, and user guides</figcaption>
  </figure>
</div>
<div>
  <p align="center">
    <a href="https://chat.thehive-project.org" target="_blank"><img src="https://img.shields.io/badge/chat-on%20discord-7289da.svg?sanitize=true&logo=discord" alt="Discord"></a>
    <a href="https://chat.thehive-project.org" target="_blank">
      <img src="https://img.shields.io/discord/779945042039144498" alt="Discord">
    </a>
    <a href="./LICENSE" target="_blank"><img src="https://img.shields.io/github/license/TheHive-Project/Cortex" alt="License"></a>
    <img src="https://img.shields.io/github/v/release/thehive-project/Cortex?style=flat&logo=git-lfs" alt="Version">         
  </p>
</div>


---

**Source Code**: [https://github.com/thehive-project/Cortex/](https://github.com/thehive-project/Cortex/){target=_blank}

**Website**: [https://www.strangebee.com](https://www.strangebee.com){target=_blank}

---

# Cortex 
Cortex solves two common problems frequently encountered by Security Operations Centers (SOCs), Computer Security Incident Response Teams (CSIRTs), and security researchers during threat intelligence, digital forensics, and incident response:

* How to analyze observables they have collected, at scale, by querying a single tool instead of several?
* How to actively respond to threats and interact with the constituency and other teams?

Thanks to its many analyzers and its RESTful API, Cortex simplifies observable analysis, particularly when called from [TheHive](https://www.strangebee.com/thehive/){target=_blank}, a Security Incident Response Platform (SIRP).

TheHive can also use Cortex responders to perform specific actions on alerts, cases, tasks, and observables collected during an investigation: send an email to the constituents, block an IP address at the proxy level, or notify team members that an alert needs urgent attention.

Cortex includes many features:

* Manage multiple organizations (multi-tenancy)
* Manage users per organization and role
* Configure per-organization analyzer and responder settings
* Set rate limits to avoid consuming all your quotas at once
* Cache analysis results to skip re-running an analyzer on the same observable within a set timespan (10 minutes by default, adjustable per analyzer)

## Installation and configuration guides
[Cortex Installation Methods](./download/index.md) lists the available ways to install Cortex—packages, Docker, or Kubernetes—and links to the corresponding step-by-step guide for each.

All aspects of the configuration are also detailed in a dedicated section.

## User guides

The [first connection](user-guides/first-start.md) to the application requires several actions.

Cortex supports different roles for users. Refer to [User roles](user-guides/roles.md) for more details.

## License

Cortex is open source, free software released under the Affero General Public License ([AGPL](https://github.com/TheHive-Project/Cortex/blob/master/LICENSE){target=_blank}). [StrangeBee](https://strangebee.com){target=_blank} is committed to keeping Cortex free and open source over the long term.

## Updates and community discussions

StrangeBee regularly posts information, news, and updates on several communication channels:

:fontawesome-brands-twitter: [StrangeBee Twitter account](https://twitter.com/StrangeBee){target=_blank} / [TheHive Project Twitter account](https://twitter.com/thehive_project){target=_blank}

:fontawesome-brands-mastodon:  [TheHive Project Mastodon account](https://infosec.exchange/@TheHive_Project){target=_blank} / [StrangeBee Mastodon account](https://infosec.exchange/@StrangeBee){target=_blank}

:fontawesome-brands-wordpress: [blog at StrangeBee](https://blog.strangebee.com){target=_blank}

:fontawesome-brands-discord: [Join the user community on Discord](https://chat.thehive-project.org){target=_blank}

## Professional support

![StrangeBee](./images/strangebee.png){: align=left width=120 }
Since 2018, [StrangeBee](https://www.strangebee.com){target=_blank} has fully developed and maintained Cortex. If you need dedicated assistance, StrangeBee also provides professional services and support.