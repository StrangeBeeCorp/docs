# Authentication
Like TheHive, Cortex supports local, LDAP, Active Directory (AD), X.509 SSO and/or API keys for authentication and OAuth2.

Please note that API keys can only be used to interact with the Cortex API (for example when TheHive is interfaced with a Cortex instance, it must use an API key to authenticate to it). API keys cannot be used to authenticate to the Web UI. By default, Cortex relies on local credentials stored in Elasticsearch.

Authentication methods are stored in the `auth.provider` parameter, which is
multi-valued. When a user logs in, each authentication method is tried in order
until one succeeds. If no authentication method works, an error is returned and
the user cannot log in.

The default values within the configuration file are:

!!! Example "" 

    ```
    auth {
      # "provider" parameter contains authentication provider. It can be multi-valued (useful for migration)
      # available auth types are:
      # services.LocalAuthSrv : passwords are stored in user entity (in Elasticsearch). No configuration is required.
      # ad : use ActiveDirectory to authenticate users. Configuration is under "auth.ad" key
      # ldap : use LDAP to authenticate users. Configuration is under "auth.ldap" key
      # oauth2 : use OAuth/OIDC to authenticate users. Configuration is under "auth.oauth2" and "auth.sso" keys
      provider = [local]

      # By default, basic authentication is disabled. You can enable it by setting "method.basic" to true.
      method.basic = false

      ad {
        # The name of the Microsoft Windows domain using the DNS format. This parameter is required.
        #domainFQDN = "mydomain.local"

        # Optionally you can specify the host names of the domain controllers. If not set, Cortex uses "domainFQDN".
        #serverNames = [ad1.mydomain.local, ad2.mydomain.local]

        # The Microsoft Windows domain name using the short format. This parameter is required.
        #domainName = "MYDOMAIN"

        # Use SSL to connect to the domain controller(s).
        #useSSL = true
      }

      ldap {
        # LDAP server name or address. Port can be specified (host:port). This parameter is required.
        #serverName = "ldap.mydomain.local:389"

        # If you have multiple ldap servers, use the multi-valued settings.
        #serverNames = [ldap1.mydomain.local, ldap2.mydomain.local]

        # Use SSL to connect to directory server
        #useSSL = true

        # Account to use to bind on LDAP server. This parameter is required.
        #bindDN = "cn=cortex,ou=services,dc=mydomain,dc=local"

        # Password of the binding account. This parameter is required.
        #bindPW = "***secret*password***"

        # Base DN to search users. This parameter is required.
        #baseDN = "ou=users,dc=mydomain,dc=local"

        # Filter to search user {0} is replaced by user name. This parameter is required.
        #filter = "(cn={0})"
      }

      oauth2 {
        # URL of the authorization server
        #clientId = "client-id"
        # Client secret of a confidential client. Set it to "" for a public client, which should enable PKCE.
        #clientSecret = "client-secret"
        #redirectUri = "https://my-cortex-instance.example/api/ssoLogin"
        #responseType = "code"
        #grantType = "authorization_code"
        # Use PKCE (RFC 7636) to protect the authorization code exchange. Recommended, required by some authorization servers.
        #pkce = false

        # URL from where to get the access token
        #authorizationUrl = "https://auth-site.com/OAuth/Authorize"
        #tokenUrl = "https://auth-site.com/OAuth/Token"

        # The endpoint from which to obtain user details using the OAuth token, after successful login
        #userUrl = "https://auth-site.com/api/User"
        #scope = ["openid profile"]
      }

      # Single-Sign On
      sso {
        # Autocreate user in database?
        #autocreate = false

        # Autoupdate its profile and roles?
        #autoupdate = false

        # Autologin user using SSO?
        #autologin = false

        # Name of mapping class from user resource to backend user ('simple' or 'group')
        #mapper = group
        #attributes {
        #  login = "user"
        #  name = "name"
        #  groups = "groups"
        #  organization = "org"
        #}
        #defaultRoles = ["read"]
        #defaultOrganization = "csirt"
        #groups {
        #  # URL to retreive groups (leave empty if you are using OIDC)
        #  #url = "https://auth-site.com/api/Groups"
        #  # Group mappings, you can have multiple roles for each group: they are merged
        #  mappings {
        #    admin-profile-name = ["admin"]
        #    editor-profile-name = ["write"]
        #    reader-profile-name = ["read"]
        #  }
        #}

        #mapper = simple
        #attributes {
        #  login = "user"
        #  name = "name"
        #  roles = "roles"
        #  organization = "org"
        #}
        #defaultRoles = ["read"]
        #defaultOrganization = "csirt"
      }

    }

    # Maximum time between two requests without requesting authentication
    session {
      warning = 5m
      inactivity = 1h
    }
    ```

