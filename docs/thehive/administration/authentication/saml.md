# How to Configure a SAML Authentication Provider

<!-- md:license Platinum -->

This topic provides step-by-step instructions for configuring a Security Assertion Markup Language (SAML) authentication provider in TheHive.

{!includes/access-authentication.md!}

<h2>Procedure</h2>

!!! warning "Prerequisite"
    Users must have an existing account in TheHive's local database to authenticate successfully.

!!! info "Login flow with multiple SAML providers"
    You can configure multiple SAML providers in TheHive. When a user attempts to log in, TheHive queries each provider sequentially, following the defined order. The process stops as soon as a provider grants authorization.

1. {!includes/platform-management-view-go-to.md!}

    ---

2. {!includes/authentication-tab-go-to.md!}

    ---

3. Select **SAML authentication** in the **Authentication providers** section.

    ---

4. In the **SAML authentication** drawer, turn on the **Enable SAML** toggle.

    ---

5. Select **Add a provider** or select :fontawesome-solid-plus:.

    ---

6. Enter the following information:

    **- Name**

    Enter a recognizable name for the identity provider (IdP) in TheHive.

    Example: *Microsoft Entra ID*

    **- Identity provider metadata type**

    Select how TheHive retrieves configuration information for the IdP—either from an XML file or a URL.

    * If you choose *url*, provide the full link to the metadata document.
    
        Example: *https://login.microsoftonline.com/{tenant-id}/federationmetadata/2007-06/federationmetadata.xml*

    * If you choose *xml*, paste the XML metadata content directly into the field.
    
        Example: 

        ``` xml
        <?xml version="1.0" encoding="UTF-8"?>
        <md: EntityDescriptor entityID="http://www.okta.com/exknhwsd2uAGUSK66696"               xmlns="urn:oasis:names:tc:SAML:2.0:metadata">
            <md:IDPSSODescriptor WantAuthnRequestsSigned="false" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
                <md:KeyDescriptor use="signing">
                    <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        ```

    **- User login attribute**

    Enter the name of the attribute from the IdP that contains the user's login information (such as email or username).

    **- Maximum authentication life time**

    Enter the maximum session duration for user authentication. This value must align with the session timeout configured on the IdP to ensure consistent session behavior.

    If you're unsure of the value set in your IdP, we recommend setting it to *90 days*, as this is the default for most IdPs.

<h2>Next steps</h2>

* [How to Configure Authentication](configure-authentication.md)