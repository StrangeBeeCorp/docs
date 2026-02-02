# About TheHive Portal

<!-- md:version 5.6 --> <!-- md:license Platinum -->

TheHive Portal enables controlled information sharing between Security Operations Center (SOC) teams and external stakeholders, such as HR, Legal, or clients. This feature provides a secure gateway for non-security users to access specific case information and interact with it while maintaining strict data confidentiality controls.

## Overview

TheHive Portal serves as a dedicated interface that bridges the gap between internal security operations and external stakeholders who need visibility into specific cases. Through this portal, SOC teams maintain complete control over what information external users can access and act on, ensuring that sensitive security data remains protected while enabling necessary collaboration.

The portal operates on a principle of selective visibility—SOC analysts explicitly designate which cases and which elements are accessible to external users. This granular control mechanism ensures that only relevant and approved information reaches external stakeholders, while internal discussions, sensitive findings, and confidential data remain within the SOC environment.

Organizations can create an unlimited number of external user accounts, allowing them to scale their external collaboration needs without restrictions.

## Key capabilities

### Controlled information sharing

SOC analysts can selectively mark specific case components as external:

* Case details
* Individual comments within case discussions
* Case attachments

External users can contribute to cases based on their profile permissions:

* Creating new cases
* Adding comments to existing cases
* Uploading attachments to existing cases
* Adding observables to existing cases

### Secure access management

External users receive portal access through a dedicated URL sent via email upon account creation. Each external user account is associated with specific cases and has visibility limited to explicitly shared information. The portal maintains a clear separation between internal and external data views, preventing unauthorized access to sensitive information.

### Communication flow management

The portal facilitates bidirectional collaboration between external stakeholders and SOC teams. External users can contribute through comments, attachments, observable submissions, and case reporting. SOC analysts maintain complete control by determining what information is shared externally—whether cases, attachments, comments, or updates—while keeping sensitive investigation details and methodologies internal.

## Use cases

### Client collaboration

When working with clients on security incidents affecting their infrastructure, SOC teams can share relevant case updates, findings, and recommendations through the portal. Clients gain visibility into the investigation progress without accessing sensitive detection methods or internal security procedures.

### Cross-department coordination

For incidents requiring input from non-security departments such as HR or Legal, the portal provides these teams with necessary case information while protecting technical security details. This enables efficient collaboration on incidents with broader organizational impact.

### Third-party vendor communication

During investigations involving external vendors or partners, the portal allows secure information exchange without granting access to the main TheHive platform. Vendors can view relevant findings and provide necessary information through the controlled portal interface.

## Actions

### Setting up portal access

Portal activation requires initial configuration of user accounts, profiles, and permissions. Administrators must create external user accounts and configure appropriate access levels, enabling both external stakeholders to access the portal and SOC analysts to share cases with them.

For complete setup instructions, see [Set Up TheHive Portal Access](set-up-thehive-portal-access.md).

### Sharing cases and their elements

When cases are shared with external users, SOC teams control exactly what information becomes visible through the portal:

* Cases: Analysts can grant external users access to specific cases. However, external users can't be assigned as case owners—assignment remains restricted to internal TheHive users. See [Share a Case with External Users](../../user-guides/analyst-corner/cases/case-thehive-portal/share-case-external-users.md) for instructions.

* Comments: Comments aren't automatically shared when a case is shared. Each comment requires explicit marking as external to be visible in the portal. See [Control Case Comment Access for External Users](../../user-guides/analyst-corner/cases/case-thehive-portal/control-case-comment-access-thehive-portal.md) for instructions.

* Attachments: Like comments, attachments must be individually marked as external for portal visibility. See [Share an Attachment with External Users](../../user-guides/analyst-corner/cases/attachments/share-an-attachment-case-alert.md#share-an-attachment-with-external-users) for instructions.

* Observables: Observables created by analysts remain private and can't be shared with external users. Only observables created by external users themselves are visible in the portal.

### Using the portal

External users with the appropriate permissions can:

* [View shared cases](../../thehive-portal/find-a-case-thehive-portal.md)
* Add [comments](../../thehive-portal/add-comment-cases-shared-thehive-portal.md), [attachments](../../thehive-portal/add-attachment-cases-shared-thehive-portal.md), and [observables](../../thehive-portal/add-observable-cases-shared-thehive-portal.md) to existing cases
* [Create new cases](../../thehive-portal/create-case-thehive-portal.md)

External users can't:

* Edit existing case details or elements
* Delete cases

## Visual indicator

Cases shared with external users display the :fontawesome-solid-users: symbol or show an explicit message to help identify which cases have external visibility.

## Audit logs

TheHive Portal activities aren't displayed within the portal itself. All actions performed by external users through the portal are recorded in the main TheHive interface, appearing in the **History** tab and the [Live Feed](../../user-guides/analyst-corner/about-live-feed.md).

<h2>Next steps</h2>

* [Set Up TheHive Portal Access](set-up-thehive-portal-access.md)
* [Share a Case with External Users](../../user-guides/analyst-corner/cases/case-thehive-portal/share-case-external-users.md)
* [Revoke Case Access for External Users](../../user-guides/analyst-corner/cases/case-thehive-portal/revoke-case-access-external-users.md)
* [Control Case Comment Access for External Users](../../user-guides/analyst-corner/cases/case-thehive-portal/control-case-comment-access-thehive-portal.md)
* [Share an Attachment from a Case or an Alert](../../user-guides/analyst-corner/cases/attachments/share-an-attachment-case-alert.md#share-an-attachment-with-external-users)
* [Remove External User Access to a Case Attachment](../../user-guides/analyst-corner/cases/case-thehive-portal/remove-case-attachment-access-thehive-portal.md)