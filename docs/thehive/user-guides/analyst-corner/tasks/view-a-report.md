# Case Report Feature Documentation

## Overview
The Case Report feature provides users with a dedicated **Report** tab within case profiles, allowing them to generate, customize, and manage reports efficiently. Reports are based on predefined templates set by administrators, ensuring consistency and accessibility. This feature supports multiple output formats and allows customization based on user roles.

## Prerequisites
To use the Case Report feature, users must meet the following requirements:
- A **Platinum license** is required.
- At least one **Case Report template** must be configured in the organization settings.

## Accessing the Case Report Tab
To access the Report tab, users must open a case from the case list and navigate to the **Report** tab. If no report templates are available, a notification will be displayed, and the **Create Report** button will not appear. This ensures that only configured templates are available for selection. The Report tab provides a preview area and a configuration panel where users can choose report templates and formats.

## Selecting a Report Template
Users can select a report template from the **Template** dropdown menu. The system will display a preview of the selected template, ensuring that the user can review its contents before finalizing the report. The last selected template is stored and preloaded the next time the user accesses the tab. Templates are organization-specific, meaning that users will only see templates relevant to their workspace.

## Choosing a Report Format
Reports can be generated in different formats, including **HTML, Markdown, Word, and PDF**. HTML and Markdown are useful for digital sharing, while Word and PDF formats are suited for formal documentation. Regardless of the format selected, the preview is displayed in HTML to maintain consistency and usability. The last selected format is stored and automatically preselected for convenience.

## Configuring Element Display Limits
Users have the ability to control the number of elements displayed per widget in the report preview by setting an **Element Display Limit**. This feature is useful for managing large datasets and optimizing readability. The default limit is set to **100 elements**, but users can adjust this based on their preferences. This limit only affects the preview and does not impact the final report output.

## Navigating the Report
The **Table of Contents** feature enhances navigation within the report. Clicking on a section title allows users to jump directly to that part of the report. The system dynamically generates this index based on widget titles. If a widget lacks a title, it is categorized by its type, such as "Text" or "Image: filename.png." Long titles are truncated for better readability.

## Saving and Downloading Reports
Once a report is finalized, users can click **Save & Download** to generate the report in the selected format. The system will automatically save the report within the case profile under the **Reports** tab and simultaneously download it to the user’s device. Reports are always downloaded in **light mode**, ensuring readability and print-friendly formatting, even if the user has dark mode enabled.

## Generating a PDF Report
For compliance and official documentation, users can generate reports in **PDF** format. This format provides a structured, non-editable document that is ideal for archiving and distribution. Selecting **PDF** as the format and clicking **Save & Download** will process the case data into a structured document.

## Sending Reports via Email
Users can share reports directly via email by entering recipient email addresses in the **Send Report** section and clicking **Send Report**. If the selected format is **HTML or Markdown**, the report content is embedded within the email body. If the report is in **Word or PDF**, it is attached as a file. The email includes a predefined subject line containing key details such as the report title, date, and case number, ensuring that recipients can quickly identify the report's contents.

## Conclusion
The **Case Report** feature enhances case management by providing structured, customizable, and accessible reporting tools. By supporting multiple formats, offering flexible templates, and improving navigation, it streamlines workflows for analysts, SOC managers, and other stakeholders who require detailed case documentation.