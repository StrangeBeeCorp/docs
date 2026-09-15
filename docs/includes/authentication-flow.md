Supported methods:

* None: No authentication is added to the request.

* Basic auth: Sends a username and password encoded in the `Authorization` header using the HTTP Basic scheme.

| Field    | Example |
| -------- | ------- |
| Username * | `emma@example.com` |
| Password * | `$secret.api_password` |

* Bearer token: Sends an access token in the `Authorization` header using the Bearer scheme.

| Field    | Example |
| -------- | ------- |
| Token * | `$secret.api_token` |

* OAuth 2.0: Performs an OAuth 2.0 token exchange. After retrieval, the resulting access token is injected into the request.

| Field    | Example |
| -------- | ------- |
| Client ID * | `$global.slack_client_id` |
| Client secret * | `$secret.slack_client_secret` |
| Access token * | `$secret.slack_access_token` |
| Refresh token * | `$secret.slack_refresh_token` |
| Token URL * | `https://slack.com/api/oauth.v2.access` |
| Authorization URL * | `https://slack.com/oauth/v2/authorize` |
| Token scopes | `chat:write`  |