# Setup New Server

In this section, you can find information about configuring the MISP integration.
MISP and TheHive can interact between each other in both ways:

* TheHive is able to import events from a MISP instance as alerts and create cases from them.

* TheHive is able to export a case into MISP as an event and update it with the artifacts flagged as IOC as MISP attributes.

## Add a new server

To set up a new server:

1. On the Platform Management page, in the MISP tab, click the **+** button.

    <img src="../images/add-misp-server-button.png" alt="Setup MISP Server" width="1000" height="1000"/>

    Set up the new server window opens.

    <img src="../images/add-misp-server-details.png" alt="Add MISP Server Details" width="1500" height="1500"/>
  
1. In the General settings section, Enter the **Server name**, **Server url**, and **API key**.

1. Select the **Purpose** from the list.

    <img src="../images/purpose-list.png" alt="Purpose List" width="400" height="200"/>
  
1. In the Proxy settings section, select the **Type of protocol** from the list.

    <img src="../images/type-of-protocol.png" alt="Type of Protocol" width="400" height="200"/>
    
1. Enter the **Address**.

1. Switch on the buttons for **Athentification**, **Do not check certificate authority**, and **Disable hostname verification** if required.

1. In the Advanced settings section, select the filter for the TheHive organizations from the list.

    <img src="../images/advanced-settings-filter.png" alt="Filter for TheHive Organizations" width="400" height="200"/>

    You can make the server available only to selected organizations or make it available to all organizations.

1. Click the **Update** button.

    Do you want to save the modifications message appears.

    <img src="../images/save-modifications-confirm.png" alt="Save Modifications" width="700" height="700"/>

1. Click **Confirm**.

    MISP configuration successfully saved message appears.

    <img src="../images/misp-configuration-saved-message.png" alt="MISP Configuration Saved" width="400" height="400"/>


## Delete a MISP Server

1. On the Platform Management page, in the MISP tab, click the ellipsis(...) corresponnding to the server you want to delete.

    <img src="../images/delete-misp-button.png" alt="MISP Server Delete" width="1000" height="1000"/>

    A delete confirmation dialog box appears.

    <img src="../images/delete-cortex-server-confirm.png" alt="Cortex Server Delete confirm" width="400" height="200"/>

1. Click **OK**.

    Do you want to save the modifications message appears.

    <img src="../images/save-modifications-confirm.png" alt="Save Modifications" width="700" height="700"/>

1. Click **Confirm**.

    MISP configuration successfully saved message appears.

    <img src="../images/misp-configuration-saved-message.png" alt="MISP Configuration Saved" width="400" height="200"/>


## Edit MISP Server

1. On the Platform Management page, in the MISP tab, click the server name you want to edit.

    <img src="../images/update-misp.png" alt="Edit MISP Server" width="1000" height="1000"/>

    Set up the server for that particular server window opens.

    <img src="../images/update-misp-details.png" alt="Edit MISP Server Details" width="1000" height="1000"/>

1. Edit the required details.

1. Click **Update**.

    Do you want to save the modifications message appears.

    <img src="../images/save-modifications-confirm.png" alt="Save Modifications" width="700" height="700"/>

1. Click **Confirm**

    Cortex configuration successfully saved message appears.

    <img src="../images/new-cortex-server-saved-message.png" alt="New Cortex Server Configuration Saved" width="400" height="200"/>