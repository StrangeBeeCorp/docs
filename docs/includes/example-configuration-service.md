    !!! example "Service configuration examples"

        * Root domain:

            Without explicit port:

            ```yaml
            application.baseUrl = "https://thehive.example.org"
            play.http.context = "/"
            ```

            With explicit port:

            ```yaml
            application.baseUrl = "https://thehive.example.org:9000"
            play.http.context = "/"
            ```

        * Custom path behind a reverse proxy:

            Without explicit port:

            ```yaml
            application.baseUrl = "https://example.org/thehive"
            play.http.context = "/thehive"
            ```

            With explicit port:

            ```yaml
            application.baseUrl = "https://example.org:9000/thehive"
            play.http.context = "/thehive"
            ```