#### OAuth2/OpenID Connect

To enable authentication using OAuth2/OpenID Connect, edit the `application.conf` file and supply the values of `auth.oauth2` according to your environment. In addition, you need to supply:

- `auth.sso.attributes.login`: name of the attribute containing the OAuth2 user's login in retrieved user info (mandatory)
- `auth.sso.attributes.name`: name of the attribute containing the OAuth2 user's name in retrieved user info (mandatory)
- `auth.sso.attributes.groups`: name of the attribute containing the OAuth2 user's groups (mandatory using groups mappings)
- `auth.sso.attributes.roles`: name of the attribute containing the OAuth2 user's roles in retrieved user info (mandatory using simple mapping)

Cortex authenticates users through an external OAuth2 authorization server. The `auth.oauth2` section accepts the following parameters:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `clientId` | String | Yes | Client ID in the OAuth2 server. |
| `clientSecret` | String | Yes | Client secret in the OAuth2 server. Set it to `""` for a public client. |
| `redirectUri` | String | Yes | URL of the Cortex OAuth2 page, ending with `/api/ssoLogin`. |
| `responseType` | String | Yes | Type of the response. Only `code` is accepted. |
| `grantType` | String | No | Type of the grant. Only `authorization_code` is accepted, which is the default value. |
| `authorizationUrl` | String | Yes | Authorization URL of the OAuth2 server. |
| `authorizationHeader` | String | No | Prefix of the authorization header used to get user information. Default value: `Bearer`. |
| `tokenUrl` | String | Yes | Token URL of the OAuth2 server. |
| `userUrl` | String | Yes | URL to get user information from the OAuth2 server. |
| `scope` | List of strings | Yes | List of scopes. |
| `pkce` | Boolean | No | Use [PKCE](#pkce) to protect the authorization code exchange. Default value: `false`. Available starting with Cortex 4.2. |

If a required parameter is missing, OAuth2 authentication fails.

##### PKCE

<!-- md:version 4.2 -->

Cortex can use Proof Key for Code Exchange (PKCE) to protect the exchange of the authorization code for an access token. Some authorization servers require it. PKCE is turned off by default.

To turn on PKCE, set `auth.oauth2.pkce` to `true`. Cortex then sends an S256 code challenge with the authorization request, and the matching code verifier with the token request. PKCE is recommended even when Cortex uses a client secret.

If the authorization server registers Cortex as a public client, without a client secret, set `auth.oauth2.clientSecret` to `""` and turn on PKCE. Cortex then sends no client secret to the token endpoint. Keep the `clientSecret` key in the configuration, because OAuth2 authentication fails without it.

!!! Example "Example configuration for a public client"

    ```
    oauth2 {
      [..]
      clientSecret: ""
      pkce: true
    }
    ```

!!! warning "Public client without PKCE"
    A public client without PKCE leaves the authorization code exchange unprotected. Cortex logs a warning at startup for this configuration, which is deprecated and will be rejected in a future version.

!!! warning "Upgrading from Cortex 4.1 or earlier"
    Before Cortex 4.2, `auth.sso.autocreate` and `auth.sso.autoupdate` were swapped for OAuth2 authentication. Setting `autocreate` to `true` updated existing users, and setting `autoupdate` to `true` created unknown users. Starting with Cortex 4.2, each setting does what its name says. If you swapped the two values to work around this behavior, swap them back. Only set `autocreate` to `true` if every user of the authorization server should get a Cortex account.


!!! Example "Example configuration for SSO w/ Oauth2 & Github" 

    ```
    auth {
        
      provider = [local, oauth2]

      [..]

      sso {
        autocreate: false
        autoupdate: false
        mapper: "simple"
        attributes {
          login: "login"
          name: "name"
          roles: "role"
        }
        defaultRoles: ["read", "analyze"]
        defaultOrganization: "demo"
      }  
      oauth2 {
        name: oauth2
        clientId: "Client_ID"
        clientSecret: "Client_Secret"
        redirectUri: "http://localhost:9001/api/ssoLogin"
        responseType: code
        grantType: "authorization_code"
        authorizationUrl: "https://github.com/login/oauth/authorize"
        tokenUrl: "https://github.com/login/oauth/access_token"
        userUrl: "https://api.github.com/user"
        scope: ["user"]
      }

      [..]	
    }
    ```

