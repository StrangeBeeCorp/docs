# Turn Off The MISP Integration

Turn off the MISP integration if you don't use [MISP events](../administration/misp-integration/about-misp-integration.md). [MISP taxonomies](../administration/taxonomies/about-taxonomies.md) remain available as they're imported during TheHive installation.

{% include-markdown "includes/maintenance-window-required.md" %}

<h2>Procedure</h2>

1. Stop TheHive service.

    !!! info "Service commands"
        For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

2. Open the `application.conf` file using a text editor.

3. Uncomment the following line:

    ```yaml
    scalligraph.disabledModules += org.thp.thehive.connector.misp.MispModule
    ```

4. Save your modifications in the `application.conf` file.

5. Restart TheHive service.

<h2>Next steps</h2>

* [Perform Initial Login and Setup as an Admin](../administration/perform-initial-setup-as-admin.md)