---
# hide:
#   - navigation
#   - toc
template: home.html

hero:
  title: 'TheHive technical *documentation*'
  text: Your essential guide to TheHive and Cortex
  links:
    - text: Get started
      url: '/thehive/overview/'
    - text: Download TheHive
      url: '/thehive/download/'
      style: primary

sections:
  title: 'Learn how to install, configure, maintain and use TheHive and Cortex'
  text: 'Follow our guides to get the job done—fast and right.'
  anchors: ''
  data:
    - title: 'Analyst corner'
      text: 'I want to triage alerts and investigate cases.'
      icon: assets/images/docs-analyst.png
      anchor:
        name: 'Analyst'
        href: 'analyst'
      groups:
        - title: 'Triage alerts'
          links: 
            - text: 'Create custom alert views'
              url: '/thehive/user-guides/analyst-corner/views/create-a-custom-view/'
            - text: 'Analyze observables to assess potential threats'
              url: '/thehive/user-guides/analyst-corner/cases/search-for-cases/find-an-observable/'
            - text: 'Cross-check with similar alerts and cases'
              url: '/thehive/user-guides/analyst-corner/cases/find-similar-alerts-cases/'
            - text: 'Comment on alerts'
              url: '/thehive/user-guides/analyst-corner/alerts/comment-on-alert/'
            - text: 'Convert alerts into cases when investigation is needed'
              url: '/thehive/user-guides/analyst-corner/alerts/create-a-case-from-an-alert/'
            - text: 'Close alerts if no further action is required'
              url: '/thehive/user-guides/analyst-corner/alerts/close-an-alert/'

        - title: 'Investigate cases'
          links: 
            - text: 'Create custom case views'
              url: '/thehive/user-guides/analyst-corner/views/create-a-custom-view/'
            - text: 'Access case details quickly'
              url: '/thehive/user-guides/analyst-corner/preview-vs-detail-view/'
            - text: 'Share a case with external users'
              url: '/thehive/user-guides/analyst-corner/cases/case-thehive-portal/share-case-external-users/'
            - text: 'Update severity, TLP and PAP as needed'
              url: '/thehive/user-guides/analyst-corner/cases/change-case-classification-settings/'
            - text: 'Save logs for mandatory tasks'
              url: '/thehive/user-guides/analyst-corner/tasks/create-a-task-log/'
            - text: 'Add observables'
              url: '/thehive/user-guides/analyst-corner/cases/observables/add-an-observable/'
            - text: 'Run analyzers on observables'
              url: '/thehive/user-guides/analyst-corner/cases/observables/run-analyzers-on-an-observable/'
            - text: 'Trigger responders'
              url: '/thehive/user-guides/analyst-corner/cases/observables/run-responders-on-an-observable/'
            - text: 'Mark observables as IOCs if suspicious'
              url: '/thehive/user-guides/analyst-corner/cases/observables/update-an-observable-status/'
            - text: 'Document attack techniques'
              url: '/thehive/user-guides/analyst-corner/cases/ttps/add-ttps/'
            - text: 'Comment on cases'
              url: '/thehive/user-guides/analyst-corner/cases/comment-on-case/'
            - text: 'Cross-check with similar alerts and cases'
              url: '/thehive/user-guides/analyst-corner/cases/find-similar-alerts-cases/'
            - text: 'Close the case'
              url: '/thehive/user-guides/analyst-corner/cases/close-a-case/'
            - text: 'Save a full case report'
              url: '/thehive/user-guides/analyst-corner/cases/case-reports/save-download-a-case-report/'
            - text: 'Document actions taken during the investigation'
              url: '/thehive/user-guides/knowledge-base/create-a-case-page/'
            - text: 'Transfer key insights to the Knowledge Base'
              url: '/thehive/user-guides/knowledge-base/create-a-knowledge-base-page/'

    - title: 'Manager corner'
      text: 'I want to standardize and secure data, and track my team’s activity.'
      icon: assets/images/docs-manager.png
      anchor:
        name: 'Manager'
        href: 'manager'   
      groups:
        - title: 'Standardize and secure data'
          links: 
            - text: 'Create case templates'
              url: '/thehive/user-guides/organization/configure-organization/manage-templates/case-templates/create-a-case-template/'
            - text: 'Activate taxonomy tags'
              url: '/thehive/administration/taxonomies/activate-deactivate-a-taxonomy/'
            - text: 'Create observable types'
              url: '/thehive/administration/observable-types/create-an-observable-type/'
            - text: 'Manage case and alert statuses'
              url: '/thehive/administration/status/create-a-status/'
            - text: 'Import analyzer templates'
              url: '/thehive/administration/analyzer-templates/import-analyzer-templates/'
            - text: 'Import attack patterns'
              url: '/thehive/administration/ttps/add-a-catalog/'
            - text: 'Restrict visibility for sensitive cases'
              url: '/thehive/user-guides/analyst-corner/cases/case-visibility/restrict-visibility-case/'
        - title: 'Track team activity'
          links: 
            - text: 'Create custom case and alert views'
              url: '/thehive/user-guides/analyst-corner/views/create-a-custom-view/'
            - text: 'Review case timelines to track investigation progress'
              url: '/thehive/user-guides/analyst-corner/cases/case-timelines/view-case-timeline/'
            - text: 'Read case reports'
              url: '/thehive/user-guides/analyst-corner/cases/attachments/download-an-attachment-case-alert/'
            - text: 'Understand KPIs'
              url: '/thehive/user-guides/key-performance-indicators/key-performance-indicators/'
            - text: 'Evaluate alert metrics on dashboards'
              url: '/thehive/user-guides/key-performance-indicators/measure-alert-management-performance/'
            - text: 'Evaluate case metrics on dashboards'
              url: '/thehive/user-guides/key-performance-indicators/measure-case-management-performance/'
            - text: 'Comment on cases and alerts to provide feedback'
              url: '/thehive/user-guides/analyst-corner/cases/comment-on-case/'

    - title: 'DevSecOps corner'
      text: 'I want to automate tasks, manage integrations and streamline data enrichment.'
      icon: assets/images/docs-devSecOps.png
      anchor:
        name: 'DevSecOps'
        href: 'devsecops'
      groups:
        - title: 'Generate alerts in TheHive'
          links: 
            - text: 'Connect mailboxes to automatically create alerts from emails'
              url: '/thehive/administration/email-intake-connector/connect-a-mailbox/'
            - text: 'Link a MISP instance for threat intel ingestion'
              url: '/thehive/administration/misp-integration/connect-a-misp-server/'
            - text: 'Set up an alert feeder to pull alerts from external systems'
              url: '/thehive/user-guides/organization/configure-organization/manage-feeders/create-a-feeder/'
        - title: 'Automate repetitive actions'
          links: 
            - text: 'Configure SMTP to enable email sending from TheHive'
              url: '/thehive/administration/smtp/'
            - text: 'Set up notifications to push data to external tools'
              url: '/thehive/user-guides/organization/configure-organization/manage-notifications/create-a-notification/'
            - text: 'Write functions to automate workflows based on events'
              url: '/thehive/user-guides/organization/configure-organization/manage-functions/create-a-function/'
            - text: 'Configure analyzers to automatically enrich observables'
              url: '/cortex/api/how-to-create-an-analyzer/'
            - text: 'Configure responders to trigger automated response actions'
              url: '/cortex/api/how-to-create-a-responder/'

    - title: 'Infra Engineer corner'
      text: 'I want to deploy, configure and maintain TheHive—and understand its API.'
      icon: assets/images/docs-infraEngineer.png
      anchor:
        name: 'Infra Engineer'
        href: 'infraengineer'
      groups:
        - title: 'Install and configure TheHive'
          links: 
            - text: 'Choose your installation method'
              url: '/thehive/installation/installation-methods/'
            - text: 'Review system requirements'
              url: '/thehive/installation/system-requirements/'
            - text: 'Review software requirements'
              url: '/thehive/installation/software-requirements/'
            - text: 'Install TheHive on Linux'
              url: '/thehive/installation/installation-guide-linux-standalone-server/'
            - text: 'Use the one-command install'
              url: '/thehive/installation/automated-installation-script-linux/'
            - text: 'Deploy with Docker'
              url: '/thehive/installation/docker/'
            - text: 'Set up a cluster on Linux'
              url: '/thehive/installation/deploying-a-cluster/'
            - text: 'Deploy on Kubernetes'
              url: '/thehive/installation/kubernetes/'
            - text: 'Activate the license'
              url: '/thehive/installation/activate-license/'
            - text: 'Perform version upgrades'
              url: '/thehive/installation/upgrade-from-5.x/'
        - title: 'Configure organizations'
          links: 
            - text: 'Complete the initial login'
              url: '/thehive/administration/first-start/'
            - text: 'Assign users with the right permissions'
              url: '/thehive/administration/organizations/add-remove-an-existing-user-account-from-an-organization/'
            - text: 'Set up LDAP integration'
              url: '/thehive/administration/authentication/ldap/'
            - text: 'Configure authentication methods'
              url: '/thehive/administration/authentication/configure-authentication/'
            - text: 'Connect Cortex for analyzers and responders'
              url: '/thehive/administration/cortex/add-a-cortex-server/'
            - text: 'Configure external user access'
              url: '/thehive/administration/thehive-portal/set-up-thehive-portal-access/'
        - title: 'Maintain TheHive'
          links: 
            - text: 'Perform Cassandra cluster operations'
              url: '/thehive/operations/cassandra-cluster/'
            - text: 'Perform backups and restore data'
              url: '/thehive/operations/backup-restore/overview/'
            - text: 'Set up monitoring tools'
              url: '/thehive/operations/monitoring/'
            - text: 'Diagnose and resolve issues'
              url: '/thehive/operations/troubleshooting/'
        - title: 'Use the API'
          links: 
            - text: 'Access and use the API documentation'
              url: '/thehive/api-docs/'
            - text: 'Use the Python API client'
              url: 'https://github.com/thehive-project/thehive4py'
            - text: 'Use the Go API client'
              url: 'https://github.com/StrangeBeeCorp/thehive4go'
        - title: 'Integrate with the MCP server'
          links: 
            - text: 'Get started with the MCP server'
              url: 'https://github.com/StrangeBeeCorp/TheHiveMCP'

    - title: 'External User'
      text: 'I need to access shared cases and collaborate with the SOC team.'
      icon: assets/images/docs-infraEngineer.png
      anchor:
        name: 'External User'
        href: 'externaluser'
      groups:
        - title: 'Get started with TheHive Portal'
          links: 
            - text: 'Understand security case terminology'
              url: '/thehive/thehive-portal/glossary-thehive-portal/'
            - text: 'Activate your TheHive Portal account'
              url: '/thehive/thehive-portal/activate-thehive-portal-account/'
            - text: 'Find and navigate security issues'
              url: '/thehive/thehive-portal/find-a-case-thehive-portal/'
            - text: 'Manage your account settings'
              url: '/thehive/thehive-portal/manage-account-settings-thehive-portal/'
        - title: 'Collaborate on security cases'
          links: 
            - text: 'Report new security issues'
              url: '/thehive/thehive-portal/create-case-thehive-portal/'
            - text: 'Share threat indicators'
              url: '/thehive/thehive-portal/add-attachment-cases-shared-thehive-portal/'
            - text: 'Upload supporting documents'
              url: '/thehive/thehive-portal/add-attachment-cases-shared-thehive-portal/'
            - text: 'Post comments'
              url: '/thehive/thehive-portal/add-comment-cases-shared-thehive-portal/'

---

# Welcome to TheHive 5 documentation website

For full documentation visit [mkdocs.org](https://www.mkdocs.org).