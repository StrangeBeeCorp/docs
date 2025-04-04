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
        
        ### Step 1: Create a project in the Google Cloud Console
        
        1. Go to the [Google Admin Console](https://console.cloud.google.com/welcome).

        2. Select **APIs & Services**.

            ![Google Cloud Console APIs and services](/thehive/images/administration-guides/google-cloud-console-apis-services.png)

        3. Select **Create project**.

            ![Google Cloud Console Create project](/thehive/images/administration-guides/google-cloud-platform-create-project.png)

        4. Enter a name for the project, an organization, and a location.

        5. Select **Create**.

        ### Step 2: Configure OAuth consent

        1. Select **OAuth consent screen** from the left pane.

            ![OAuth consent screen](/thehive/images/administration-guides/google-cloud-platform-oauth-consent-screen.png)

        2. Select **Get started** to configure Google Auth Platform.

            ![Google Auth Platform](/thehive/images/administration-guides/google-cloud-platform-get-started.png)

        3. In the **App information** section, enter information about your application.

        4. In the **Audience** section, select *Internal*.

        5. In the **Contact information** section, enter the email address that will receive any updates related to the project.

        6. Select **Create**.

        ### Step 3: Remove scopes in the Google Auth Platform

        1. Select **Data access** from the left pane.

            ![Google Auth Platform Data access](/thehive/images/administration-guides/google-auth-platform-data-access.png)

        2. Select **Add or remove scopes**.

            ![Google Auth Platform Add remove scopes](/thehive/images/administration-guides/google-auth-platform-add-remove-scopes.png)

        3. In the **Manually add scopes** section, enter *https://mail.google.com/*.

        4. Select **Add to table**.

        5. Make sure the new scope is selected, then select **Update**.

        6. 

    === <!-- md:license Gold --> <!-- md:license Platinum --> "IMAP server"

    === <!-- md:license Platinum --> "Microsoft 365"
    
    === <!-- md:version 5.5 --> <!-- md:license Platinum --> "Microsoft Graph API"


<h2>Next steps</h2>