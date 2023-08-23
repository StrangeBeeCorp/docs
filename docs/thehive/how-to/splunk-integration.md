# Introduction

This integration, available as a Threat Intelligence Add-on (TA), streamlines the process of creating alerts in TheHive from Splunk search results. The process involves several key steps:

1. Search for events and collect observables and custom fields.
2. Rename Splunk fields to match the field names listed in the `thehive_datatypes.csv` lookup table.
3. Save the search as an alert.
4. Configure the alert action "thehive_create_a_new_alert" to generate alerts in TheHive.
5. Customize alerts by adding additional information such as TLP per observables, custom fields, titles, descriptions, and more.

# Use Cases Examples

In order to understand the practical application of this integration, several use cases (UC1 to UC5) are presented, demonstrating how to configure alerts and cases in TheHive based on various scenarios.

Each use case provides insights into prerequisites, Splunk search configurations, Splunk screenshots, and TheHive screenshots.

# Use Cases Detailed

For a comprehensive understanding of each use case's parameters, including title, description, TLP, PAP, severity, observables, TTPs, and more, please refer to the [original documentation](https://github.com/LetMeR00t/TA-thehive-cortex/blob/main/docs/alert_actions_and_adaptive_response.md).

# Tips & Tricks

Discover valuable insights in the "Tips & Tricks" section, where you can learn how to efficiently populate form fields, manage observables and inline fields, and make the most of tags to enhance your alerts.

# Advanced Search Results with Additional Tags

Explore advanced techniques to enrich your search results with additional tags, including the utilization of the `th_inline_msg` field and the creative renaming of fields for improved tagging.

For comprehensive details and examples, we encourage you to explore the [original documentation](https://github.com/LetMeR00t/TA-thehive-cortex/blob/main/docs/alert_actions_and_adaptive_response.md) to set up your connector effectively.

To integrate this connector into your workflow, please refer to the [original documentation](https://github.com/LetMeR00t/TA-thehive-cortex/blob/main/docs/alert_actions_and_adaptive_response.md). Your success starts there!
