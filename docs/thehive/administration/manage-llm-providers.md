# Manage LLM Providers

<!-- md:version 6.0 --> <!-- md:permission `[admin] manageConfig` --> <!-- md:license One -->

LLM providers connect TheHive to large language models (LLMs), for use in [TheHive Flow](../../flow/user-guides/about-flow.md). Each provider is an OpenAI-compatible API, such as OpenAI, Anthropic, or a local LLM. Once a provider is added, users building workflows can select it, along with one of its models, in an [*AI* action node](../../flow/user-guides/configure-action-node.md#configure-an-ai-action-node).

## Add an LLM provider

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

2. {% include-markdown "includes/connectors-tab-go-to.md" %}

3. Select the **LLM Providers** tab.

    ![LLM Providers tab](/thehive/images/administration-guides/llm-providers-tab.png)

4. Select :fontawesome-solid-plus:.

5. In the **Add a LLM provider** drawer, enter the following information:

    *Fields marked with \* are mandatory.*

    **- Provider name \***

    The name of the LLM provider, for example `OpenAI`.

    **- Description \***

    A description of the LLM provider.

    **- Base URL \***

    The base URL of the provider's OpenAI-compatible API.

    Example: `https://api.openai.com/v1`

    **- API key**

    The API key used to authenticate requests to the provider. Leave it empty for providers that don't require authentication, such as a local LLM.

6. Select **Save**.

The provider is now available for selection in the *AI* action nodes of workflows.

## Edit an LLM provider

1. In the **LLM Providers** tab, select :fontawesome-solid-pen: next to the provider you want to edit.

2. In the **Edit LLM provider** drawer, update the fields.

    The configured API key stays hidden. To replace it, enter a new API key. Leave the field untouched to keep the configured key.

3. Select **Save**.

## Delete an LLM provider

!!! danger "Permanent action"
    Deleting an LLM provider is permanent and can't be undone. It breaks any workflows using the provider.

1. In the **LLM Providers** tab, select :fontawesome-solid-trash: next to the provider you want to delete.

2. In the **Delete provider** dialog, enter `DELETE` to confirm.

3. Select **Delete**.

<h2>Next steps</h2>

* [Configure an AI Action Node](../../flow/user-guides/configure-action-node.md#configure-an-ai-action-node)
* [About TheHive Flow](../../flow/user-guides/about-flow.md)