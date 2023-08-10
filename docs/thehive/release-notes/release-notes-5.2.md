# Release Notes of 5.2 series

!!! danger
    The 5.2 release comes with some changes on the database schema that can't be reversed. Please make sure to make a backup of your database before upgrading.

    This release also comes with some breaking changes, please review them below

!!! info
    An [upgrade guide](../setup/installation/upgrade-from-5.0.x.md) is available to help you migrate from TheHive 5.x

## 5.2.2 - 9rd August 2023

### Fixes

- **Infrastructure:**
    - Fix to create attachment directory if it doesn't exist when TheHive starts up
    - A change in authentication configuration is now applied immediately, without the need to restart the platform.
    - The http context is only present once when you configure a SAML authentication server like Okta

- **API:**
    - Improve performances of notifications making http requests and limit the number of open processes

- **UI:**
    - The name field is indicated as required in the endpoint configuration.
    - Improved loading time for the list of observables


### Main features
- **Alerts, Cases and tasks**
    - Cancelled tasks are now displayed in a case's task list and in the task menu. It will also be possible to see them in progress, and a quick filter on canceled tasks has been added.
    - The severity component of a case and the case number have been split. A new severity component has been created and standardized in the application
        <figure markdown>
        ![Severity component](./images/release52-severity.png){ width="450"}
        </figure>
    - Alert comments are visible in case they have been imported
    - Added the ability to copy case number, case title and alert title to the clipboard
    - Add an icon to display alerts, cases and unassigned tasks, and trigger a quick filter on lists
    - Added ability to perform bulk actions on TTPs
    - It is possible to obtain the URL of a case page so that it can be shared


**Administration** 

- Improved case report templates
    - Added the ability to add a title to a case report widget
    - It is possible to duplicate a case report template
    - It is possible to duplicate a case report template widget
- Notifications can now be triggered when an alert closes
- We have uniformized the labels for PAP, TLP and Severity, in making so, the template helpers severityLabel, tlpLabel and papLabel available in notifications now return the label in upper case
- The application will notify users by email when their account is modified by them or an admin in the following cases:
    - Modification of email address
    - Modification of password
    - Password reset



## 5.2.1 - 11rd Jully 2023

### Fixes

**UI:**

- Fix slowness problem on custom tag autocompletion

## 5.2.0 - 6st July 2023

### Breaking changes

!!! Warning
    - The transition to TLP 2.0 involves changing the ID of the TLP:RED value and adding TLP:AMBER+STRICT. The updated assignments are: 
        - TLP:CLEAR = 0
        - TLP:GREEN = 1
        - TLP:AMBER = 2
        - **New:** TLP:AMBER+STRICT = 3
        - **Change:** TLP:RED = 4 (previously = 3)
    - Please make sure to update your dashboard and any integrations that rely on these values.

### Main features

- **What's new in templates**
    - **Report template:** Boost your reporting with Case Reporting

        Create customized, high-impact reports with Case Reporting. Use a variety of dynamic widgets such as text, images, tables and lists. Relevant case data (tasks, observables, etc.) are automatically integrated. Export your reports in HTML and Markdown.
        
        See [dedicated page](../user-guides/organisation/templates/report-templates.md) for more information (requires platinum license)

    - **Page template:** Customize and organize your cases pages

        Guide your collaborators in writing the documentation for a case by importing pages directly from the template to provide all the necessary elements and improve processes.

        See [dedicated page](../user-guides/organisation/templates/page-templates.md) for more information (requires platinum license)

    <figure markdown>
    ![Case reporting](./images/release52-case-reporting.png){ width="450"}
    </figure>

- **What's new in alerts:** 
    - **Alert assignment**

        Assign alerts to members of the organization. Filter to find alerts assigned to a user.

    - **Triggers for alerts in notifications**

        Benefit from new alert triggers to trigger your notifications.
    
    <figure markdown>
    ![Assign alerts](./images/release52-alerts.png){ width="450"}
    </figure>

- **Transition to TLP 2.0**

    Our compatibility with the new TLP 2.0 standard is a key advantage for your business. Use the new TLP 2.0 terminologies to strengthen your cases, dashboards and reports.

    <figure markdown>
    ![TLP 2.0](./images/release52-TLP.png){ width="150"}
    </figure>

- **Notifiers Redis and Microsoft Teams**

    With the new Redis Notifiers and Microsoft Teams, strengthen your communication. Keep your teams informed in real time about the progress of your processes.

    <figure markdown>
    ![Notifiers MS and Redis](./images/release52-notifiers.png){ width="450"}
    </figure>

- **List Export**

    Export your list information as you wish in JSON or CSV format. Apply filters and/or select items for export to keep only what you need. Exploit exported data according to your specific needs.

    <figure markdown>
    ![List export](./images/release52-list-export.png){ width="450"}
    </figure>

- **Two-factor authentication activation indicator**

    Identify users with two-factor authentication enabled. Enhance access security and promote two-factor authentication adoption.

- **Add your own certificate authority on your servers**

    Use your own CA for enhanced server security. Manage your own CA for complete control over certificate issuance, revocation, and management.

### Other features

- PAP:WHITE changes to PAP:CLEAR
- Add new observable to alert
- Custom field mandotory indicator added
- Improve markdown editor and library change
- Improve validation errors in api
- Improve performance of NotificationActor
- Add button to test MISP/Cortex configuration
- API could understand "last x days" filters

### Fixes

- Fixed some display problems on custom fields
