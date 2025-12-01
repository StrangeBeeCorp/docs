# Upgrade Cortex to Version 4.0

In this tutorial, we're going to upgrade Cortex from version 3.1.x+ to 4.0.x.

Because Cortex can't support multiple major versions of Elasticsearch simultaneously, this upgrade requires moving from Elasticsearch 7.x to 8.x.

By the end, you'll have successfully upgraded both Elasticsearch to 8.x and Cortex to 4.0.x, with all services running and connected.

!!! danger "Shared Elasticsearch instance"
    If you share the same Elasticsearch instance between Cortex and TheHive, ensure that [your TheHive version also supports Elasticsearch 8.x](../../thehive/installation/software-requirements.md). If you're running TheHive 5.2.16 or earlier, [upgrade TheHive](../../thehive/installation/upgrade-from-5.x.md) at the same time as Cortex.

!!! warning "Maintenance window required"
    This procedure involves restarting services. Schedule a maintenance window to prevent service disruption.

!!! tip "Back up before upgrading"
    Before upgrading Cortex, create a complete backup of your data and configurations. See [Back Up and Restore Data](backup-restore.md) for detailed guidance.

This tutorial applies to single-node Elasticsearch instances.

## Step 1: Stop Cortex service

Before we upgrade Elasticsearch, we need to stop the Cortex service to prevent index writes during the process.

!!! info "Service commands"
    For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

!!! warning "Stop TheHive if sharing Elasticsearch"
    If you share your Elasticsearch instance with TheHive, stop TheHive as well before upgrading Elasticsearch to prevent data inconsistencies.

## Step 2: Check the Elasticsearch version

We can't upgrade directly from Elasticsearch versions earlier than 7.17.x to 8.x. Before continuing, we need to confirm that our deployment is running Elasticsearch 7.17.x.

1. Check your current Elasticsearch version:

    ``` bash
    curl -X GET "localhost:9200"
    ```

    Look for the `version.number` field in the response.

2. If your Elasticsearch version is earlier than 7.17.x, continue to the next step. If you're already on 7.17.x, skip to [Step 4](#step-4-prepare-for-elasticsearch-8x-upgrade).

## (Optional) Step 3: Upgrade Elasticsearch to 7.17.x

If our current version is below 7.17.x, we must upgrade to the latest 7.17.x release before moving forward.

Follow the [official Elasticsearch 7.17 upgrade guide](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/setup-upgrade.html){target=_blank} to complete this upgrade.

## Step 4: Prepare for Elasticsearch 8.x upgrade

Now that we're running Elasticsearch 7.17.x, we need to verify that all features and indexes are ready for migration to 8.x.

1. Check upgrade compatibility using the [Elasticsearch feature upgrade API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-migration-get-feature-upgrade-status){target=_blank}.

    ``` bash
    curl -X GET "localhost:9200/_migration/system_features"
    ```

2. Review the response to ensure all features and indexes report as ready for upgrade.

    If any elements require action, follow the recommendations in the API response before proceeding.

## Step 5: Upgrade Elasticsearch to 8.x

With compatibility verified, we're ready to upgrade Elasticsearch to version 8.x.

1. Follow the [official Elasticsearch upgrade documentation](https://www.elastic.co/docs/deploy-manage/upgrade/deployment-or-cluster/upgrade-717#upgrade-step-1-7.17.x-8.19.x){target=_blank} to complete the upgrade.

    !!! note "Automatic restart"
        If you're using package-based or containerized installations, Elasticsearch restarts are handled automatically during the upgrade.

2. Verify that Elasticsearch 8.x is running successfully.

    ``` bash
    curl -X GET "localhost:9200"
    ```

    You should see *version 8.x* in the response.

## Step 6: Upgrade Cortex to version 4.0.x

With Elasticsearch 8.x running, we can now upgrade Cortex itself.

Refer to the [installation guide](../installation-and-configuration/step-by-step-guide.md#cortex-installation-and-configuration) to update Cortex to version 4.0.x.

## Step 7: Restart Cortex and verify connectivity

We're now ready to bring Cortex back online and ensure everything connects properly.

1. Restart the Cortex service.

2. Verify that Cortex connects successfully to the upgraded Elasticsearch instance.

    Check the Cortex logs for successful connection messages and confirm that the application is available.

3. Optional: Restart TheHive if you share the Elasticsearch instance.

    This restores full connectivity between TheHive and the upgraded Elasticsearch instance.

4. Verify that both Cortex (and TheHive, if applicable) are functioning normally.

You've successfully upgraded Cortex to version 4.0.x with Elasticsearch 8.x. Your system is now running the latest versions and ready for use.

<h2>Next steps</h2>

* [Analyzers & Responders](../installation-and-configuration/analyzers-responders.md)
* [Advanced Configuration](../installation-and-configuration/advanced-configuration.md)