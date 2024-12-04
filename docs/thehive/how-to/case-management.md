---
hide:
  - navigation
---

# Case Management

Case Management is the main purpose of TheHive. Handling incidents with predefined tasks or manually added tasks, assiging a case owner, adding observables and enrich them, looking for correlations with existing cases and alert, prioritising incidents and classifying them... those are few of the case management capabilities in TheHive.

![case-list](../images/how-to/case-management/case-list.png)
![case-preview](../images/how-to/case-management/case-preview.png)

## Creating case

Cases can be created in various ways:

- Manually from scratch
- Manually using a case template
- Importing a TheHive archive generated from another TheHive instance
- Converting one or many alerts into a incident

![case-create-options](../images/how-to/case-management/case-create-options.png)

### Creating a case from a case template

Case templates are models of cases, including predefined and documented tasks as well as custom fields

![case-create](../images/how-to/case-management/case-create.png)

### Applying case template on ongoing investigations

Case templates can also be used to enrich a case with additional tasks, tags and custom field during open investigations:

![case-apply-template](../images/how-to/case-management/case-apply-template.png)

## Anatomy of a case

A case in TheHive is defined by:

- A set of predefined properties: Title, tags, assignee, TLP, PAP, severity, description, status
- A set of custom fields (optional or mandatory) 
- A set of tasks, defined by a title, assignee, status, description and a set of task logs and attachements
- A set of observables, of predefined or custom data types, defined by a value, IoC and Sighted flags, sighting date, tags and a description
- A set of TTPs related to MITRE ATT&CK
- A set of attachments
- A set of pages as a wiki
- A set of comments

![case details](../images/how-to/case-management/case-details.png)

### Case tasks

![case-tasks](../images/how-to/case-management/case-tasks.png)

![case-task-details](../images/how-to/case-management/case-task-details.png)

### Case observables

![case-observables](../images/how-to/case-management/case-observables.png)
![case-observable-details](../images/how-to/case-management/case-observable-details.png)
![case-observable-analysis](../images/how-to/case-management/case-observable-analysis.png)
![case-observable-report](../images/how-to/case-management/case-observable-report.png)

### Case TTPs

![case-ttps](../images/how-to/case-management/case-ttps.png)

### Case timeline

![case-timeline-1](../images/how-to/case-management/case-timeline-1.png)
![case-timeline-2](../images/how-to/case-management/case-timeline-2.png)

### Case correlations

Case correlations with existing cases and alert are based on the common observables

![case-related-cases](../images/how-to/case-management/case-related-cases.png)
![case-similar-alerts](../images/how-to/case-management/case-similar-alerts.png)

## Case export

Cases can be exported as password protected archives or as a MISP event

![case-export](../images/how-to/case-management/case-export.png)