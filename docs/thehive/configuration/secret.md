# Secret Configuration File - `secret.conf`

!!! Note
    Starting from version 5.4 of TheHive, the secret key must be at least 32 characters long as required by Play Framework 3. Ensure that the secret key complies with this requirement for secure session management.

The `secret.conf` file contains a secret key that is utilized to define cookies responsible for managing user sessions within TheHive application. It is crucial that one instance of TheHive uses a unique secret key to ensure session security and integrity.

- **Single Instance Deployment**: For a single instance of TheHive, ensure that the `secret.conf` file contains a unique secret key.

- **Clustered Deployment**: In the scenario where multiple nodes of TheHive are clustered together, all nodes should have a `secret.conf` file with the same secret key.

!!! Example

    ```yaml
    ## Example secret key configuration
    play.http.secret.key="dgngu325mbnbc39cxas4l5kb24503836y2vsvsg465989fbsvop9d09ds6df6"
    ```

&nbsp;

!!! Warning
    Do not copy the key provided above. Instead, generate and use your own unique secret key for enhanced security and confidentiality.

&nbsp;