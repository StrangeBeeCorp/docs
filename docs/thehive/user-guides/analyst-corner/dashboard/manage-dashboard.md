# Managing Dashboards

Dashboards in TheHive provide a convenient way to visualize and track data relevant to investigations, alerts, and ongoing cases. By organizing widgets, charts, and metrics on a single screen, you can quickly gain insights and monitor your security operations in real time.

> **New in Version 5.4.0**  
> A new permission, **Manage Dashboard**, has been introduced to control the ability to modify dashboards.  
> - If a user **has** the **Manage Dashboard** permission, they can create, edit, import, duplicate, and delete dashboards.  
> - If a user **does not have** the **Manage Dashboard** permission (including read-only profiles), they can only view dashboards without making any modifications.

---

## Understanding Dashboard Visibility

When creating or editing dashboards, you can set the **Visibility** to either **Private** or **Shared**:

- **Private**: Only the dashboard creator (you) can view and modify it.  
- **Shared**: Other users in TheHive can view the dashboard. However, only users with the **Manage Dashboard** permission can modify it.

---

## Creating a New Dashboard

To add a dashboard (requires **Manage Dashboard** permission):

1. Click the **+** button to **Add** a dashboard.  
   
    ![Add dashboard menu](/thehive/images/user-guides/analyst-corner/dashboard/add-dashboard-menu.png)

2. Enter the **Title**.  

    Provide a clear, descriptive name (e.g., *SOC Overview*, *Incident Response Stats*) to help identify the dashboard’s purpose.

3. Enter the **Description**.  
   
    Summarize the intent or scope of the dashboard (e.g., *Displays key metrics on ongoing alerts*).

4. Select the **Visibility** option (Private or Shared).  

5. Click the **Confirm** button.

    ![Adding a dashboard](/thehive/images/user-guides/analyst-corner/dashboard/add-new-dashboard.png)

> **Tip:** Create separate dashboards for different teams or use cases (e.g., threat intel, incident response) to keep your environment organized.

---

## Modifying Dashboards

To edit a dashboard (requires **Manage Dashboard** permission):

1. Click the **Edit** option from the list.  
   
    ![Edit dashboard menu](/thehive/images/user-guides/analyst-corner/dashboard/edit-dashboard-menu.png)

2. Modify the required fields, such as **Title**, **Description**, or **Visibility**. 
 
3. Click the **Confirm** button.

   ![Edit dashboard](/thehive/images/user-guides/analyst-corner/dashboard/edit-dashboard.png)

> **Note:** If you do not see the **Edit** option, you may not have the **Manage Dashboard** permission or the dashboard is not editable by your profile.

---

## Removing a Dashboard

To delete a dashboard (requires **Manage Dashboard** permission):

1. Click the **Delete** option from the list.  
   
    ![Delete dashboard menu](/thehive/images/user-guides/analyst-corner/dashboard/delete-dashboard-menu.png)

2. Click **OK** to delete the dashboard from the list.

    ![Delete dashboard popup](/thehive/images/user-guides/analyst-corner/dashboard/delete-dashboard-popup.png)

> **Warning:** Deleting a dashboard is permanent and cannot be undone. Be sure you want to remove it before proceeding.

---

## Uploading a Dashboard

To import a dashboard (requires **Manage Dashboard** permission):

1. Click the **Import dashboard** option.  
   
    ![Import dashboard menu](/thehive/images/user-guides/analyst-corner/dashboard/import-dashboard-menu.png)

2. Click the **Drop file or Click** option to upload your JSON file.  

    > **Note:** The file must be a valid JSON file. You can use a dashboard exported from TheHive or another compatible JSON structure.

    ![Import dashboard](/thehive/images/user-guides/analyst-corner/dashboard/import-dashboard.png)

> **Tip:** Keep backups of your dashboard JSON files in a secure location. This helps you quickly restore or duplicate dashboards when needed.

---

## Downloading a Dashboard

To export a dashboard (no special permission is needed to **view** or **export** dashboards; however, only users with the **Manage Dashboard** permission can create or modify them):

1. Click the **Export** option. 

2. A JSON file is downloaded, which can be shared or imported into another instance of TheHive.

    ![Export dashboard menu](/thehive/images/user-guides/analyst-corner/dashboard/export-dashboard-menu.png)

> **Tip:** Regularly exporting and archiving key dashboards allows you to maintain versions and share best practices among team members.

---

## Cloning a Dashboard

> **Note:** This action requires the **Manage Dashboard** permission.

Duplicating a dashboard lets you create a new one with the same widgets and layout:

1. From the dashboard list, select **Duplicate**.  
2. A new window opens, pre-filled with the original dashboard's configuration.  
3. Modify the **Title**, **Description**, and **Visibility** if needed.  
4. Click **Confirm** to create the duplicated dashboard.

> **Best Practice:** When duplicating a dashboard, update its name to avoid confusion (e.g., *SOC Overview - APAC*).

---

## Summary of Permission Requirements

- **Manage Dashboard** Permission (introduced in 5.4.0):  
  - Create new dashboards  
  - Edit existing dashboards  
  - Import dashboards  
  - Duplicate dashboards  
  - Delete dashboards

- **No Manage Dashboard** Permission (read-only profiles):  
  - Can only access (view) dashboards in read-only mode

This new permission model ensures that dashboards remain secure and that only authorized users can modify critical information. If you are a SOC manager or administrator, make sure to grant the **Manage Dashboard** permission to the appropriate profiles to maintain operational efficiency and security.

&nbsp;