!!! warning "Prerequisites"

    * Users must have an existing account in TheHive local database to authenticate successfully.
    * These steps assume that you have already followed the instructions to [configure the authentication settings](/thehive/administration/authentication/configure-authentication/).
    * The [base URL](/thehive/configuration/update-service-configuration/#update-the-base-url) is set to the public URL of TheHive. TheHive uses it to build the URL the identity provider (IdP) redirects users to after they sign in. With the default value `http://localhost:9000`, users are sent back to localhost.