# How to Connect a Mailbox

This topic provides step-by-step instructions for connecting a [mailbox](about-email-intake-connectors.md) in TheHive.

{!includes/administrator-access-manage-email-intake-connectors.md!}

<h2>Procedure</h2>

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/connectors-tab-go-to.md!}

3. {!includes/email-intake-tab-go-to.md!}

4. Enter the time interval between refresh attempts. This setting applies to all connected mailboxes.

5. Select :fontawesome-solid-plus:.

6. In the **Add intake configuration** drawer, configure your email intake connector by following these steps:

    === <!-- md:license Platinum --> "Google Workspace"

        !!! warning "Prerequisites"
            You must have administrator access to the Google Cloud Console, with the necessary permissions to create projects and configure OAuth 2.0 credentials.
        
        1. Go to the [Google Admin Console](https://console.cloud.google.com/welcome).

        2. Select **APIs & Services**.

            ![Google Cloud Console APIs and services](/thehive/images/administration-guides/google-cloud-console-apis-services.png)

        3. Select **Create project**.

            ![Google Cloud Console Create project](/thehive/images/administration-guides/google-cloud-platform-create-project.png)

    === <!-- md:license Gold --> <!-- md:license Platinum --> "IMAP server"

    === <!-- md:license Platinum --> "Microsoft 365"
    
    === <!-- md:version 5.5 --> <!-- md:license Platinum --> "Microsoft Graph API"


<h2>Next steps</h2>