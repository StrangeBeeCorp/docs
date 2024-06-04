# Supported notifiers

1. Click EmailerToAddr.

    1. Enter **Subject**.
    1. Enter the email address of the sender in **From**.
    1. Enter the email address of the receiver in **To**.
    1. Click **Add variable** to add in the **Template** field.
    1. Click the **Save** button.

    <img src="../images/EmailerToAddr.png" alt="Emailer To Addr" width="1000" height="1000"/>

1. Click HttpRequest.

    1. Select **Endpoint**. (Refer to [`Add endpoints`](../../manage-endpoints/add_endpoints.md))
    1. Select the HTTP **Method**.
    1. Either enter the **URL**. 
    1. Or select the option **Use endpoint url as prefix**. 
    1. Click **Add variable** to add in the **Template** field.
    1. Select option to **Log errors**. 
    1. Click the **+** to add headers. 
           <img src="../images/add_headers.png" alt="add header" width="500" height="500"/>
           - enter a valid header **key**.
           - enter a valid header **value**.
    1. Under Authentication select the **Type**. 
    1. Select the option **Proxy**. 
    1. Select the option **Do not check certificate Authority**. (Not recommended)
    1. Select the option **Disable hostname verification**.
    1. Click the **Save** button.

    <img src="../images/HttpRequest.png" alt="Http Request" width="1000" height="1000"/>

1. Click MatterMost.

    1. Select **Endpoint**.(Refer to [`Add endpoints`](../../manage-endpoints/add_endpoints.md))
    1. Enter the **Username**.
    1. Enter the **Channel**.
    1. Click **Add variable** to add in the **Template** field.
    1. Click the **Save** button.

    <img src="../images/MatterMost.png" alt="Matter Most" width="1000" height="1000"/>

1. Click Slack.

    1. Select **Endpoint**. (Refer to [`Add endpoints`](../../manage-endpoints/add_endpoints.md))
    1. Click **Add variable** to add in the **Text Template** field.
    1. Enter the **Username**.
    1. Enter the **Channel**.
    1. Check the box for **Advanced Settings** 
    > If you need help filling the Advance Settings fields, check the Slack documentation link 
    1. Enter a **Blocks template**.
    1. Enter an **Attachment template**.
    1. Select **As User**.
    1. Enter an **icon emoji**.
    1. Enter **icon URL**.
    1. Select **Link names**.
    1. Select **Markdown**.
    1. Enter a valid **Parse string**.
    1. Select **Unfirl Links**.
    1. Select **Unfirl Media**. 
    1. Click the **Save** button.

    <img src="../images/Slack.png" alt="Slack" width="1000" height="1000"/>


1. Click Kafka.

    1. Enter a **Topic**.
    1. Enter type the list of servers in **Bootstrap servers**. 

    <img src="../images/Kafka.png" alt="Kafka" width="1000" height="1000"/>
