# Workflow Templates

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](about-flow.md) provides ready-made workflow templates that cover common security automation scenarios. Each template is available as YAML code in its own section. Save the code as a `.yaml` file, [import it](import-export-workflows.md#import-a-workflow) into your organization, then adapt some of its elements to your environment.

## Customization common to all templates

Templates contain placeholders instead of real connection details: `https://thehive.example.com` for the URL of TheHive and `<THEHIVE_API_KEY>` for its API key. Templates that call third-party products use placeholders for their credentials too, such as `<SLACK_BOT_TOKEN>` or `<JIRA_API_TOKEN>`. A workflow can't run until you replace them.

Create the global variables before importing a template, so they're ready to select while you adapt the workflow:

1. [Create a global variable](manage-global-variables.md#create-a-global-variable) holding the URL of your TheHive instance.

2. [Create a secret global variable](manage-global-variables.md#create-a-global-variable) holding the [API key](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/manage-user-accounts.md#manage-a-user-account-api-key) used to authenticate against TheHive.

3. Create the global variables listed in the section of the template, if any, for the third-party products it calls.

After import, replace the placeholders with your variables in the **Base URL** and **Bearer token** fields of every *TheHive* [integration node](configure-integration-node.md).

A template file doesn't contain triggers. A template that starts from a *Webhook* or *Scheduler* trigger needs it [added](add-trigger.md) after import, as described in its section.

## Alert triage

The *Alert triage* template automates the first triage of alerts coming from a third-party detection product, in this template an Elastic Security EDR.

Each alert the product sends to the *Webhook* trigger becomes a normalized alert in TheHive, with its severity, observables, and MITRE ATT&CK techniques carried over. The workflow then checks the reputation of the IP address and hash observables against Recorded Future.

When threat intelligence confirms an indicator of compromise (IOC), the workflow raises the alert severity to *Critical*, escalates the alert to a case, and lists the malicious indicators in a case comment. Alerts without a confirmed IOC stay in the alert queue for manual review.

Before importing this template, prepare the following elements:

* Recorded Future API key: [Create a secret global variable](manage-global-variables.md#create-a-global-variable) holding your Recorded Future API key.
* Custom fields: The normalization script fills a `sourcefields` custom field on the alert. [Create this custom field](../../thehive/administration/custom-fields/create-a-custom-field.md) in TheHive with `sourcefields` as its technical name and the *String* type. TheHive rejects the alert creation when this custom field doesn't exist. To skip this step, remove the `customFields` section from the *Normalize Alert* script after import.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Recorded Future API key: Select your secret global variable instead of the `<RECORDED_FUTURE_API_KEY>` placeholder in the **API Token** field of both [*Recorded Future* integration nodes](configure-integration-node.md#configure-a-recorded-future-integration-node), *Recorded Future IP check* and *Recorded Future Hash check*. Replace these nodes with your own intelligence provider if you don't use Recorded Future.
* Trigger: [Add a *Webhook* trigger](add-trigger.md#add-a-webhook-trigger) to the workflow. In its **Workflow input** section, assign `$request.body` to the `ElasticAlert` input variable, then configure the detection product to send its alerts to the trigger URL. To test the workflow without Elastic Security, send it the sample alert at the end of this section.
* Normalization script: The *Normalize Alert* Python node maps Elastic Security fields, such as `kibana.alert.severity` and `host.ip`, to TheHive alert fields. Rewrite this mapping if your alerts come from another product. The script reads most fields directly and fails when an alert lacks one of them, for example `registry.path` on an alert that doesn't involve the registry. It adds a `hash` observable only when the alert carries `process.hash.sha256`.
* Data type conditions: The *If dataType IP* and *If dataType Hash* conditions route observables to enrichment. Adapt them if you enrich other data types.
* Escalation threshold: The *If Recorded Report Malicious* condition escalates at a risk score of 65 or higher, and the *TheHive add Comment Case* node lists the indicators reaching the same score. Change this value in both nodes to match your triage policy.

??? example "Alert triage template YAML"

    ```yaml
    version: v1.0.0
    spec_version: chocolate-v2.0.0
    id: playbook-01a1307e-18cc-7eff-ade0-dff253305647
    name: Alert Triage
    description: "Turns an Elastic Security alert received by webhook into a TheHive alert, enriches its IPs and hashes with Recorded Future and, when an indicator is malicious, raises the severity, escalates the alert to a case and comments it."
    timeout: 10m0s
    variables:
      input:
        - id: 65b11c1d-bf38-4a47-bb40-428732c1db01
          name: ElasticAlert
          type: object
    workflow_start: start--new-playbook--51fb5721-2254-4021-b46f-5a4141967f95
    workflow:
      1a9beb00-2000-4057-869c-380a2f4d1b04:
        id: 1a9beb00-2000-4057-869c-380a2f4d1b04
        name: Create TheHive Alert
        type: action
        on_success: 5307d63f-c47c-4d31-a739-f5fdaba1b273
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_alert__body: '{{ $steps["cae7a2aa-b33e-4c61-b60b-f36cda75993e"].thehiveAlert }}'
            editor_mode: raw
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 400.99999999999994
            'y': 281
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_alert__body:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["cae7a2aa-b33e-4c61-b60b-f36cda75993e"].thehiveAlert
                          type: variable
      3267308b-6ee2-4d65-a50a-c1f3c25cfcc7:
        id: 3267308b-6ee2-4d65-a50a-c1f3c25cfcc7
        name: TheHive add Comment Case
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_comment_in_case
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_comment_in_case__caseId: '{{ $steps["4e464533-059e-45fe-b69b-c23586f1e958"].body._id }}'
            create_comment_in_case__message: >-
              Malicious indicators : {{
              $steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureIpReport
              +
              $steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureHashReport
              | map(select(. != null))
                | map(select(.data.results[0].risk.score >= 65))
                | map(.data.results[0].entity.id)
                | join(", ") }}
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 518
            'y': 917
          variableInputs:
            command.parameters.create_comment_in_case__caseId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["4e464533-059e-45fe-b69b-c23586f1e958"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.update_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"]
                          type: variable
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_comment_in_case__message:
              wireDoc:
                nodes:
                  - type: text
                    value: 'Malicious indicators : '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureIpReport
                          type: variable
                        - type: text
                          value: ' + '
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureHashReport
                          type: variable
                        - type: text
                          value: |2-
                             | map(select(. != null))
                              | map(select(.data.results[0].risk.score >= 65))
                              | map(.data.results[0].entity.id)
                              | join(", ")
      4786405f-f7a2-432b-847b-962e32a87386:
        id: 4786405f-f7a2-432b-847b-962e32a87386
        name: Set observables array
        type: action
        on_success: 627e10fb-1d2d-45cf-9637-db95495fca46
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 6b0b56ca-e1bc-4bf4-bf11-d37012fa5b42
                name: observables
                type: array
                value: '{{ $steps["aa686157-1643-45e2-975e-398f89be5940"].body }}'
        ui:
          position:
            x: 400.99999999999994
            'y': 509
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["aa686157-1643-45e2-975e-398f89be5940"].body
                            type: variable
      4e464533-059e-45fe-b69b-c23586f1e958:
        id: 4e464533-059e-45fe-b69b-c23586f1e958
        name: Escalate alert to case
        type: action
        on_success: 3267308b-6ee2-4d65-a50a-c1f3c25cfcc7
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: escalate_alert_to_case
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            escalate_alert_to_case__alertId: >-
              {{
              $steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"]
              }}
            escalate_alert_to_case__flag: no_change
            headers:
              - name: Content-Type
                value: application/json
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 518
            'y': 841
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.escalate_alert_to_case__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"]
                          type: variable
            command.parameters.headers:
              wireDocs:
                - nodes:
                    - type: text
                      value: application/json
      5307d63f-c47c-4d31-a739-f5fdaba1b273:
        id: 5307d63f-c47c-4d31-a739-f5fdaba1b273
        name: Set TheHive Alert ID
        type: action
        on_success: aa686157-1643-45e2-975e-398f89be5940
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 2bf721bf-3fab-491b-ba04-cba52076a353
                name: alertID
                type: string
                value: '{{ $steps["1a9beb00-2000-4057-869c-380a2f4d1b04"].body._id }}'
        ui:
          position:
            x: 400.99999999999994
            'y': 357
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["1a9beb00-2000-4057-869c-380a2f4d1b04"].body
                            type: variable
                          - type: text
                            value: ._id
      54cd1c54-4ea6-41b7-9da9-da937ff68726:
        id: 54cd1c54-4ea6-41b7-9da9-da937ff68726
        name: If Recorded Report Malicious
        type: if-condition
        condition: >-
          $steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureIpReport +
          $steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureHashReport
            | map(select(. != null))
            | map(.data.results[0].risk.score)
            | any(. >= 65)
        on_true: b61ad5d9-f409-4cc4-837c-8d4711326d8c
        ui:
          position:
            x: 660
            'y': 689
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureIpReport
                    type: variable
                  - type: text
                    value: ' + '
                  - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"].RecordedFutureHashReport
                    type: variable
                  - type: text
                    value: |2-

                        | map(select(. != null))
                        | map(.data.results[0].risk.score)
                        | any(. >= 65)
      627e10fb-1d2d-45cf-9637-db95495fca46:
        id: 627e10fb-1d2d-45cf-9637-db95495fca46
        name: For Each Observables
        type: foreach
        on_success: 54cd1c54-4ea6-41b7-9da9-da937ff68726
        foreach:
          foreach: $steps["4786405f-f7a2-432b-847b-962e32a87386"]["6b0b56ca-e1bc-4bf4-bf11-d37012fa5b42"]
          key_variable: idx
          key_variable_id: e03f2734-49bc-4b98-9ab9-05d0dd4a9fbd
          value_variable: item
          value_variable_id: 12a1f827-3df3-458a-b1d3-3a68f86f8602
          body: bcdb2541-9f2c-44b1-b610-33c39796c69d
          output:
            - name: RecordedFutureIpReport
              value: $steps["856169e3-fb0e-48d0-98c1-fbca7db27b9a"].body
            - name: RecordedFutureHashReport
              value: $steps["a38f8916-c615-4d9a-b302-093254e8c7f9"].body
        ui:
          position:
            x: 400.99999999999994
            'y': 585
          variableInputs:
            foreach.output:
              wireDocs:
                - nodes:
                    - key: steps["856169e3-fb0e-48d0-98c1-fbca7db27b9a"].body
                      type: variable
                - nodes:
                    - key: steps["a38f8916-c615-4d9a-b302-093254e8c7f9"].body
                      type: variable
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["4786405f-f7a2-432b-847b-962e32a87386"]["6b0b56ca-e1bc-4bf4-bf11-d37012fa5b42"]
                    type: variable
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      856169e3-fb0e-48d0-98c1-fbca7db27b9a:
        id: 856169e3-fb0e-48d0-98c1-fbca7db27b9a
        name: Recorded Future IP check
        type: action
        command:
          command: strangebee.integration.recorded_future.v2
          version: v1.0.0
          type: strangebee
          parameters:
            action: enrich_indicators
            api_key: <RECORDED_FUTURE_API_KEY>
            auth_type: none
            base_url: https://api.recordedfuture.com
            editor_mode: form
            enrich_indicators__ip: >-
              ["{{
              $steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"].data
              }}"]
            manual_status_handling: true
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 0
            'y': 765
          variableInputs:
            command.parameters.enrich_indicators__ip:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                        - type: text
                          value: .data
                  - type: text
                    value: '"]'
            command.parameters.enrich_indicators__hash:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                  - type: text
                    value: .data"] // emp
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://api.recordedfuture.com
            command.parameters.enrich_indicators__domain:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                  - type: text
                    value: .data"] // empty
            command.parameters.enrich_indicators__url:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                  - type: text
                    value: .data"] // empty
            command.parameters.enrich_indicators__companybydomain:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                  - type: text
                    value: .data"] // empty
            command.parameters.api_key:
              wireDoc:
                nodes:
                  - type: text
                    value: <RECORDED_FUTURE_API_KEY>
      a38f8916-c615-4d9a-b302-093254e8c7f9:
        id: a38f8916-c615-4d9a-b302-093254e8c7f9
        name: Recorded Future Hash check
        type: action
        command:
          command: strangebee.integration.recorded_future.v2
          version: v1.0.0
          type: strangebee
          parameters:
            action: enrich_indicators
            api_key: <RECORDED_FUTURE_API_KEY>
            auth_type: none
            base_url: https://api.recordedfuture.com
            editor_mode: form
            enrich_indicators__hash: >-
              ["{{
              $steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"].data
              }}"]
            manual_status_handling: true
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 141.99999999999997
            'y': 841
          variableInputs:
            command.parameters.enrich_indicators__ip:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                        - type: text
                          value: .data
                  - type: text
                    value: '"]'
            command.parameters.enrich_indicators__hash:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                        - type: text
                          value: .data
                  - type: text
                    value: '"]'
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://api.recordedfuture.com
            command.parameters.enrich_indicators__domain:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                  - type: text
                    value: .data"] // empty
            command.parameters.enrich_indicators__url:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                  - type: text
                    value: .data"] // empty
            command.parameters.enrich_indicators__companybydomain:
              wireDoc:
                nodes:
                  - type: text
                    value: '["'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                          type: variable
                  - type: text
                    value: .data"] // empty
            command.parameters.api_key:
              wireDoc:
                nodes:
                  - type: text
                    value: <RECORDED_FUTURE_API_KEY>
      aa686157-1643-45e2-975e-398f89be5940:
        id: aa686157-1643-45e2-975e-398f89be5940
        name: Get Alert Observables
        type: action
        on_success: 4786405f-f7a2-432b-847b-962e32a87386
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: post_query
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: raw
            manual_status_handling: false
            post_query__body: |-
              {
                  "query": [
                      {
                          "_name": "getAlert",
                          "idOrName": "{{ $steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"] }}"
                      },
                      {"_name": "observables"}
                  ]
              }
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 400.99999999999994
            'y': 433
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.post_query__body:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      {
                          "query": [
                              {
                                  "_name": "getAlert",
                                  "idOrName": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"]
                          type: variable
                  - type: text
                    value: |-
                      "
                              },
                              {"_name": "observables"}
                          ]
                      }
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      {
                          "query": [
                              {
                                  "_name": "getAlert",
                                  "idOrName": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"]
                          type: variable
                  - type: text
                    value: |-
                      "
                              },
                              {"_name": "observables"}
                          ]
                      }
      b61ad5d9-f409-4cc4-837c-8d4711326d8c:
        id: b61ad5d9-f409-4cc4-837c-8d4711326d8c
        name: TheHive set critical severity
        type: action
        on_success: 4e464533-059e-45fe-b69b-c23586f1e958
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: update_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
            update_alert__alertId: >-
              {{
              $steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"]
              }}
            update_alert__follow: no_change
            update_alert__severity: 4
        ui:
          position:
            x: 518
            'y': 765
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.update_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["5307d63f-c47c-4d31-a739-f5fdaba1b273"]["2bf721bf-3fab-491b-ba04-cba52076a353"]
                          type: variable
      bcdb2541-9f2c-44b1-b610-33c39796c69d:
        id: bcdb2541-9f2c-44b1-b610-33c39796c69d
        name: If dataType IP
        type: if-condition
        condition: >-
          $steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"].dataType
          == "ip"
        on_true: 856169e3-fb0e-48d0-98c1-fbca7db27b9a
        on_false: c79881cc-2b74-436e-8d66-390b612a96a2
        ui:
          position:
            x: 141.99999999999997
            'y': 689
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                    type: variable
                  - type: text
                    value: .dataType == "ip"
      c79881cc-2b74-436e-8d66-390b612a96a2:
        id: c79881cc-2b74-436e-8d66-390b612a96a2
        name: If dataType Hash
        type: if-condition
        condition: >-
          $steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"].dataType
          == "hash"
        on_true: a38f8916-c615-4d9a-b302-093254e8c7f9
        ui:
          position:
            x: 284
            'y': 765
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - key: steps["627e10fb-1d2d-45cf-9637-db95495fca46"]["12a1f827-3df3-458a-b1d3-3a68f86f8602"]
                    type: variable
                  - type: text
                    value: .dataType == "hash"
      cae7a2aa-b33e-4c61-b60b-f36cda75993e:
        id: cae7a2aa-b33e-4c61-b60b-f36cda75993e
        name: Normalize Alert
        type: action
        on_success: 1a9beb00-2000-4057-869c-380a2f4d1b04
        command:
          command: strangebee.code.execute.python@v3_11
          version: v1.0.0
          type: strangebee
          parameters:
            script: "from datetime import datetime, timezone\n\ndata = flow.get('$input[\"65b11c1d-bf38-4a47-bb40-428732c1db01\"]')\n\n# Store the \"fields\" array present in the source alert JSON\nsourceFields = data[\"fields\"]\n\n# Severity mapping \"low\": 1, \"medium\": 2, \"high\": 3, \"critical\": 4\nm = {\"low\": 1, \"medium\": 2, \"high\": 3, \"critical\": 4}\nif sourceFields[\"kibana.alert.severity\"][0] in m:\n    severity = m[sourceFields[\"kibana.alert.severity\"][0]]\n\n# Dynamic, deduplicated procedures, keeping order\nraw_ttps = sourceFields.get(\"signal.rule.threat.technique.subtechnique.id\", [])\nraw_ttps = raw_ttps if isinstance(raw_ttps, list) else [raw_ttps]\n\nprocedures = []\nseen_ids = set()\n\n# Direct extraction of occurDate and tactic\noriginal_time = (\n    sourceFields[\"signal.original_time\"][0]\n    if \"signal.original_time\" in sourceFields and sourceFields[\"signal.original_time\"]\n    else None\n)\noccur_date = int(datetime.fromisoformat(original_time.replace(\"Z\", \"+00:00\")).timestamp())*1000 if original_time else None\n\ntactic = (\n    sourceFields[\"signal.rule.threat.tactic.name\"][0]\n    if \"signal.rule.threat.tactic.name\" in sourceFields and sourceFields[\"signal.rule.threat.tactic.name\"]\n    else None\n)\n\nfor tid in raw_ttps:\n    if tid and tid not in seen_ids:\n        seen_ids.add(tid)\n        procedures.append({\n            \"patternId\": tid,\n            \"occurDate\": occur_date,\n            \"tactic\": tactic\n        })\n\nobservables = [\n    {\"dataType\": \"ip\", \"data\": sourceFields[\"host.ip\"][0]},\n    {\"dataType\": \"filename\", \"data\": sourceFields[\"process.name.text\"][0]},\n    {\"dataType\": \"fqdn\", \"data\": sourceFields[\"host.hostname\"][0]},\n    {\"dataType\": \"registry\", \"data\": sourceFields[\"registry.path\"][0]},\n    {\"dataType\": \"registry\", \"data\": sourceFields[\"registry.value\"][0]},\n]\n\n# Optional: process hash (ECS field process.hash.sha256) -> \"hash\" observable,\n# without this the Recorded Future Hash check branch never has anything to run on\nprocess_hash = (\n    sourceFields[\"process.hash.sha256\"][0]\n    if \"process.hash.sha256\" in sourceFields and sourceFields[\"process.hash.sha256\"]\n    else None\n)\nif process_hash:\n    observables.append({\"dataType\": \"hash\", \"data\": process_hash})\n\nNormalize_Alert={\n    \"type\": sourceFields[\"message\"][0],\n    \"source\": \"Elasticsearch\",\n    \"sourceRef\": data[\"_id\"],\n    \"title\": sourceFields[\"kibana.alert.rule.name\"][0],\n    \"description\": \"# **Alert description** : \"+ \"\\n\" + sourceFields[\"signal.rule.description\"][0]+\"\\n\"+\"# **Alert reason** :\"+sourceFields[\"kibana.alert.reason\"][0]+\"\\n # **MITRE ATT&CK Reference** : \"+\"\\n\"+sourceFields[\"kibana.alert.rule.threat.technique.subtechnique.reference\"][0]+\"\\n\"+sourceFields[\"kibana.alert.rule.threat.tactic.reference\"][0],\n    \"severity\": severity,\n    \"date\": int(datetime.fromisoformat(sourceFields[\"signal.original_time\"][0].replace(\"Z\", \"+00:00\")).timestamp())*1000,\n    \"tags\": sourceFields[\"signal.rule.tags\"],\n    \"customFields\": [\n    \t{\"name\":\"sourcefields\",\"value\":sourceFields[\"host.os.full.text\"][0]},\n    \t{\"name\":\"sourcefields\",\"value\":sourceFields[\"host.hostname\"][0]},\n       \t{\"name\":\"sourcefields\",\"value\":sourceFields[\"process.executable.text\"][0]}\n    ],\n    \"observables\": observables,\n    \"procedures\": procedures\n}\n\nflow.set(\"thehiveAlert\",Normalize_Alert)"
        ui:
          position:
            x: 400.99999999999994
            'y': 205
          variableInputs: {}
      start--new-playbook--51fb5721-2254-4021-b46f-5a4141967f95:
        id: start--new-playbook--51fb5721-2254-4021-b46f-5a4141967f95
        type: start
        on_success: cae7a2aa-b33e-4c61-b60b-f36cda75993e
        ui:
          position:
            x: 400.99999999999994
            'y': 0
    created_by: admin@thehive.local
    created: '2026-10-12T14:22:12.684983Z'
    modified_by: admin@thehive.local
    modified: '2026-10-12T14:55:53.21191Z'
    ```

??? example "Sample Elastic Security alert"

    This sample alert contains fictitious data and every field the *Normalize Alert* script reads. Its `process.hash.sha256` value is the SHA-256 hash of the EICAR antivirus test file.

    ```json
    {
      "_index": ".internal.alerts-security.alerts-default-000001",
      "_id": "3f9a1c7e5b2d48e6a0c4f8b1d7e9a2c6b5f0e3d8a1c7b4e9f2a6d0c5b8e1f4a7",
      "fields": {
        "@timestamp": ["2026-10-05T09:12:51.204Z"],
        "message": ["Endpoint registry event"],
        "event.category": ["registry"],
        "kibana.alert.rule.name": ["Startup or Run Key Registry Modification"],
        "kibana.alert.severity": ["high"],
        "kibana.alert.reason": ["registry event with process invoice_viewer.exe, by jdoe on WKS-FIN-042 created high alert Startup or Run Key Registry Modification."],
        "kibana.alert.rule.threat.technique.subtechnique.reference": ["https://attack.mitre.org/techniques/T1547/001/"],
        "kibana.alert.rule.threat.tactic.reference": ["https://attack.mitre.org/tactics/TA0003/"],
        "signal.rule.description": ["Identifies run key or startup key registry modifications. In order to survive reboots and other system interrupts, attackers will modify run keys within the registry or leverage startup folder items as a form of persistence."],
        "signal.original_time": ["2026-10-05T09:12:44.000Z"],
        "signal.rule.tags": ["Domain: Endpoint", "OS: Windows", "Tactic: Persistence", "Data Source: Elastic Defend"],
        "signal.rule.threat.technique.subtechnique.id": ["T1547.001"],
        "signal.rule.threat.tactic.name": ["Persistence"],
        "host.ip": ["10.20.30.41"],
        "host.hostname": ["WKS-FIN-042"],
        "host.os.full.text": ["Windows 11 Pro 23H2"],
        "user.name": ["jdoe"],
        "process.name.text": ["invoice_viewer.exe"],
        "process.executable.text": ["C:\\Users\\jdoe\\AppData\\Local\\Temp\\invoice_viewer.exe"],
        "process.hash.sha256": ["275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f"],
        "registry.path": ["HKEY_USERS\\S-1-5-21-1004336348-1177238915-682003330-1001\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\InvoiceViewer"],
        "registry.value": ["InvoiceViewer"]
      }
    }
    ```

    To test the workflow without Elastic Security, save the sample as `elastic_alert_example.json` and send it to the URL of the *Webhook* trigger. If the trigger uses an [authentication method](add-trigger.md#add-a-webhook-trigger), add the matching header, for example `-H "X-Api-Key: <key>"` for *Key / Header Auth*.

    ```bash
    curl -X POST -H "Content-Type: application/json" -d @elastic_alert_example.json "<webhook_url>"
    ```

## Command line analysis

The *Command line analysis* template reveals what the PowerShell command lines attached to an alert do and surfaces the IOCs they contain. It has no trigger: [run it manually from an alert](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert) in TheHive.

Malicious commands are often obfuscated with a Base64-encoded `-EncodedCommand` argument, or one of its abbreviations such as `-Enc` or `-ec`: the workflow decodes them and documents the decoded command on the alert, both as a comment and as a new `command-line` observable. It then adds the IP addresses, URLs, domains, and hashes it finds as observables, extracted from the decoded command or from the raw command line when no encoding is present.

Before importing this template, [create a `command-line` observable type](../../thehive/administration/observable-types/create-an-observable-type.md) in TheHive. Without it, alerts can't carry the observables this workflow reads and creates.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Command lines to analyze: The *Set Command Line Array* node selects the `command-line` observables of the alert from the *Get Alert Observables* node output. Change its filter if your command lines use another observable type.
* Extraction patterns: The *If Base64 Encoded* condition detects the `-EncodedCommand` argument and its abbreviations, in any case and with a `-` or `/` prefix. The Python code nodes extract IOCs with regular expressions. They discard domain matches that are file names, such as `payload.ps1`, or PowerShell and .NET type names, such as `Net.WebClient`. Extend these patterns if your commands use other encodings or if you want to extract other data types.

??? example "Command line analysis template YAML"

    ```yaml
    version: v1.0.0
    spec_version: chocolate-v2.0.0
    id: playbook-01a13078-4228-71ca-93de-7e8eb6dd586a
    name: Command Line Analysis
    description: "Decodes Base64-encoded PowerShell commands found in the command-line observables of an alert and adds the extracted IOCs (IP, URL, domain, hash) as observables."
    timeout: 10m0s
    variables:
      input:
        - id: 484d4760-d74d-4927-82e2-3e11a263bd89
          name: TheHiveAlert
          type: string
        - id: 41336ad6-4c4f-4076-a3e8-bc3c5fe039c5
          name: alert_id
          type: string
    workflow_start: start--new-playbook--bd7096d6-201e-46ce-993f-a1c99b55ddd6
    workflow:
      0c857c79-c296-4247-b075-4f01b82089d0:
        id: 0c857c79-c296-4247-b075-4f01b82089d0
        name: Create Raw Observable
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_observable_in_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_observable_in_alert__alertId: '{{ $steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body._id }}'
            create_observable_in_alert__data: >-
              {{
              $steps["35e37c17-3fcc-4882-b3f6-596e79fe1f14"]["275dbcec-88ec-4671-85dd-40e9cb04118c"].data
              }}
            create_observable_in_alert__dataType: >-
              {{
              $steps["35e37c17-3fcc-4882-b3f6-596e79fe1f14"]["275dbcec-88ec-4671-85dd-40e9cb04118c"].dataType
              }}
            create_observable_in_alert__ignoreSimilarity: no_change
            create_observable_in_alert__ioc: no_change
            create_observable_in_alert__message: Extracted from command line via regex
            create_observable_in_alert__sighted: no_change
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 702
            'y': 717
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_observable_in_alert__data:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["35e37c17-3fcc-4882-b3f6-596e79fe1f14"]["275dbcec-88ec-4671-85dd-40e9cb04118c"]
                          type: variable
                        - type: text
                          value: .data
            command.parameters.create_observable_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_observable_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: Extracted from command line via regex
            command.parameters.create_observable_in_alert__dataType:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["35e37c17-3fcc-4882-b3f6-596e79fe1f14"]["275dbcec-88ec-4671-85dd-40e9cb04118c"]
                          type: variable
                        - type: text
                          value: .dataType
      0d87781c-739f-40e6-8e84-add53fa70554:
        id: 0d87781c-739f-40e6-8e84-add53fa70554
        name: Decode Base64
        type: action
        on_success:
          - 41035bf3-1836-4350-81da-67d81ade597c
          - f7eedfd1-22c7-4cd4-840a-9b679c7260a5
          - 3ff19619-cb57-4545-9f90-b61f3c159f6e
        command:
          command: strangebee.code.execute.python@v3_11
          version: v1.0.0
          type: strangebee
          parameters:
            script: >-
              import base64


              b64 =
              flow.get('$steps["0e244b75-e8f5-492d-8a1f-c3ed5f3dd836"]["ac73121f-cfc5-4cf2-b517-e156c1acdff2"]')


              decoded = base64.b64decode(b64).decode("utf-16-le")


              flow.set("b64_decode",decoded)
        ui:
          position:
            x: 234
            'y': 613
          variableInputs: {}
      0e244b75-e8f5-492d-8a1f-c3ed5f3dd836:
        id: 0e244b75-e8f5-492d-8a1f-c3ed5f3dd836
        name: Set Encoded Command Line
        type: action
        on_success: 0d87781c-739f-40e6-8e84-add53fa70554
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: ac73121f-cfc5-4cf2-b517-e156c1acdff2
                name: EncodeCommandLine
                type: string
                value: >-
                  {{
                  $steps["5f0f112a-b6b0-4458-b44a-218e8974e722"]["ee1a38ff-22d9-41cf-9a0f-ad728d1fb813"].data
                  | capture("(?i)[-/]e(?:c|n(?:c(?:o(?:d(?:e(?:d(?:c(?:o(?:m(?:m(?:a(?:n(?:d)?)?)?)?)?)?)?)?)?)?)?)?)?\\s+(?P<b64>[A-Za-z0-9+/]{20,}={0,2})") | .b64 }}
        ui:
          position:
            x: 234
            'y': 537
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["5f0f112a-b6b0-4458-b44a-218e8974e722"]["ee1a38ff-22d9-41cf-9a0f-ad728d1fb813"]
                            type: variable
                          - type: text
                            value: >-
                              .data |
                              capture("(?i)[-/]e(?:c|n(?:c(?:o(?:d(?:e(?:d(?:c(?:o(?:m(?:m(?:a(?:n(?:d)?)?)?)?)?)?)?)?)?)?)?)?)?\\s+(?P<b64>[A-Za-z0-9+/]{20,}={0,2})") |
                              .b64
      31721baf-87b1-4dd8-a12c-5072d7ed0cf0:
        id: 31721baf-87b1-4dd8-a12c-5072d7ed0cf0
        name: Get Alert
        type: action
        on_success: 87719176-dad5-4d20-a797-fc672593d9ca
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: get_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            get_alert__alertId: '{{ $input.payload.alert_id }}'
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 468
            'y': 157
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.get_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input.payload
                          type: variable
                        - type: text
                          value: .alert_id
      35e37c17-3fcc-4882-b3f6-596e79fe1f14:
        id: 35e37c17-3fcc-4882-b3f6-596e79fe1f14
        name: For Each Raw IOC
        type: foreach
        foreach:
          foreach: $steps["9673a43c-6478-4e2c-9239-a662e4c15ee5"].iocs
          key_variable: idx
          key_variable_id: 9979df16-c500-4703-b37e-a300053b8878
          value_variable: item
          value_variable_id: 275dbcec-88ec-4671-85dd-40e9cb04118c
          body: 0c857c79-c296-4247-b075-4f01b82089d0
        ui:
          position:
            x: 702
            'y': 613
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["9673a43c-6478-4e2c-9239-a662e4c15ee5"].iocs
                    type: variable
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      3ad6fed0-5376-4fad-b304-13f1181ee05d:
        id: 3ad6fed0-5376-4fad-b304-13f1181ee05d
        name: Create Decoded Observable
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_observable_in_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_observable_in_alert__alertId: '{{ $steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body._id }}'
            create_observable_in_alert__data: >-
              {{
              $steps["7a6dff56-9d50-4ecb-a8cd-9e59673da929"]["e6ff411b-9460-4cf1-8d53-067227faae0e"].data
              }}
            create_observable_in_alert__dataType: >-
              {{
              $steps["7a6dff56-9d50-4ecb-a8cd-9e59673da929"]["e6ff411b-9460-4cf1-8d53-067227faae0e"].dataType
              }}
            create_observable_in_alert__ignoreSimilarity: no_change
            create_observable_in_alert__ioc: no_change
            create_observable_in_alert__message: Extracted from decoded PowerShell command
            create_observable_in_alert__sighted: no_change
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 468
            'y': 869
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_observable_in_alert__data:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7a6dff56-9d50-4ecb-a8cd-9e59673da929"]["e6ff411b-9460-4cf1-8d53-067227faae0e"]
                          type: variable
                        - type: text
                          value: .data
            command.parameters.create_observable_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_observable_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: Extracted from decoded PowerShell command
            command.parameters.create_observable_in_alert__dataType:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7a6dff56-9d50-4ecb-a8cd-9e59673da929"]["e6ff411b-9460-4cf1-8d53-067227faae0e"]
                          type: variable
                        - type: text
                          value: .dataType
      3ff19619-cb57-4545-9f90-b61f3c159f6e:
        id: 3ff19619-cb57-4545-9f90-b61f3c159f6e
        name: Extract IOCs Decoded Command
        type: action
        on_success: 7a6dff56-9d50-4ecb-a8cd-9e59673da929
        command:
          command: strangebee.code.execute.python@v3_11
          version: v1.0.0
          type: strangebee
          parameters:
            script: >-
              import re


              cmd =
              flow.get('$steps["0d87781c-739f-40e6-8e84-add53fa70554"].b64_decode')
              or ""


              patterns = {
                  "ip":     r'\b(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\b',
                  "url":    r'https?://[^\s"\'<>]+',
                  "domain": r'\b(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}\b',
                  "hash":   r'\b[a-fA-F0-9]{64}\b|\b[a-fA-F0-9]{40}\b|\b[a-fA-F0-9]{32}\b',
              }


              # A "domain" match ending with one of these extensions is a file name

              FILE_EXTS = {
                  '.exe', '.dll', '.ps1', '.psm1', '.psd1', '.bat', '.cmd', '.sys', '.vbs', '.vbe',
                  '.js', '.jse', '.wsf', '.hta', '.msi', '.scr', '.cpl', '.ocx', '.drv', '.lnk',
                  '.bin', '.dat', '.tmp', '.log', '.txt', '.csv', '.ini', '.cfg', '.xml', '.json',
                  '.zip', '.rar', '.7z', '.gz', '.tar', '.cab', '.iso', '.img', '.jar', '.py',
                  '.sh', '.php', '.doc', '.docx', '.docm', '.xls', '.xlsx', '.xlsm', '.pdf',
                  '.rtf', '.png', '.jpg',
              }


              # Hosts of extracted URLs are always kept as domains, whatever their
              case

              url_hosts = {re.match(r'https?://([^/:?#]+)', u).group(1) for u in
              re.findall(patterns["url"], cmd)}


              def is_domain(match):
                  if match in url_hosts:
                      return True
                  labels = match.split(".")
                  # Mixed-case label = .NET / PowerShell type (Net.WebClient, System.IO.File)
                  if any(l != l.lower() and l != l.upper() for l in labels):
                      return False
                  return "." + labels[-1].lower() not in FILE_EXTS


              seen = set()

              iocs = []

              for dtype, pattern in patterns.items():
                  for match in re.findall(pattern, cmd):
                      if dtype == "domain" and not is_domain(match):
                          continue
                      key = f"{dtype}:{match}"
                      if key not in seen:
                          seen.add(key)
                          iocs.append({"dataType": dtype, "data": match})

              flow.set("iocs", iocs)
        ui:
          position:
            x: 468
            'y': 717
          variableInputs: {}
      41035bf3-1836-4350-81da-67d81ade597c:
        id: 41035bf3-1836-4350-81da-67d81ade597c
        name: Add Comment to Alert
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_comment_in_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_comment_in_alert__alertId: '{{ $steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body._id }}'
            create_comment_in_alert__message: >-
              Base64 encoded command line detected : {{
              $steps["0d87781c-739f-40e6-8e84-add53fa70554"].b64_decode }}
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 0
            'y': 717
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_comment_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_comment_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: 'Base64 encoded command line detected : '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["0d87781c-739f-40e6-8e84-add53fa70554"].b64_decode
                          type: variable
      5de1a4e2-b1f2-4391-8630-e692fef1c95a:
        id: 5de1a4e2-b1f2-4391-8630-e692fef1c95a
        name: Set Command Line Array
        type: action
        on_success: 5f0f112a-b6b0-4458-b44a-218e8974e722
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 1e242e7a-f988-43ab-861c-da86ed7f337f
                name: CommandLineArray
                type: array
                value: >-
                  {{ $steps["87719176-dad5-4d20-a797-fc672593d9ca"].body| [.[] |
                  select(.dataType == "command-line")] }}
        ui:
          position:
            x: 468
            'y': 309
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["87719176-dad5-4d20-a797-fc672593d9ca"].body
                            type: variable
                          - type: text
                            value: '| [.[] | select(.dataType == "command-line")]'
      5f0f112a-b6b0-4458-b44a-218e8974e722:
        id: 5f0f112a-b6b0-4458-b44a-218e8974e722
        name: For Each Command Line
        type: foreach
        foreach:
          foreach: $steps["5de1a4e2-b1f2-4391-8630-e692fef1c95a"]["1e242e7a-f988-43ab-861c-da86ed7f337f"]
          key_variable: idx
          key_variable_id: adbb9175-0627-475f-be28-72459912ac84
          value_variable: item
          value_variable_id: ee1a38ff-22d9-41cf-9a0f-ad728d1fb813
          body: 62907ebe-ef59-4709-b231-a42cce3f3d33
        ui:
          position:
            x: 468
            'y': 385
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["5de1a4e2-b1f2-4391-8630-e692fef1c95a"]["1e242e7a-f988-43ab-861c-da86ed7f337f"]
                    type: variable
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      62907ebe-ef59-4709-b231-a42cce3f3d33:
        id: 62907ebe-ef59-4709-b231-a42cce3f3d33
        name: If Base64 Encoded
        type: if-condition
        condition: >-
          $steps["5f0f112a-b6b0-4458-b44a-218e8974e722"]["ee1a38ff-22d9-41cf-9a0f-ad728d1fb813"].data
          | test("(?i)[-/]e(?:c|n(?:c(?:o(?:d(?:e(?:d(?:c(?:o(?:m(?:m(?:a(?:n(?:d)?)?)?)?)?)?)?)?)?)?)?)?)?\\s+[A-Za-z0-9+/]{20,}={0,2}")
        on_true: 0e244b75-e8f5-492d-8a1f-c3ed5f3dd836
        on_false: 9673a43c-6478-4e2c-9239-a662e4c15ee5
        ui:
          position:
            x: 468
            'y': 461
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - key: steps["5f0f112a-b6b0-4458-b44a-218e8974e722"]["ee1a38ff-22d9-41cf-9a0f-ad728d1fb813"]
                    type: variable
                  - type: text
                    value: .data | test("(?i)[-/]e(?:c|n(?:c(?:o(?:d(?:e(?:d(?:c(?:o(?:m(?:m(?:a(?:n(?:d)?)?)?)?)?)?)?)?)?)?)?)?)?\\s+[A-Za-z0-9+/]{20,}={0,2}")
      7a6dff56-9d50-4ecb-a8cd-9e59673da929:
        id: 7a6dff56-9d50-4ecb-a8cd-9e59673da929
        name: For Each Decoded IOC
        type: foreach
        foreach:
          foreach: $steps["3ff19619-cb57-4545-9f90-b61f3c159f6e"].iocs
          key_variable: idx
          key_variable_id: 6e188896-b2a2-42e8-b57c-f6b1790c7b2c
          value_variable: item
          value_variable_id: e6ff411b-9460-4cf1-8d53-067227faae0e
          body: 3ad6fed0-5376-4fad-b304-13f1181ee05d
        ui:
          position:
            x: 468
            'y': 793
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["3ff19619-cb57-4545-9f90-b61f3c159f6e"].iocs
                    type: variable
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      87719176-dad5-4d20-a797-fc672593d9ca:
        id: 87719176-dad5-4d20-a797-fc672593d9ca
        name: Get Alert Observables
        type: action
        on_success: 5de1a4e2-b1f2-4391-8630-e692fef1c95a
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: post_query
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            manual_status_handling: false
            post_query__query: |-
              [
                      {
                          "_name": "getAlert",
                          "idOrName": "{{ $steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body._id }}"
                      },
                      {
                          "_name": "observables"
                      }
              ]
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 468
            'y': 233
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      [
                              {
                                  "_name": "getAlert",
                                  "idOrName": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: |-
                      "
                              },
                              {
                                  "_name": "observables"
                              }
                      ]
      9673a43c-6478-4e2c-9239-a662e4c15ee5:
        id: 9673a43c-6478-4e2c-9239-a662e4c15ee5
        name: Extract IOCs Raw Command
        type: action
        on_success: 35e37c17-3fcc-4882-b3f6-596e79fe1f14
        command:
          command: strangebee.code.execute.python@v3_11
          version: v1.0.0
          type: strangebee
          parameters:
            script: >-
              import re

              import json


              cmd =
              flow.get('$steps["5f0f112a-b6b0-4458-b44a-218e8974e722"]["ee1a38ff-22d9-41cf-9a0f-ad728d1fb813"]').get("data")
              or ""


              patterns = {
                  "ip":     r'\b(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\b',
                  "url":    r'https?://[^\s"\'<>]+',
                  "domain": r'\b(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}\b',
                  "hash":   r'\b[a-fA-F0-9]{64}\b|\b[a-fA-F0-9]{40}\b|\b[a-fA-F0-9]{32}\b',
              }


              # A "domain" match ending with one of these extensions is a file name

              FILE_EXTS = {
                  '.exe', '.dll', '.ps1', '.psm1', '.psd1', '.bat', '.cmd', '.sys', '.vbs', '.vbe',
                  '.js', '.jse', '.wsf', '.hta', '.msi', '.scr', '.cpl', '.ocx', '.drv', '.lnk',
                  '.bin', '.dat', '.tmp', '.log', '.txt', '.csv', '.ini', '.cfg', '.xml', '.json',
                  '.zip', '.rar', '.7z', '.gz', '.tar', '.cab', '.iso', '.img', '.jar', '.py',
                  '.sh', '.php', '.doc', '.docx', '.docm', '.xls', '.xlsx', '.xlsm', '.pdf',
                  '.rtf', '.png', '.jpg',
              }


              # Hosts of extracted URLs are always kept as domains, whatever their
              case

              url_hosts = {re.match(r'https?://([^/:?#]+)', u).group(1) for u in
              re.findall(patterns["url"], cmd)}


              def is_domain(match):
                  if match in url_hosts:
                      return True
                  labels = match.split(".")
                  # Mixed-case label = .NET / PowerShell type (Net.WebClient, System.IO.File)
                  if any(l != l.lower() and l != l.upper() for l in labels):
                      return False
                  return "." + labels[-1].lower() not in FILE_EXTS


              seen = set()

              iocs = []

              for dtype, pattern in patterns.items():
                  for match in re.findall(pattern, cmd):
                      if dtype == "domain" and not is_domain(match):
                          continue
                      key = f"{dtype}:{match}"
                      if key not in seen:
                          seen.add(key)
                          iocs.append({"dataType": dtype, "data": match})

              flow.set("iocs", iocs)
        ui:
          position:
            x: 702
            'y': 537
          variableInputs: {}
      f7eedfd1-22c7-4cd4-840a-9b679c7260a5:
        id: f7eedfd1-22c7-4cd4-840a-9b679c7260a5
        name: Create Observable for Decoded Command
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_observable_in_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_observable_in_alert__alertId: '{{ $steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body._id }}'
            create_observable_in_alert__data: '{{ $steps["0d87781c-739f-40e6-8e84-add53fa70554"].b64_decode }}'
            create_observable_in_alert__dataType: command-line
            create_observable_in_alert__ignoreSimilarity: no_change
            create_observable_in_alert__ioc: no_change
            create_observable_in_alert__message: >-
              command obfuscated behind the following Base64: {{
              $steps["0e244b75-e8f5-492d-8a1f-c3ed5f3dd836"]["ac73121f-cfc5-4cf2-b517-e156c1acdff2"]
              }}
            create_observable_in_alert__sighted: no_change
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 234
            'y': 717
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_comment_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_comment_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: 'Base64 encoded command line detected : '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["0d87781c-739f-40e6-8e84-add53fa70554"].b64_decode
                          type: variable
            command.parameters.create_observable_in_alert__data:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["0d87781c-739f-40e6-8e84-add53fa70554"].b64_decode
                          type: variable
            command.parameters.create_observable_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["31721baf-87b1-4dd8-a12c-5072d7ed0cf0"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_observable_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: 'command obfuscated behind the following Base64: '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["0e244b75-e8f5-492d-8a1f-c3ed5f3dd836"]["ac73121f-cfc5-4cf2-b517-e156c1acdff2"]
                          type: variable
            command.parameters.create_observable_in_alert__dataType:
              wireDoc:
                nodes:
                  - type: text
                    value: command-line
      start--new-playbook--bd7096d6-201e-46ce-993f-a1c99b55ddd6:
        id: start--new-playbook--bd7096d6-201e-46ce-993f-a1c99b55ddd6
        type: start
        on_success: 31721baf-87b1-4dd8-a12c-5072d7ed0cf0
        ui:
          position:
            x: 468
            'y': 0
    created_by: admin@thehive.local
    created: '2026-10-12T14:15:50.056118Z'
    modified_by: admin@thehive.local
    modified: '2026-10-12T14:19:02.644201Z'
    ```

## GetCVECircl

The *GetCVECircl* template turns the CVEs published by [CIRCL](https://cve.circl.lu){target=_blank} for a given vendor and product into alerts in TheHive.

The workflow queries the CIRCL search API for the configured vendor and product and keeps the entries that are complete CVE records. It creates one alert per CVE with the type `CVE`, the source `CIRCL`, and the CVE identifier as source reference. Each alert carries a structured description covering the technical description, the affected product and versions, the vulnerability type, recommended actions, and references.

TheHive [rejects an alert matching the type, source, and source reference of an existing one](../../thehive/user-guides/analyst-corner/alerts/about-alerts.md#uniqueness), so a new run fails on the CVEs already imported rather than duplicating them. [Run it manually from the workflow editor](manually-run-workflow.md#run-a-workflow-from-the-workflow-editor), or [add a *Scheduler* trigger](add-trigger.md#add-a-scheduler-trigger) to fetch new CVEs at a regular interval.

The [Build Your First Workflow](build-your-first-workflow.md) tutorial builds a simplified version of this workflow step by step. Import this template to get the result directly, or follow the tutorial to learn the underlying concepts along the way.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Vendor and product: The *Set vendor + product* node ships with `apple` and `macos`. Set the two variables to the vendor and product you monitor, spelled as the CIRCL API expects them.
* Alert description: The *Set Alert Title & Description* node reads the first entry of each list in the CVE record, such as the first affected product and the first reference. Adapt the description template if you need other fields.
* Server verification: The *Get CVE Circl* node ships with **Certificate Authorities** set to **Disabled**, so it doesn't verify the identity of the CIRCL server. Set it to **Default** unless a proxy on your network intercepts TLS traffic.

??? example "GetCVECircl template YAML"

    ```yaml
    version: v1.0.0
    spec_version: chocolate-v2.0.0
    id: playbook-01a1305e-1e22-73c0-9d94-97a3fb4f18d4
    name: GetCVECircl
    description: "Creates a TheHive alert for each CVE returned by the CIRCL API for a vendor/product pair."
    timeout: 10m0s
    workflow_start: start--new-playbook--971f5e82-4d48-49fe-be92-61923e178913
    workflow:
      0a74585b-4a6f-40e8-93ed-8beb89b45772:
        id: 0a74585b-4a6f-40e8-93ed-8beb89b45772
        name: Set Alert Title & Description
        type: action
        on_success: 16616c00-7b7f-4bd4-8ca0-e745db32277f
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 2b128083-f67d-4379-9675-d3e37fc8831a
                name: alertTitle
                type: string
                value: >-
                  New CVE : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].cveMetadata.cveId
                  }}
              - id: cac9fc9f-4872-4cc9-8b50-e970c9ae4624
                name: alertDescription
                type: string
                value: >-
                  # **[VULNERABILITY] {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].cveMetadata.cveId
                  }}** - {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.title
                  }}


                  ## TECHNICAL DESCRIPTION

                  {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.descriptions[0].value
                  }}


                  ## GENERAL INFORMATION

                  - CVE ID : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].cveMetadata.cveId
                  }}

                  - Title : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.title
                  }}

                  - Publication date : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].cveMetadata.datePublished
                  }}

                  - Status : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].cveMetadata.state
                  }}

                  - Source : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.providerMetadata.shortName
                  }}

                  - Discoverer : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.credits[0].value
                  }}

                  - Discovery type : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.source.discovery
                  }}


                  ## AFFECTED ASSET

                  - Product : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.affected[0].product
                  }}

                  - Vendor : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.affected[0].vendor
                  }}

                  - Vulnerable versions : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.affected[0].versions[0].version
                  }} to {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.affected[0].versions[0].lessThanOrEqual
                  }}

                  - Version status : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.affected[0].versions[0].status
                  }}

                  - Default status : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.affected[0].defaultStatus
                  }}


                  ## VULNERABILITY

                  - Type : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.problemTypes[0].descriptions[0].description
                  }}

                  - CWE : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.problemTypes[0].descriptions[0].type
                  }}


                  ## RECOMMENDED ACTIONS

                  1. Identify systems running {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.affected[0].product
                  }} vulnerable version(s)

                  2. Review logs to detect exploitation attempts

                  3. Apply available security patches

                  4. Implement temporary mitigation measures if necessary

                  5. Monitor vendor security advisories


                  ## REFERENCES

                  - URL : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.references[0].url
                  }}

                  - Tags : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].containers.cna.references[0].tags
                  }}

                  - Last updated : {{
                  $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].cveMetadata.dateUpdated
                  }}
        ui:
          position:
            x: 0
            'y': 613
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: text
                      value: 'New CVE : '
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .cveMetadata.cveId
                - nodes:
                    - type: text
                      value: "# **[VULNERABILITY] "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .cveMetadata.cveId
                    - type: text
                      value: "** - "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.title
                    - type: text
                      value: "\n\n## TECHNICAL DESCRIPTION\n"
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.descriptions[0].value
                    - type: text
                      value: "\n\n## GENERAL INFORMATION\n- CVE ID : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .cveMetadata.cveId
                    - type: text
                      value: "\n- Title : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.title
                    - type: text
                      value: "\n- Publication date : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .cveMetadata.datePublished
                    - type: text
                      value: "\n- Status : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .cveMetadata.state
                    - type: text
                      value: "\n- Source : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.providerMetadata.shortName
                    - type: text
                      value: "\n- Discoverer : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.credits[0].value
                    - type: text
                      value: "\n- Discovery type : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.source.discovery
                    - type: text
                      value: "\n\n## AFFECTED ASSET\n- Product : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.affected[0].product
                    - type: text
                      value: "\n- Vendor : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.affected[0].vendor
                    - type: text
                      value: "\n- Vulnerable versions : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.affected[0].versions[0].version
                    - type: text
                      value: " to "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.affected[0].versions[0].lessThanOrEqual
                    - type: text
                      value: "\n- Version status : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.affected[0].versions[0].status
                    - type: text
                      value: "\n- Default status : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.affected[0].defaultStatus
                    - type: text
                      value: "\n\n## VULNERABILITY\n- Type : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.problemTypes[0].descriptions[0].description
                    - type: text
                      value: "\n- CWE : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.problemTypes[0].descriptions[0].type
                    - type: text
                      value: "\n\n## RECOMMENDED ACTIONS\n1. Identify systems running "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.affected[0].product
                    - type: text
                      value: " vulnerable version(s)\n2. Review logs to detect exploitation attempts\n3. Apply available security patches\n4. Implement temporary mitigation measures if necessary\n5. Monitor vendor security advisories\n\n## REFERENCES\n- URL : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.references[0].url
                    - type: text
                      value: "\n- Tags : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .containers.cna.references[0].tags
                    - type: text
                      value: "\n- Last updated : "
                    - type: context
                      expression:
                        nodes:
                          - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                            type: variable
                          - type: text
                            value: .cveMetadata.dateUpdated
      16616c00-7b7f-4bd4-8ca0-e745db32277f:
        id: 16616c00-7b7f-4bd4-8ca0-e745db32277f
        name: TheHive Create Alert
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_alert__description: >-
              {{
              $steps["0a74585b-4a6f-40e8-93ed-8beb89b45772"]["cac9fc9f-4872-4cc9-8b50-e970c9ae4624"]
              }}
            create_alert__flag: no_change
            create_alert__source: CIRCL
            create_alert__sourceRef: >-
              {{
              $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].cveMetadata.cveId
              }}
            create_alert__title: >-
              {{
              $steps["0a74585b-4a6f-40e8-93ed-8beb89b45772"]["2b128083-f67d-4379-9675-d3e37fc8831a"]
              }}
            create_alert__type: CVE
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 0
            'y': 689
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_alert__type:
              wireDoc:
                nodes:
                  - type: text
                    value: CVE
            command.parameters.create_alert__title:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["0a74585b-4a6f-40e8-93ed-8beb89b45772"]["2b128083-f67d-4379-9675-d3e37fc8831a"]
                          type: variable
            command.parameters.create_alert__source:
              wireDoc:
                nodes:
                  - type: text
                    value: CIRCL
            command.parameters.create_alert__sourceRef:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                          type: variable
                        - type: text
                          value: .cveMetadata.cveId
            command.parameters.create_alert__description:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["0a74585b-4a6f-40e8-93ed-8beb89b45772"]["cac9fc9f-4872-4cc9-8b50-e970c9ae4624"]
                          type: variable
      66428236-b136-43f1-a67a-45f8cadb5f06:
        id: 66428236-b136-43f1-a67a-45f8cadb5f06
        name: Get CVE Circl
        type: action
        on_success: 9519559d-7b7d-46a0-857c-1830de67e093
        command:
          command: strangebee.http.request
          version: v1.0.0
          type: strangebee
          parameters:
            method: GET
            ssl_mtls: disabled
            ssl_verification: disabled
            url: >-
              https://cve.circl.lu/api/search/{{
              $steps["c88c4fb1-20cf-45c7-af74-549408b40279"]["32947acb-72c2-4707-8dfc-94d1ca545471"]
              }}/{{
              $steps["c88c4fb1-20cf-45c7-af74-549408b40279"]["63527d42-7485-42b1-b140-3f13e3c5255f"]
              }}
        ui:
          position:
            x: 142
            'y': 233
          variableInputs:
            command.parameters.url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://cve.circl.lu/api/search/
                  - type: context
                    expression:
                      nodes:
                        - key: steps["c88c4fb1-20cf-45c7-af74-549408b40279"]["32947acb-72c2-4707-8dfc-94d1ca545471"]
                          type: variable
                  - type: text
                    value: /
                  - type: context
                    expression:
                      nodes:
                        - key: steps["c88c4fb1-20cf-45c7-af74-549408b40279"]["63527d42-7485-42b1-b140-3f13e3c5255f"]
                          type: variable
          optionalSections:
            - ssl
      9519559d-7b7d-46a0-857c-1830de67e093:
        id: 9519559d-7b7d-46a0-857c-1830de67e093
        name: CVE List
        type: action
        on_success: b7bb028d-9891-4e01-ad6c-83197c0a49fd
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 137b872a-a185-4ab3-8dbe-680d3e62d8aa
                name: CveList
                type: array
                value: >-
                  {{ $steps["66428236-b136-43f1-a67a-45f8cadb5f06"].body.results.nvd
                  }}
        ui:
          position:
            x: 142
            'y': 309
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["66428236-b136-43f1-a67a-45f8cadb5f06"].body
                            type: variable
                          - type: text
                            value: .results.nvd
      b7bb028d-9891-4e01-ad6c-83197c0a49fd:
        id: b7bb028d-9891-4e01-ad6c-83197c0a49fd
        name: For Each CVE
        type: foreach
        foreach:
          foreach: $steps["9519559d-7b7d-46a0-857c-1830de67e093"]["137b872a-a185-4ab3-8dbe-680d3e62d8aa"]
          key_variable: idx
          key_variable_id: f0700857-1ce8-43ad-8190-c68f08e47a73
          value_variable: item
          value_variable_id: fe4cc3bc-ac42-46f3-bd98-5c162253a56e
          body: d85ad15b-e145-488f-94a6-fa17a6b08892
        ui:
          position:
            x: 142
            'y': 385
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["9519559d-7b7d-46a0-857c-1830de67e093"]["137b872a-a185-4ab3-8dbe-680d3e62d8aa"]
                    type: variable
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      c88c4fb1-20cf-45c7-af74-549408b40279:
        id: c88c4fb1-20cf-45c7-af74-549408b40279
        name: Set vendor + product
        type: action
        on_success: 66428236-b136-43f1-a67a-45f8cadb5f06
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 32947acb-72c2-4707-8dfc-94d1ca545471
                name: vendor
                type: string
                value: apple
              - id: 63527d42-7485-42b1-b140-3f13e3c5255f
                name: product
                type: string
                value: macos
        ui:
          position:
            x: 142
            'y': 157
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: text
                      value: apple
                - nodes:
                    - type: text
                      value: macos
      d85ad15b-e145-488f-94a6-fa17a6b08892:
        id: d85ad15b-e145-488f-94a6-fa17a6b08892
        name: Set CVE Occurrence
        type: action
        on_success: f6776982-b703-4b58-be7f-b6fa42612fb2
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: a4094c71-e8ed-489d-9fce-416d076590db
                name: CVE
                type: object
                value: >-
                  {{
                  $steps["b7bb028d-9891-4e01-ad6c-83197c0a49fd"]["fe4cc3bc-ac42-46f3-bd98-5c162253a56e"][1]
                  }}
        ui:
          position:
            x: 142
            'y': 461
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["b7bb028d-9891-4e01-ad6c-83197c0a49fd"]["fe4cc3bc-ac42-46f3-bd98-5c162253a56e"]
                            type: variable
                          - type: text
                            value: '[1]'
      f6776982-b703-4b58-be7f-b6fa42612fb2:
        id: f6776982-b703-4b58-be7f-b6fa42612fb2
        name: If CVE Record
        type: if-condition
        condition: >-
          $steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"].dataType
          == "CVE_RECORD"
        on_true: 0a74585b-4a6f-40e8-93ed-8beb89b45772
        ui:
          position:
            x: 142
            'y': 537
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - key: steps["d85ad15b-e145-488f-94a6-fa17a6b08892"]["a4094c71-e8ed-489d-9fce-416d076590db"]
                    type: variable
                  - type: text
                    value: .dataType == "CVE_RECORD"
      start--new-playbook--971f5e82-4d48-49fe-be92-61923e178913:
        id: start--new-playbook--971f5e82-4d48-49fe-be92-61923e178913
        type: start
        on_success: c88c4fb1-20cf-45c7-af74-549408b40279
        ui:
          position:
            x: 142
            'y': 0
    created_by: admin@thehive.local
    created: '2026-10-12T13:47:16.898246Z'
    modified_by: admin@thehive.local
    modified: '2026-10-12T13:52:20.356777Z'
    ```

## Slack alert manager

The *Slack alert manager* template lets your team triage new TheHive alerts directly from Slack: an emoji reaction acknowledges the alert, raises its severity, or closes it as a false positive.

A [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger) wired to a [TheHive notification](../../thehive/user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) starts the workflow when an alert is created. The workflow posts a message announcing the alert title and severity in a Slack channel, then watches the message for about 3 minutes. Emoji reactions drive actions on the alert in TheHive:

| Reaction | Action in TheHive |
|---|---|
| `:hand:` | Adds a comment acknowledging the alert with the name of the Slack user who reacted |
| `:exclamation:` | Sets the alert severity to *Critical* |
| `:x:` | Sets the alert status to *FalsePositive* |

The workflow also copies new Slack thread replies to the alert as comments.

Before importing this template, [create a secret global variable](manage-global-variables.md#create-a-global-variable) holding your Slack bot token. The token needs the `chat:write`, `reactions:read`, `channels:history`, and `users:read` scopes, or `groups:history` instead of `channels:history` for a private channel. Invite the bot to the channel the workflow posts in.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Slack credentials: Select your secret global variable instead of the `<SLACK_BOT_TOKEN>` placeholder in the **Bearer token** field of every [*Slack* node](configure-integration-node.md#configure-a-slack-integration-node). In the *Slack Send Message* node, replace the `<SLACK_CHANNEL_ID>` placeholder with the identifier of the channel to post in.
* Trigger: [Add a *Webhook* trigger](add-trigger.md#add-a-webhook-trigger) to the workflow. In its **Workflow input** section, assign `$request.body` to the `TheHiveAlert` input variable. Then create the notification in TheHive with the *AlertCreated* trigger and a *Webhook* notifier pointing to the trigger URL.
* Email notification: The *Send Email - Critical Alert* node ships with `N/A` placeholders and no branch to the rest of the workflow. To notify by email when an alert turns critical, set the sender and recipient addresses and add a branch to the node from the *Update Alert - Severity Critical* node. Otherwise, remove it.
* Alert status: The `:x:` reaction sets the *FalsePositive* status. Change it if your organization uses other [alert statuses](../../thehive/administration/status/about-statuses.md).
* Watch duration: The *For Each (While)* loop runs nine iterations with a 20-second pause. Reactions and replies added afterward are ignored. Increase these values to watch reactions for longer, within the 1-hour timeout of the workflow.

??? example "Slack alert manager template YAML"

    ```yaml
    version: v1.0.0
    spec_version: chocolate-v2.0.0
    id: playbook-01a07c23-dfc8-7d81-ad51-b9392ca4435a
    name: Slack Alert Manager
    description: "Posts each new TheHive alert to Slack, then polls for 9 cycles (about 3 minutes) to triage it from emoji reactions (critical, false positive, acknowledge) and copy thread replies as alert comments. The polling loop is a ForEach over range(1;10), standing in for a While node, which TheHive Flow doesn't provide."
    timeout: 1h0m0s
    variables:
      input:
        - id: 3c77345a-f5ac-467c-be5e-0a80da3c25fe
          name: TheHiveAlert
          type: object
    workflow_start: start--new-playbook--9f02b2a4-76dc-4f46-8ca4-6a36d5e12876
    workflow:
      0307ae94-ef69-467c-b907-def6775b748f:
        id: 0307ae94-ef69-467c-b907-def6775b748f
        name: Update Alert - Severity Critical
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: update_alert
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
            update_alert__alertId: '{{ $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details._id }}'
            update_alert__follow: no_change
            update_alert__severity: 4
        ui:
          position:
            x: 182.9472
            'y': 827.072
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.update_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details._id
      0836526c-5035-450a-bc40-ba04709eec19:
        id: 0836526c-5035-450a-bc40-ba04709eec19
        name: Update Alert - False Positive
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: update_alert
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
            update_alert__alertId: '{{ $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details._id }}'
            update_alert__follow: no_change
            update_alert__status: FalsePositive
        ui:
          position:
            x: 749.8688000000001
            'y': 833.4912
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.update_alert__status:
              wireDoc:
                nodes:
                  - type: text
                    value: FalsePositive
            command.parameters.update_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details._id
      234afd9b-a38c-4a85-a8fd-0daa277ae93f:
        id: 234afd9b-a38c-4a85-a8fd-0daa277ae93f
        name: Comment - acknowledged via Slack
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: create_comment_in_alert
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            create_comment_in_alert__alertId: '{{ $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details._id }}'
            create_comment_in_alert__message: >-
              Acknowledged via Slack by user : {{
              $steps["fc3b3d9f-5874-4550-b173-80ba55741c9e"].body.user.real_name }}
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 418.55199999999996
            'y': 1009.5631999999999
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.create_comment_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details._id
            command.parameters.create_comment_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: 'Acknowledged via Slack by user : '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["fc3b3d9f-5874-4550-b173-80ba55741c9e"].body
                          type: variable
                        - type: text
                          value: .user.real_name
      2426e4a1-34c8-48a4-8bc8-b8deddcdf029:
        id: 2426e4a1-34c8-48a4-8bc8-b8deddcdf029
        name: For Each (While)
        type: foreach
        foreach:
          foreach: range(1;10)
          key_variable: idx
          key_variable_id: 175771b6-70d9-4cca-a956-75d612365cdb
          value_variable: item
          value_variable_id: c812a5c2-2093-4dc7-bbef-c6dce2415c2f
          body: c3d85645-f6c6-4a1c-9a22-5035a8379e6a
        ui:
          position:
            x: 690.6666666666666
            'y': 233
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - type: text
                    value: range(1;10)
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      321049cc-f0d1-4bbe-ac44-85d454c4f490:
        id: 321049cc-f0d1-4bbe-ac44-85d454c4f490
        name: If "exclamation" reaction and severity not yet critical
        type: if-condition
        condition: >-
          ($steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"].name
          == "exclamation") and
          ($steps["7f3a9c1e-2b4d-4a6f-8c3e-9d1b5a7f2e6c"].body.severity != 4)
        on_true: 0307ae94-ef69-467c-b907-def6775b748f
        ui:
          position:
            x: 234
            'y': 727
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - type: text
                    value: (
                  - key: steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"]
                    type: variable
                  - type: text
                    value: .name == "exclamation") and (
                  - key: steps["7f3a9c1e-2b4d-4a6f-8c3e-9d1b5a7f2e6c"].body
                    type: variable
                  - type: text
                    value: .severity != 4)
      369c34f4-e7d7-48f2-adfe-cd2fa6e1db50:
        id: 369c34f4-e7d7-48f2-adfe-cd2fa6e1db50
        name: If "x" reaction and not already False Positive
        type: if-condition
        condition: >-
          ($steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"].name
          == "x") and ($steps["7f3a9c1e-2b4d-4a6f-8c3e-9d1b5a7f2e6c"].body.status !=
          "FalsePositive")
        on_true: 0836526c-5035-450a-bc40-ba04709eec19
        ui:
          position:
            x: 802
            'y': 727
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - type: text
                    value: (
                  - key: steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"]
                    type: variable
                  - type: text
                    value: .name == "x") and (
                  - key: steps["7f3a9c1e-2b4d-4a6f-8c3e-9d1b5a7f2e6c"].body
                    type: variable
                  - type: text
                    value: .status != "FalsePositive")
      3d781a50-1355-405a-909b-a07b98cc0fa9:
        id: 3d781a50-1355-405a-909b-a07b98cc0fa9
        name: Slack Get Replies
        type: action
        on_success: d4e6f8a0-3b5c-4dab-9012-c3d4e5f6a7b8
        command:
          command: strangebee.integration.slack.2.0.0
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: get_thread_replies
            auth_type: bearer_token
            base_url: https://slack.com/api
            bearer_token: '<SLACK_BOT_TOKEN>'
            get_thread_replies__query_params:
              - name: channel
                value: '{{ $steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body.channel }}'
              - name: ts
                value: '{{ $steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body.ts }}'
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 1036
            'y': 727
          variableInputs:
            command.parameters.get_thread_replies__query_params:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body
                            type: variable
                          - type: text
                            value: .channel
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body
                            type: variable
                          - type: text
                            value: .ts
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://slack.com/api
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<SLACK_BOT_TOKEN>'
      57ed6553-5bd3-4f02-bcfd-85efd7f1fda6:
        id: 57ed6553-5bd3-4f02-bcfd-85efd7f1fda6
        name: If "hand" reaction
        type: if-condition
        condition: >-
          $steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"].name
          == "hand"
        on_true: c3d5f7b9-4a2e-4bcd-8ef0-b2c3d4e5f6a7
        ui:
          position:
            x: 518
            'y': 727
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - key: steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"]
                    type: variable
                  - type: text
                    value: .name == "hand"
      7f3a9c1e-2b4d-4a6f-8c3e-9d1b5a7f2e6c:
        id: 7f3a9c1e-2b4d-4a6f-8c3e-9d1b5a7f2e6c
        name: Get Alert (Fresh State)
        type: action
        on_success: ed2eced1-3cce-43d9-8adf-424f41ae5ef1
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: get_alert
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            get_alert__alertId: '{{ $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details._id }}'
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 690.6666666666666
            'y': 385
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.get_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details._id
      a3b4c5d6-7e8f-4091-a213-c4d5e6f7a8b9:
        id: a3b4c5d6-7e8f-4091-a213-c4d5e6f7a8b9
        name: If Reply Not Already Logged
        type: if-condition
        condition: >-
          ($steps["b2c4e6a8-2f1a-4abc-9def-a1b2c3d4e5f6"].body | [.[] |
          select(.message |
          contains($steps["d4e6f8a0-3b5c-4dab-9012-c3d4e5f6a7b8"]["f2a3b4c5-6d7e-4f80-9102-b3c4d5e6f7a8"].text))]
          | length) == 0
        on_true: acb65564-24ea-4f13-bbf1-94c0f56cc28e
        ui:
          position:
            x: 1036
            'y': 879
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - type: text
                    value: (
                  - key: steps["b2c4e6a8-2f1a-4abc-9def-a1b2c3d4e5f6"].body
                    type: variable
                  - type: text
                    value: ' | [.[] | select(.message | contains('
                  - key: steps["d4e6f8a0-3b5c-4dab-9012-c3d4e5f6a7b8"]["f2a3b4c5-6d7e-4f80-9102-b3c4d5e6f7a8"]
                    type: variable
                  - type: text
                    value: .text))] | length) == 0
      ab91afe4-1fca-4c89-8393-a86d308b1a07:
        id: ab91afe4-1fca-4c89-8393-a86d308b1a07
        name: Slack Send Message
        type: action
        on_success: 2426e4a1-34c8-48a4-8bc8-b8deddcdf029
        command:
          command: strangebee.integration.slack.2.0.0
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: post_message
            auth_type: bearer_token
            base_url: https://slack.com/api
            bearer_token: '<SLACK_BOT_TOKEN>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
            post_message__channel: '<SLACK_CHANNEL_ID>'
            post_message__mrkdwn: 'true'
            post_message__text: >-
              New alert created in TheHive : {{
              $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details.title }} ,
              Severity : {{
              $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details.severity }}
            post_message__unfurl_links: no_change
        ui:
          position:
            x: 690.6666666666666
            'y': 157
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://slack.com/api
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<SLACK_BOT_TOKEN>'
            command.parameters.post_message__text:
              wireDoc:
                nodes:
                  - type: text
                    value: 'New alert created in TheHive : '
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details.title
                  - type: text
                    value: ' , Severity : '
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details.severity
            command.parameters.post_message__channel:
              wireDoc:
                nodes:
                  - type: text
                    value: '<SLACK_CHANNEL_ID>'
      acb65564-24ea-4f13-bbf1-94c0f56cc28e:
        id: acb65564-24ea-4f13-bbf1-94c0f56cc28e
        name: Comment - new thread reply
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: create_comment_in_alert
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            create_comment_in_alert__alertId: '{{ $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details._id }}'
            create_comment_in_alert__message: >-
              Slack thread reply: {{
              $steps["d4e6f8a0-3b5c-4dab-9012-c3d4e5f6a7b8"]["f2a3b4c5-6d7e-4f80-9102-b3c4d5e6f7a8"].text
              }}
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 987.5168
            'y': 987.096
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.create_comment_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details._id
            command.parameters.create_comment_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: 'Slack thread reply: '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["d4e6f8a0-3b5c-4dab-9012-c3d4e5f6a7b8"]["f2a3b4c5-6d7e-4f80-9102-b3c4d5e6f7a8"]
                          type: variable
                        - type: text
                          value: .text
      b2c4e6a8-2f1a-4abc-9def-a1b2c3d4e5f6:
        id: b2c4e6a8-2f1a-4abc-9def-a1b2c3d4e5f6
        name: Get Alert Comments
        type: action
        on_success: e0b96ab0-017b-4d67-8a70-cbcd591786e3
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: post_query
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
            post_query__query: |-
              [
                      {
                          "_name": "getAlert",
                          "idOrName": "{{ $input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"].details._id }}"
                      },
                      {
                          "_name": "comments"
                      }
              ]
        ui:
          position:
            x: 690.6666666666666
            'y': 537
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      [
                              {
                                  "_name": "getAlert",
                                  "idOrName": "
                  - type: context
                    expression:
                      nodes:
                        - key: input["3c77345a-f5ac-467c-be5e-0a80da3c25fe"]
                          type: variable
                        - type: text
                          value: .details._id
                  - type: text
                    value: |-
                      "
                              },
                              {
                                  "_name": "comments"
                              }
                      ]
      bcc7862d-3780-447e-991c-d159782cba54:
        id: bcc7862d-3780-447e-991c-d159782cba54
        name: Send Email - Critical Alert
        type: action
        command:
          command: strangebee.message.email
          version: v1.0.0
          type: strangebee
          parameters:
            body_format: text
            from: N/A
            to: N/A
        ui:
          position:
            x: 179.7376
            'y': 919.12
          variableInputs:
            command.parameters.from:
              wireDoc:
                nodes:
                  - type: text
                    value: N/A
            command.parameters.to:
              wireDoc:
                nodes:
                  - type: text
                    value: N/A
      c3d5f7b9-4a2e-4bcd-8ef0-b2c3d4e5f6a7:
        id: c3d5f7b9-4a2e-4bcd-8ef0-b2c3d4e5f6a7
        name: If Not Already Acknowledged
        type: if-condition
        condition: >-
          ($steps["b2c4e6a8-2f1a-4abc-9def-a1b2c3d4e5f6"].body | [.[] |
          select(.message | test("Acknowledged via Slack"))] | length) == 0
        on_true: fc3b3d9f-5874-4550-b173-80ba55741c9e
        ui:
          position:
            x: 465.8688
            'y': 822.2575999999999
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - type: text
                    value: (
                  - key: steps["b2c4e6a8-2f1a-4abc-9def-a1b2c3d4e5f6"].body
                    type: variable
                  - type: text
                    value: ' | [.[] | select(.message | test("Acknowledged via Slack"))] | length) == 0'
      c3d85645-f6c6-4a1c-9a22-5035a8379e6a:
        id: c3d85645-f6c6-4a1c-9a22-5035a8379e6a
        name: Sleep
        type: action
        on_success: 7f3a9c1e-2b4d-4a6f-8c3e-9d1b5a7f2e6c
        command:
          command: strangebee.sleep
          version: v1.0.0
          type: strangebee
          parameters:
            duration: 20s
        ui:
          position:
            x: 690.6666666666666
            'y': 309
      d4e6f8a0-3b5c-4dab-9012-c3d4e5f6a7b8:
        id: d4e6f8a0-3b5c-4dab-9012-c3d4e5f6a7b8
        name: For Each Thread Reply
        type: foreach
        foreach:
          foreach: >-
            ($steps["3d781a50-1355-405a-909b-a07b98cc0fa9"].body.messages // []) |
            [.[] | select(.ts !=
            $steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body.ts)]
          key_variable: idx
          key_variable_id: e1f2a3b4-5c6d-4e7f-8091-a2b3c4d5e6f7
          value_variable: item
          value_variable_id: f2a3b4c5-6d7e-4f80-9102-b3c4d5e6f7a8
          body: a3b4c5d6-7e8f-4091-a213-c4d5e6f7a8b9
        ui:
          position:
            x: 1036
            'y': 803
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - type: text
                    value: (
                  - key: steps["3d781a50-1355-405a-909b-a07b98cc0fa9"].body
                    type: variable
                  - type: text
                    value: '.messages // []) | [.[] | select(.ts != '
                  - key: steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body
                    type: variable
                  - type: text
                    value: .ts)]
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      e0b96ab0-017b-4d67-8a70-cbcd591786e3:
        id: e0b96ab0-017b-4d67-8a70-cbcd591786e3
        name: For Each Reaction
        type: foreach
        on_success: 3d781a50-1355-405a-909b-a07b98cc0fa9
        foreach:
          foreach: >-
            $steps["ed2eced1-3cce-43d9-8adf-424f41ae5ef1"].body.message.reactions //
            []
          key_variable: idx
          key_variable_id: 98d7272a-14a4-4351-b1a9-85d485cd7fb4
          value_variable: item
          value_variable_id: 8910187f-e9c7-4e70-9218-f4af527b50dd
          body:
            - 57ed6553-5bd3-4f02-bcfd-85efd7f1fda6
            - 321049cc-f0d1-4bbe-ac44-85d454c4f490
            - 369c34f4-e7d7-48f2-adfe-cd2fa6e1db50
        ui:
          position:
            x: 690.6666666666666
            'y': 613
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["ed2eced1-3cce-43d9-8adf-424f41ae5ef1"].body
                    type: variable
                  - type: text
                    value: .message.reactions // []
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      ed2eced1-3cce-43d9-8adf-424f41ae5ef1:
        id: ed2eced1-3cce-43d9-8adf-424f41ae5ef1
        name: Slack Get Reactions
        type: action
        on_success: b2c4e6a8-2f1a-4abc-9def-a1b2c3d4e5f6
        command:
          command: strangebee.integration.slack.2.0.0
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: get_reactions
            auth_type: bearer_token
            base_url: https://slack.com/api
            bearer_token: '<SLACK_BOT_TOKEN>'
            get_reactions__query_params:
              - name: channel
                value: '{{ $steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body.channel }}'
              - name: timestamp
                value: '{{ $steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body.ts }}'
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 690.6666666666666
            'y': 461
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://slack.com/api
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<SLACK_BOT_TOKEN>'
            command.parameters.get_reactions__query_params:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body
                            type: variable
                          - type: text
                            value: .channel
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["ab91afe4-1fca-4c89-8393-a86d308b1a07"].body
                            type: variable
                          - type: text
                            value: .ts
      fc3b3d9f-5874-4550-b173-80ba55741c9e:
        id: fc3b3d9f-5874-4550-b173-80ba55741c9e
        name: Slack Get User Information
        type: action
        on_success: 234afd9b-a38c-4a85-a8fd-0daa277ae93f
        command:
          command: strangebee.integration.slack.2.0.0
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: get_user_info
            auth_type: bearer_token
            base_url: https://slack.com/api
            bearer_token: '<SLACK_BOT_TOKEN>'
            get_user_info__query_params:
              - name: user
                value: >-
                  {{
                  $steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"].users[0]
                  }}
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 418.552
            'y': 925.5392
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://slack.com/api
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<SLACK_BOT_TOKEN>'
            command.parameters.get_user_info__query_params:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["e0b96ab0-017b-4d67-8a70-cbcd591786e3"]["8910187f-e9c7-4e70-9218-f4af527b50dd"]
                            type: variable
                          - type: text
                            value: .users[0]
      start--new-playbook--9f02b2a4-76dc-4f46-8ca4-6a36d5e12876:
        id: start--new-playbook--9f02b2a4-76dc-4f46-8ca4-6a36d5e12876
        type: start
        on_success: ab91afe4-1fca-4c89-8393-a86d308b1a07
        ui:
          position:
            x: 690.6666666666666
            'y': 0
    created_by: admin@thehive.local
    created: '2026-09-07T13:52:00.968885Z'
    modified_by: admin@thehive.local
    modified: '2026-09-08T08:45:35.668127Z'
    ```

## Suspicious email campaign

The *Suspicious email campaign* template processes the emails your users report and detects phishing campaigns: it enriches each reported email alert and groups the alerts belonging to the same campaign into a single case.

Users forward suspicious emails to a mailbox monitored by the [email intake connector](../../thehive/administration/email-intake-connector/about-email-intake-connectors.md), which creates one alert per email with the `.eml` file attached. A [*Scheduler* trigger](add-trigger.md#add-a-scheduler-trigger) runs the workflow at a regular interval, for example every 15 minutes.

Each run retrieves the new alerts created by the connector and parses each email with the *EmlParser* Cortex analyzer. It updates the alert with the sender, subject, and a preview of the email, and adds the suspicious sender and domain as observables.

The workflow then searches for an open case with the same email subject and sender. If one exists, the workflow merges the alert into the most recent one. Otherwise, it escalates the alert to a new case carrying a campaign identifier. In both cases, the workflow adds a page with the email headers to the case.

Before importing this template, prepare TheHive and Cortex:

* Custom fields: [Create the custom fields](../../thehive/administration/custom-fields/create-a-custom-field.md) that the workflow fills, with the *String* type and the following technical names. For alerts, these are `sender`, `recipient`, `reporter`, and `reporteddate`. For cases, it's `campaign`. TheHive rejects the update requests when these custom fields don't exist.
* Email intake: Keep the default `email-intake` tag on the alerts created by the [email intake connector](../../thehive/administration/email-intake-connector/about-email-intake-connectors.md). The *Get Unprocessed Email-Intake Alerts* node selects alerts by this tag and the *New* status. The *Find EML Attachment Observable* node reads the `.eml` file observable the connector adds to each alert. The workflow expects forwarded emails: on an email that wasn't forwarded, the extracted sender and date can be wrong.
* Cortex analyzer: Enable the *EmlParser* analyzer on a [Cortex server connected to TheHive](../../thehive/administration/cortex/add-a-cortex-server.md). The email preview requires the `email_visualisation` option of the analyzer, off by default. Turn it on in the analyzer configuration in Cortex. Without it, the analyzer returns no rendering of the email and the *Upload Email Screenshot as Attachment* node fails.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates). The *Add Email Headers Page to Case (Merged)* and *Add Email Headers Page to Case (New)* nodes are [*HTTP request* nodes](configure-action-node.md#configure-an-http-request-action-node) calling TheHive API directly. In both, replace `https://thehive.example.com` at the start of the **URL** field with your global variable, and `<THEHIVE_API_KEY>` with your secret global variable in the **Authentication** section.
* Cortex analyzer: In the *Run EmlParser Analyzer* node, select your Cortex server and the *EmlParser* analyzer. The template ships with no Cortex server and an `<EMLPARSER_ANALYZER_ID>` placeholder.
* Trigger: [Add a *Scheduler* trigger](add-trigger.md#add-a-scheduler-trigger) with an interval matching your email volume, typically every 15 to 30 minutes.

??? example "Suspicious email campaign template YAML"

    ```yaml
    version: v1.0.0
    spec_version: chocolate-v2.0.0
    id: playbook-01a13443-15d7-76de-9a09-4f04eaa42c58
    name: Suspicious email campaign
    description: "Processes reported suspicious emails (alerts tagged email-intake): analyzes the EML with Cortex EmlParser, extracts the real sender, attaches the email screenshot and groups the alerts of a campaign into one open case."
    workflow_start: start--new-playbook--451736e4-1afc-4506-ac04-ab2fe0196d8a
    workflow:
      2cda2dd9-2d15-4a18-b5fa-804b055dca26:
        id: 2cda2dd9-2d15-4a18-b5fa-804b055dca26
        name: Set Campaign Custom Field
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: update_case
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
            update_case__customFields: >-
              {"campaign":"{{
              $steps["50535d2c-4d14-4335-abae-ac3bf18de6b3"].uuid_campaign }}"}
            update_case__flag: no_change
            update_case__idOrName: '{{ $steps["5bbdcc84-fda0-4c84-8b86-466534e456b1"].body._id }}'
        ui:
          position:
            x: 259
            'y': 1373
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.update_case__idOrName:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["5bbdcc84-fda0-4c84-8b86-466534e456b1"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.update_case__customFields:
              wireDoc:
                nodes:
                  - type: text
                    value: '{"campaign":"'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["50535d2c-4d14-4335-abae-ac3bf18de6b3"].uuid_campaign
                          type: variable
                  - type: text
                    value: '"}'
      2ce4fb8d-e14b-4a3b-8931-a9dd78ae5560:
        id: 2ce4fb8d-e14b-4a3b-8931-a9dd78ae5560
        name: Upload Email Screenshot as Attachment
        type: action
        on_success: 74e842b1-deba-4c43-9e4e-c6599f581edf
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: add_attachment_to_alert
            add_attachment_to_alert__alertId: >-
              {{
              $steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]._id
              }}
            add_attachment_to_alert__file: '{{ $steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].screenshot }}'
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 234
            'y': 737
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.add_attachment_to_alert__file:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].screenshot
                          type: variable
            command.parameters.add_attachment_to_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]
                          type: variable
                        - type: text
                          value: ._id
      33410592-8702-42e1-8c58-efa08a9c4d34:
        id: 33410592-8702-42e1-8c58-efa08a9c4d34
        name: Add Email Headers Page to Case (Merged)
        type: action
        command:
          command: strangebee.http.request
          version: v1.0.0
          type: strangebee
          parameters:
            auth_type: bearer_token
            bearer_token: <THEHIVE_API_KEY>
            body: '{{ $steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].page_body_json }}'
            headers:
              - name: Content-Type
                value: application/json
            method: POST
            url: >-
              https://thehive.example.com/api/v1/case/{{
              $steps["7ec958b8-34a4-492a-9a34-d62e328f6cda"].body[0]._id }}/page
        ui:
          position:
            x: 0
            'y': 1297
          variableInputs:
            command.parameters.url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
                  - type: text
                    value: /api/v1/case/
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ec958b8-34a4-492a-9a34-d62e328f6cda"].body
                          type: variable
                        - type: text
                          value: '[0]._id'
                  - type: text
                    value: /page
            command.parameters.body:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].page_body_json
                          type: variable
            command.parameters.headers:
              wireDocs:
                - nodes:
                    - type: text
                      value: application/json
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
          optionalSections:
            - authentication
      464bfe90-380e-4bbb-86e0-d1875c58e898:
        id: 464bfe90-380e-4bbb-86e0-d1875c58e898
        name: Set Variables
        type: action
        on_success: 2ce4fb8d-e14b-4a3b-8931-a9dd78ae5560
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: b748a447-129c-4f0d-8ae3-4e46648a0eb1
                name: title
                type: string
                value: '{{ $steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].email_title }}'
              - id: eea864bd-0b06-40b6-b5b2-d58190e922e4
                name: suspiciousSender
                type: string
                value: >-
                  {{ $steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].suspect_sender
                  }}
              - id: 160491e7-d34b-442d-a239-c15f72fcbc45
                name: recipient
                type: string
                value: >-
                  {{
                  $steps["b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa"].analyzer_report.full.headers.from.[0]
                  }}
              - id: 22e963a1-4db7-4a21-a366-b54c6353cec0
                name: reportedDate
                type: string
                value: >-
                  {{
                  $steps["b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa"].analyzer_report.full.headers.date
                  }}
              - id: a8d948a5-cff7-4210-a12d-b4d316a99359
                name: renderedHTMLb64
                type: string
                value: >-
                  {{
                  $steps["b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa"].analyzer_report.full.body.text_html.[0].rendered_html
                  }}
        ui:
          position:
            x: 234
            'y': 661
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].email_title
                            type: variable
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].suspect_sender
                            type: variable
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa"].analyzer_report
                            type: variable
                          - type: text
                            value: .full.headers.from.[0]
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa"].analyzer_report
                            type: variable
                          - type: text
                            value: .full.headers.date
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa"].analyzer_report
                            type: variable
                          - type: text
                            value: .full.body.text_html.[0].rendered_html
      4a6dfb46-ea23-4288-a25f-da25c0cf41e6:
        id: 4a6dfb46-ea23-4288-a25f-da25c0cf41e6
        name: Find EML Attachment Observable
        type: action
        on_success: b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: post_query
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            manual_status_handling: false
            post_query__query: |-
              [
                      {
                          "_name": "getAlert",
                          "idOrName": "{{ $steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]._id }}"
                      },
                      {
                          "_name": "observables"
                      },
                      {
                          "_name": "filter",
                          "_endsWith": { "_field": "attachment.name", "_value": "eml"}
                      }
              ]
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 234
            'y': 433
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      [
                              {
                                  "_name": "getAlert",
                                  "idOrName": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: |-
                      "
                              },
                              {
                                  "_name": "observables"
                              },
                              {
                                  "_name": "filter",
                                  "_endsWith": { "_field": "attachment.name", "_value": "eml"}
                              }
                      ]
      50535d2c-4d14-4335-abae-ac3bf18de6b3:
        id: 50535d2c-4d14-4335-abae-ac3bf18de6b3
        name: Generate Campaign UUID
        type: action
        on_success: 2cda2dd9-2d15-4a18-b5fa-804b055dca26
        command:
          command: strangebee.code.execute.python@v3_11
          version: v1.0.0
          type: strangebee
          parameters:
            script: |-
              import uuid

              uuid_campaign = uuid.uuid4()

              flow.set("uuid_campaign",str(uuid_campaign))
        ui:
          position:
            x: 259
            'y': 1297
      56681fd2-b59f-4013-a05b-7db50ec9129c:
        id: 56681fd2-b59f-4013-a05b-7db50ec9129c
        name: Similar Case Found?
        type: if-condition
        condition: $steps["7ec958b8-34a4-492a-9a34-d62e328f6cda"].body | length > 0
        on_true: 7dfd39f6-d9eb-4ead-9afd-b3b640fe8e76
        on_false: 5bbdcc84-fda0-4c84-8b86-466534e456b1
        ui:
          position:
            x: 234
            'y': 1117
          variableInputs:
            condition:
              wireDoc:
                nodes:
                  - key: steps["7ec958b8-34a4-492a-9a34-d62e328f6cda"].body
                    type: variable
                  - type: text
                    value: ' | length > 0'
      5bbdcc84-fda0-4c84-8b86-466534e456b1:
        id: 5bbdcc84-fda0-4c84-8b86-466534e456b1
        name: Escalate Alert to New Case
        type: action
        on_success:
          - 50535d2c-4d14-4335-abae-ac3bf18de6b3
          - 5d0a1020-9e7c-4b16-af5f-35b9b971bbe2
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: escalate_alert_to_case
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            escalate_alert_to_case__alertId: >-
              {{
              $steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]._id
              }}
            escalate_alert_to_case__flag: no_change
            headers:
              - name: Content-Type
                value: application/json
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 376
            'y': 1193
          variableInputs:
            command.parameters.headers:
              wireDocs:
                - nodes:
                    - type: text
                      value: application/json
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.escalate_alert_to_case__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]
                          type: variable
                        - type: text
                          value: ._id
      5d0a1020-9e7c-4b16-af5f-35b9b971bbe2:
        id: 5d0a1020-9e7c-4b16-af5f-35b9b971bbe2
        name: Add Email Headers Page to Case (New)
        type: action
        command:
          command: strangebee.http.request
          version: v1.0.0
          type: strangebee
          parameters:
            auth_type: bearer_token
            bearer_token: <THEHIVE_API_KEY>
            body: '{{ $steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].page_body_json }}'
            headers:
              - name: Content-Type
                value: application/json
            method: POST
            url: >-
              https://thehive.example.com/api/v1/case/{{
              $steps["5bbdcc84-fda0-4c84-8b86-466534e456b1"].body._id }}/page
        ui:
          position:
            x: 493
            'y': 1297
          variableInputs:
            command.parameters.url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
                  - type: text
                    value: /api/v1/case/
                  - type: context
                    expression:
                      nodes:
                        - key: steps["5bbdcc84-fda0-4c84-8b86-466534e456b1"].body
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: /page
            command.parameters.body:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].page_body_json
                          type: variable
            command.parameters.headers:
              wireDocs:
                - nodes:
                    - type: text
                      value: application/json
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
          optionalSections:
            - authentication
      6c33e6f6-0dba-4e78-8378-f3e2a6d82f5b:
        id: 6c33e6f6-0dba-4e78-8378-f3e2a6d82f5b
        name: Add Suspicious Domain Observable
        type: action
        on_success: 7ec958b8-34a4-492a-9a34-d62e328f6cda
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_observable_in_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_observable_in_alert__alertId: >-
              {{
              $steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]._id
              }}
            create_observable_in_alert__data: '{{ $steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].suspect_domain }}'
            create_observable_in_alert__dataType: domain
            create_observable_in_alert__ignoreSimilarity: no_change
            create_observable_in_alert__ioc: no_change
            create_observable_in_alert__sighted: no_change
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 234
            'y': 965
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_observable_in_alert__data:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].suspect_domain
                          type: variable
            command.parameters.create_observable_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_observable_in_alert__dataType:
              wireDoc:
                nodes:
                  - type: text
                    value: domain
      74e842b1-deba-4c43-9e4e-c6599f581edf:
        id: 74e842b1-deba-4c43-9e4e-c6599f581edf
        name: Update Alert Information
        type: action
        on_success: bcb7cf27-3181-4018-85e3-c15c5f7d2089
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: update_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
            update_alert__alertId: >-
              {{
              $steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]._id
              }}
            update_alert__customFields: >-
              {"sender":"{{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"]
              }}","recipient":"{{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["160491e7-d34b-442d-a239-c15f72fcbc45"]
              }}","reporter":"{{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["160491e7-d34b-442d-a239-c15f72fcbc45"]
              }}","reporteddate":"{{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["22e963a1-4db7-4a21-a366-b54c6353cec0"]
              }}"}
            update_alert__description: >-
              **From** : {{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"]
              }}

              **To** : {{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["160491e7-d34b-442d-a239-c15f72fcbc45"]
              }}

              **Subject** : {{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["b748a447-129c-4f0d-8ae3-4e46648a0eb1"]
              }}

              **CC** :

              **Date**: {{
              $steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].original_email_date }}


              **Preview of the EMAIL :**

              ![{{
              $steps["2ce4fb8d-e14b-4a3b-8931-a9dd78ae5560"].body.attachments.[0].name
              }}]({{
              $steps["2ce4fb8d-e14b-4a3b-8931-a9dd78ae5560"].body.attachments.[0].path
              }})
            update_alert__follow: no_change
            update_alert__title: >-
              Suspicious Email : "{{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["b748a447-129c-4f0d-8ae3-4e46648a0eb1"]
              }}"
        ui:
          position:
            x: 234
            'y': 813
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.update_alert__title:
              wireDoc:
                nodes:
                  - type: text
                    value: 'Suspicious Email : "'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["b748a447-129c-4f0d-8ae3-4e46648a0eb1"]
                          type: variable
                  - type: text
                    value: '"'
            command.parameters.update_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.update_alert__description:
              wireDoc:
                nodes:
                  - type: text
                    value: '**From** : '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"]
                          type: variable
                  - type: text
                    value: "\n**To** : "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["160491e7-d34b-442d-a239-c15f72fcbc45"]
                          type: variable
                  - type: text
                    value: "\n**Subject** : "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["b748a447-129c-4f0d-8ae3-4e46648a0eb1"]
                          type: variable
                  - type: text
                    value: "\n**CC** :\n**Date**: "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["c448f6e0-49fc-4827-9463-2b5d1f947692"].original_email_date
                          type: variable
                  - type: text
                    value: |-


                      **Preview of the EMAIL :**
                      ![
                  - type: context
                    expression:
                      nodes:
                        - key: steps["2ce4fb8d-e14b-4a3b-8931-a9dd78ae5560"].body
                          type: variable
                        - type: text
                          value: .attachments.[0].name
                  - type: text
                    value: ']('
                  - type: context
                    expression:
                      nodes:
                        - key: steps["2ce4fb8d-e14b-4a3b-8931-a9dd78ae5560"].body
                          type: variable
                        - type: text
                          value: .attachments.[0].path
                  - type: text
                    value: )
            command.parameters.update_alert__customFields:
              wireDoc:
                nodes:
                  - type: text
                    value: '{"sender":"'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"]
                          type: variable
                  - type: text
                    value: '","recipient":"'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["160491e7-d34b-442d-a239-c15f72fcbc45"]
                          type: variable
                  - type: text
                    value: '","reporter":"'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["160491e7-d34b-442d-a239-c15f72fcbc45"]
                          type: variable
                  - type: text
                    value: '","reporteddate":"'
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["22e963a1-4db7-4a21-a366-b54c6353cec0"]
                          type: variable
                  - type: text
                    value: '"}'
      7ceeaf25-1fcd-4786-b743-aac5288b4fdd:
        id: 7ceeaf25-1fcd-4786-b743-aac5288b4fdd
        name: For Each Email-Intake Alert
        type: foreach
        foreach:
          foreach: $steps["d49ca3d1-7e3d-4981-b94f-99d65201dd12"]["20f83926-1cb0-40e2-af6b-32f0c5cedc06"]
          key_variable: idx
          key_variable_id: a1addc84-1fb7-402b-b50e-9da24d028f2a
          value_variable: item
          value_variable_id: 59dc7ffe-008c-42b3-b399-d71cc6f06afd
          body: 4a6dfb46-ea23-4288-a25f-da25c0cf41e6
        ui:
          position:
            x: 234
            'y': 357
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["d49ca3d1-7e3d-4981-b94f-99d65201dd12"]["20f83926-1cb0-40e2-af6b-32f0c5cedc06"]
                    type: variable
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      7dfd39f6-d9eb-4ead-9afd-b3b640fe8e76:
        id: 7dfd39f6-d9eb-4ead-9afd-b3b640fe8e76
        name: Merge Alert into Existing Case
        type: action
        on_success: 33410592-8702-42e1-8c58-efa08a9c4d34
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: merge_alert_with_case
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            manual_status_handling: false
            merge_alert_with_case__alertId: >-
              {{
              $steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]._id
              }}
            merge_alert_with_case__caseId: '{{ $steps["7ec958b8-34a4-492a-9a34-d62e328f6cda"].body[0]._id }}'
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 0
            'y': 1193
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.merge_alert_with_case__caseId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ec958b8-34a4-492a-9a34-d62e328f6cda"].body
                          type: variable
                        - type: text
                          value: '[0]._id'
            command.parameters.merge_alert_with_case__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]
                          type: variable
                        - type: text
                          value: ._id
      7ec958b8-34a4-492a-9a34-d62e328f6cda:
        id: 7ec958b8-34a4-492a-9a34-d62e328f6cda
        name: Search for Similar Case
        type: action
        on_success: 56681fd2-b59f-4013-a05b-7db50ec9129c
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: post_query
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            manual_status_handling: false
            post_query__query: |-
              [
                  {
                      "_name": "listCase"
                  },
                  {
                      "_name": "filter",
                      "_eq": {
                          "_field": "title",
                          "_value": {{ "Suspicious Email : \"" + $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["b748a447-129c-4f0d-8ae3-4e46648a0eb1"] + "\"" | tojson }}
                      }
                  },
                  {
                      "_name": "filter",
                      "_eq": {
                          "_field": "customFields.sender",
                          "_value": {{ $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"] | tojson }}
                      }
                  },
                  {
                      "_name": "filter",
                      "_ne": {
                          "_field": "stage",
                          "_value": "Closed"
                      }
                  },
                  {
                      "_name": "sort",
                      "_fields": [{"_createdAt": "desc"}]
                  },
                  {
                      "_name": "page",
                      "from": 0,
                      "to": 1
                  }
              ]
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 234
            'y': 1041
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: "[\n    {\n        \"_name\": \"listCase\"\n    },\n    {\n        \"_name\": \"filter\",\n        \"_eq\": {\n            \"_field\": \"title\",\n            \"_value\": "
                  - type: context
                    expression:
                      nodes:
                        - type: text
                          value: "\"Suspicious Email : \\\"\" + "
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["b748a447-129c-4f0d-8ae3-4e46648a0eb1"]
                          type: variable
                        - type: text
                          value: " + \"\\\"\" | tojson"
                  - type: text
                    value: "\n        }\n    },\n    {\n        \"_name\": \"filter\",\n        \"_eq\": {\n            \"_field\": \"customFields.sender\",\n            \"_value\": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"]
                          type: variable
                        - type: text
                          value: " | tojson"
                  - type: text
                    value: "\n        }\n    },\n    {\n        \"_name\": \"filter\",\n        \"_ne\": {\n            \"_field\": \"stage\",\n            \"_value\": \"Closed\"\n        }\n    },\n    {\n        \"_name\": \"sort\",\n        \"_fields\": [{\"_createdAt\": \"desc\"}]\n    },\n    {\n        \"_name\": \"page\",\n        \"from\": 0,\n        \"to\": 1\n    }\n]"
      966bc137-dfcc-40e8-9105-ba42039a74bd:
        id: 966bc137-dfcc-40e8-9105-ba42039a74bd
        name: Get Unprocessed Email-Intake Alerts
        type: action
        on_success: d49ca3d1-7e3d-4981-b94f-99d65201dd12
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: post_query
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            editor_mode: form
            manual_status_handling: false
            post_query__query: |-
              [
                      {
                          "_name": "listAlert"
                      },
                      {
                          "_name": "filter",
                          "_in": {
                              "_field": "tags",
                              "_values": [
                                  "email-intake"
                              ]
                          }
                      },
                      {
                         "_name": "filter",
                         "_eq": { "_field": "status", "_value": "New" }
                       }
                  ]
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 234
            'y': 205
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      [
                              {
                                  "_name": "listAlert"
                              },
                              {
                                  "_name": "filter",
                                  "_in": {
                                      "_field": "tags",
                                      "_values": [
                                          "email-intake"
                                      ]
                                  }
                              },
                              {
                                 "_name": "filter",
                                 "_eq": { "_field": "status", "_value": "New" }
                               }
                          ]
      b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa:
        id: b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa
        name: Run EmlParser Analyzer
        type: action
        on_success: c448f6e0-49fc-4827-9463-2b5d1f947692
        command:
          command: strangebee.cortex.analyzer
          version: v1.0.0
          type: strangebee
          parameters:
            analyzer: <EMLPARSER_ANALYZER_ID>
            cortex_id: ''
            observable_id: '{{ $steps["4a6dfb46-ea23-4288-a25f-da25c0cf41e6"].body[0]._id }}'
            observable_type: file
        ui:
          position:
            x: 234
            'y': 509
          variableInputs:
            command.parameters.observable_id:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["4a6dfb46-ea23-4288-a25f-da25c0cf41e6"].body
                          type: variable
                        - type: text
                          value: '[0]._id'
            command.parameters.observable_type:
              wireDoc:
                nodes:
                  - type: text
                    value: file
          inputMode:
            command.parameters.observable_type: form
      bcb7cf27-3181-4018-85e3-c15c5f7d2089:
        id: bcb7cf27-3181-4018-85e3-c15c5f7d2089
        name: Add Suspicious Sender Observable
        type: action
        on_success: 6c33e6f6-0dba-4e78-8378-f3e2a6d82f5b
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            action: create_observable_in_alert
            auth_type: bearer_token
            base_url: https://thehive.example.com
            bearer_token: <THEHIVE_API_KEY>
            create_observable_in_alert__alertId: >-
              {{
              $steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]._id
              }}
            create_observable_in_alert__data: >-
              {{
              $steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"]
              }}
            create_observable_in_alert__dataType: mail
            create_observable_in_alert__ignoreSimilarity: no_change
            create_observable_in_alert__ioc: no_change
            create_observable_in_alert__sighted: no_change
            editor_mode: form
            manual_status_handling: false
            proxy_mode: disabled
            ssl_mtls: disabled
            ssl_verification: default
        ui:
          position:
            x: 234
            'y': 889
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: https://thehive.example.com
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: <THEHIVE_API_KEY>
            command.parameters.create_observable_in_alert__data:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["464bfe90-380e-4bbb-86e0-d1875c58e898"]["eea864bd-0b06-40b6-b5b2-d58190e922e4"]
                          type: variable
            command.parameters.create_observable_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["7ceeaf25-1fcd-4786-b743-aac5288b4fdd"]["59dc7ffe-008c-42b3-b399-d71cc6f06afd"]
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_observable_in_alert__dataType:
              wireDoc:
                nodes:
                  - type: text
                    value: mail
      c448f6e0-49fc-4827-9463-2b5d1f947692:
        id: c448f6e0-49fc-4827-9463-2b5d1f947692
        name: Extract Email Metadata
        type: action
        on_success: 464bfe90-380e-4bbb-86e0-d1875c58e898
        command:
          command: strangebee.code.execute.python@v3_11
          version: v1.0.0
          type: strangebee
          parameters:
            script: >-
              import json, re, base64


              report =
              flow.get('$steps["b8864bcb-a36f-4cdd-98a3-f3c49ebdd9fa"].analyzer_report')
              or {}


              full = report.get("full") or {}


              png_b64 = (full.get('body', {}).get('text_html') or
              [{}])[0].get('rendered_html', '')

              iocs_emails = full.get('iocs', {}).get('email', [])

              raw = base64.b64decode(png_b64.split(",", 1)[1] if "," in png_b64 else
              png_b64)

              headers = full.get('headers', {})

              raw_email = full.get('raw_email', '')


              # Addresses from the current envelope (IT relay/forwarder) - excluded
              from suspects

              envelope_addrs = {
                  e['data'] for e in iocs_emails
                  if 'envelope' in e.get('tag', [])
              }


              # Original sender = found in the body, not in the envelope

              suspects = [
                  e['data'] for e in iocs_emails
                  if ('body:text/plain' in e.get('tag', []) or 'body:text/html' in e.get('tag', []))
                  and e['data'] not in envelope_addrs
              ]


              flow.set("suspect_sender", suspects[0] if suspects else "")

              flow.set("suspect_domain", suspects[0].split('@')[1] if suspects else
              "")

              flow.set("all_suspects", json.dumps(suspects))


              # Subject cleaned of the TR/FWD prefix

              raw_subject = (full.get('headers', {}).get('subject') or [''])[0]

              email_title = re.sub(r'^((TR|FWD?)\s*:\s*)+', '', raw_subject,
              flags=re.IGNORECASE).strip()

              flow.set("email_title", email_title)


              # Forwarded "From / Date / To / Subject" block: only present in the
              HTML (text_plain is empty)

              html_content = (full.get('body', {}).get('text_html') or
              [{}])[0].get('content', '')


              def extract_header_field(label, html):
                  m = re.search(
                      rf'<b>\s*{label}\s*(?:&nbsp;)?\s*:\s*</b>\s*(.+?)\s*<br',
                      html, re.IGNORECASE | re.DOTALL
                  )
                  return m.group(1).strip() if m else ""

              original_date_raw = extract_header_field("Date", html_content)

              flow.set("original_email_date", original_date_raw)  # e.g. "Tuesday,
              August 4, 2026 at 2:52 PM"


              original_cc_raw = extract_header_field("Cc", html_content)

              flow.set("original_cc", original_cc_raw)

              # -> "" if absent, or "email1@domain.com; email2@domain.com" if
              present


              # Email screenshot exposed as a file output (blobref), consumed by

              # add_attachment_to_alert. The file name becomes the attachment name.

              screenshot_path = "/tmp/report.png"

              with open(screenshot_path, "wb") as f:
                  f.write(raw)

              flow.set_file_from_path("screenshot", screenshot_path)


              page_body_json = json.dumps({
                  "title": "Email Headers",
                  "category": "default",
                  "content": json.dumps(headers, indent=2) + "\n\n" + raw_email
              })


              flow.set("page_body_json", page_body_json)
        ui:
          position:
            x: 234
            'y': 585
      d49ca3d1-7e3d-4981-b94f-99d65201dd12:
        id: d49ca3d1-7e3d-4981-b94f-99d65201dd12
        name: Store Alerts as Array
        type: action
        on_success: 7ceeaf25-1fcd-4786-b743-aac5288b4fdd
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 20f83926-1cb0-40e2-af6b-32f0c5cedc06
                name: alertArray
                type: array
                value: '{{ $steps["966bc137-dfcc-40e8-9105-ba42039a74bd"].body }}'
        ui:
          position:
            x: 234
            'y': 281
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes:
                    - type: context
                      expression:
                        nodes:
                          - key: steps["966bc137-dfcc-40e8-9105-ba42039a74bd"].body
                            type: variable
      start--new-playbook--451736e4-1afc-4506-ac04-ab2fe0196d8a:
        id: start--new-playbook--451736e4-1afc-4506-ac04-ab2fe0196d8a
        type: start
        on_success: 966bc137-dfcc-40e8-9105-ba42039a74bd
        ui:
          position:
            x: 234
            'y': 0
    created_by: admin@thehive.local
    created: '2026-10-13T07:56:14.167451Z'
    modified_by: admin@thehive.local
    modified: '2026-10-13T07:58:21.099446Z'
    ```

## TheHive to Jira ITSM sync

The *TheHive to Jira ITSM sync* template mirrors every new TheHive alert as a Jira issue and keeps the two in sync: comments travel in both directions, and the issue closes when the synchronization ends.

A [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger) wired to a [TheHive notification](../../thehive/user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) starts the workflow when an alert is created. The workflow creates a Jira issue with the alert title and description, then synchronizes comments in both directions.

New TheHive comments appear on the Jira issue prefixed with `[From TheHive]`. New Jira comments appear on the alert prefixed with `[From Jira]`. To prevent synchronization loops, the workflow then edits each original comment to prefix it with `[Synced]`. When the synchronization loop completes, the workflow transitions the Jira issue to *Done*.

Before importing this template, [create a global variable](manage-global-variables.md#create-a-global-variable) holding the URL of your Jira Cloud site, and a secret global variable holding an [Atlassian API token](https://id.atlassian.com/manage-profile/security/api-tokens){target=_blank}.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Jira connection: In every [*Jira Cloud* node](configure-integration-node.md#configure-a-jira-cloud-integration-node), select your variables instead of the `https://your-domain.atlassian.net` and `<JIRA_API_TOKEN>` placeholders in the **Base URL** and **Password** fields. Replace `email@toreplace` in the **Username** field with the Atlassian account email of your service account.
* Jira project and issue type: The *Set Jira Project Key and Issue Type* node ships with empty values. Set the `jira_project_key` and `jira_issue_type` variables to match the Jira project receiving the issues.
* Trigger: [Add a *Webhook* trigger](add-trigger.md#add-a-webhook-trigger) to the workflow, then create the notification in TheHive with the *AlertCreated* trigger and a *Webhook* notifier pointing to the trigger URL.
* Closing transition: The *Jira close issue* node applies the transition named *Done*, which must be available from the initial status of the issue. Change this name if your Jira project uses another workflow.
* Sync duration: The *For Each (While)* loop runs nine synchronization cycles with a 10-second pause, about 90 seconds in total. The workflow then closes the Jira issue whatever the alert status, and comments added afterward aren't synchronized. Increase these values to keep the alert and the issue in sync for longer, within the 24-hour timeout of the workflow.

??? example "TheHive to Jira ITSM sync template YAML"

    ```yaml
    version: v1.0.0
    spec_version: chocolate-v2.0.0
    id: playbook-01a08b80-9d3a-70bc-a24a-bf6eff02c0b8
    name: TheHive to Jira ITSM Sync
    description: "Creates a Jira issue mirroring each new TheHive alert, syncs comments both ways for 9 cycles (about 90 seconds), then moves the issue to Done. The sync loop is a ForEach over range(1;10), standing in for a While node, which TheHive Flow doesn't provide."
    timeout: 24h0m0s
    workflow_start: start--0
    workflow:
      40571689-460a-49ac-8651-75dc99eb395e:
        id: 40571689-460a-49ac-8651-75dc99eb395e
        name: Jira add comment
        type: action
        on_success: 9cae18b7-85f2-4d55-ac89-479008bc952b
        command:
          command: strangebee.integration.jira.v3
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: add_comment
            add_comment__body_content: |-
              {
                  "type": "doc",
                  "version": 1,
                  "content": [
                    {
                      "type": "paragraph",
                      "content": [
                        {
                          "type": "text",
                          "text": {{ "[From TheHive] " +$steps["55b8600c-4bbb-44fe-b673-a5dcbb90269f"]["bcd7e0db-ec92-4b76-b964-723be675ef7c"].message | tojson }}
                        }
                      ]
                    }
                  ]
                }
            add_comment__issueIdOrKey: '{{ $steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body.id }}'
            add_comment__jsdPublic: no_change
            auth_type: basic_auth
            base_url: 'https://your-domain.atlassian.net'
            basic_auth_login: email@toreplace
            basic_auth_password: '<JIRA_API_TOKEN>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 234
            'y': 849
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://your-domain.atlassian.net'
            command.parameters.basic_auth_login:
              wireDoc:
                nodes:
                  - type: text
                    value: email@toreplace
            command.parameters.update_comment__id:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"]
                          type: variable
                        - type: text
                          value: .i
            command.parameters.basic_auth_password:
              wireDoc:
                nodes:
                  - type: text
                    value: '<JIRA_API_TOKEN>'
            command.parameters.add_comment__body_content:
              wireDoc:
                nodes:
                  - type: text
                    value: "{\n    \"type\": \"doc\",\n    \"version\": 1,\n    \"content\": [\n      {\n        \"type\": \"paragraph\",\n        \"content\": [\n          {\n            \"type\": \"text\",\n            \"text\": "
                  - type: context
                    expression:
                      nodes:
                        - type: text
                          value: '"[From TheHive] " +'
                        - key: steps["55b8600c-4bbb-44fe-b673-a5dcbb90269f"]["bcd7e0db-ec92-4b76-b964-723be675ef7c"]
                          type: variable
                        - type: text
                          value: .message | tojson
                  - type: text
                    value: |2-

                                }
                              ]
                            }
                          ]
                        }
            command.parameters.add_comment__issueIdOrKey:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body
                          type: variable
                        - type: text
                          value: .id
            command.parameters.update_comment__body_content:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      {
                          "type": "doc",
                          "version": 1,
                          "content": [
                            {
                              "type": "paragraph",
                              "content": [
                                {
                                  "type": "text",
                                  "text":
                  - type: context
                    expression:
                      nodes:
                        - type: text
                          value: '"[Synced] " + (['
                        - key: steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"]
                          type: variable
                        - type: text
                          value: >-
                            .body | .. | objects | select(has("text")) | .text] |
                            join("")) | tojson
                  - type: text
                    value: |2-

                                }
                              ]
                            }
                          ]
                        }
            command.parameters.update_comment__issueIdOrKey:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body
                          type: variable
                        - type: text
                          value: .key
      47f251b7-69b7-4a5b-a65a-0d9b372705b8:
        id: 47f251b7-69b7-4a5b-a65a-0d9b372705b8
        name: Jira update comment
        type: action
        command:
          command: strangebee.integration.jira.v3
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: update_comment
            auth_type: basic_auth
            base_url: 'https://your-domain.atlassian.net'
            basic_auth_login: email@toreplace
            basic_auth_password: '<JIRA_API_TOKEN>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
            update_comment__body_content: |-
              {
                  "type": "doc",
                  "version": 1,
                  "content": [
                    {
                      "type": "paragraph",
                      "content": [
                        {
                          "type": "text",
                          "text": {{ "[Synced] " + ([$steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"].body | .. | objects | select(has("text")) | .text] | join("")) | tojson  }}
                        }
                      ]
                    }
                  ]
                }
            update_comment__id: >-
              {{
              $steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"].id
              }}
            update_comment__issueIdOrKey: '{{ $steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body.key }}'
            update_comment__jsdPublic: no_change
        ui:
          position:
            x: 0
            'y': 773
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://your-domain.atlassian.net'
            command.parameters.basic_auth_login:
              wireDoc:
                nodes:
                  - type: text
                    value: email@toreplace
            command.parameters.update_comment__id:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"]
                          type: variable
                        - type: text
                          value: .id
            command.parameters.basic_auth_password:
              wireDoc:
                nodes:
                  - type: text
                    value: '<JIRA_API_TOKEN>'
            command.parameters.update_comment__body_content:
              wireDoc:
                nodes:
                  - type: text
                    value: "{\n    \"type\": \"doc\",\n    \"version\": 1,\n    \"content\": [\n      {\n        \"type\": \"paragraph\",\n        \"content\": [\n          {\n            \"type\": \"text\",\n            \"text\": "
                  - type: context
                    expression:
                      nodes:
                        - type: text
                          value: '"[Synced] " + (['
                        - key: steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"]
                          type: variable
                        - type: text
                          value: ".body | .. | objects | select(has(\"text\")) | .text] | join(\"\")) | tojson "
                  - type: text
                    value: |2-

                                }
                              ]
                            }
                          ]
                        }
            command.parameters.update_comment__issueIdOrKey:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body
                          type: variable
                        - type: text
                          value: .key
      55b8600c-4bbb-44fe-b673-a5dcbb90269f:
        id: 55b8600c-4bbb-44fe-b673-a5dcbb90269f
        name: For Each TheHive Comments
        type: foreach
        foreach:
          foreach: >-
            $steps["a62d3626-4a91-4803-a1ea-0430d7ffd39e"].body|
            map(select((.message // "")
                | (startswith("[From Jira]") | not)
                and (startswith("[Synced]") | not)))
          key_variable: idx
          key_variable_id: 917d7de6-9a7b-42c8-9669-b584eb69e54e
          value_variable: item
          value_variable_id: bcd7e0db-ec92-4b76-b964-723be675ef7c
          body: 40571689-460a-49ac-8651-75dc99eb395e
        ui:
          position:
            x: 234
            'y': 773
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["a62d3626-4a91-4803-a1ea-0430d7ffd39e"].body
                    type: variable
                  - type: text
                    value: |-
                      | map(select((.message // "")
                          | (startswith("[From Jira]") | not)
                          and (startswith("[Synced]") | not)))
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      5ab01604-2730-4928-b69d-7465c17169fc:
        id: 5ab01604-2730-4928-b69d-7465c17169fc
        name: Sleep
        type: action
        on_success: 5d90b86c-6832-486c-b8e9-d214ed360c44
        command:
          command: strangebee.sleep
          version: v1.0.0
          type: strangebee
          parameters:
            duration: 10s
        ui:
          position:
            x: 117
            'y': 441
      5d90b86c-6832-486c-b8e9-d214ed360c44:
        id: 5d90b86c-6832-486c-b8e9-d214ed360c44
        name: List Jira comments
        type: action
        on_success: d2783791-2971-4932-8c0c-7d0dc9a4f04a
        command:
          command: strangebee.integration.jira.v3
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: get_comments
            auth_type: basic_auth
            base_url: 'https://your-domain.atlassian.net'
            basic_auth_login: email@toreplace
            basic_auth_password: '<JIRA_API_TOKEN>'
            get_comments__issueIdOrKey: '{{ $steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body.key }}'
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 117
            'y': 517
          inputMode:
            command.parameters.create_issue__fields: json
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://your-domain.atlassian.net'
            command.parameters.basic_auth_login:
              wireDoc:
                nodes:
                  - type: text
                    value: email@toreplace
            command.parameters.basic_auth_password:
              wireDoc:
                nodes:
                  - type: text
                    value: '<JIRA_API_TOKEN>'
            command.parameters.create_issue__fields:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      {
                        "summary": "New TheHive Alert :
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: ' - '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: .title
                  - type: text
                    value: |-
                      ",
                        "project": {
                          "key": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["2ae594c8-4eed-47e0-b301-07479f51b12b"]
                          type: variable
                  - type: text
                    value: |-
                      "
                        },
                        "issuetype": {
                          "name": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["476856f8-d6b0-4e3b-ad6b-4c62218d6987"]
                          type: variable
                  - type: text
                    value: |-
                      "
                        },
                        "description": {
                          "type": "doc",
                          "version": 1,
                          "content": [
                            {
                              "type": "paragraph",
                              "content": [
                                {
                                  "type": "text",
                                  "text":
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: .description | tojson
                  - type: text
                    value: |2-

                                }
                              ]
                            }
                          ]
                        }
                      }
            command.parameters.get_comments__issueIdOrKey:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body
                          type: variable
                        - type: text
                          value: .key
      80008f0f-e5b4-4737-8327-a73cb7272549:
        id: 80008f0f-e5b4-4737-8327-a73cb7272549
        name: Jira Get Transition
        type: action
        on_success: b6108bab-2bd2-48b7-81b8-a20b0c660518
        command:
          command: strangebee.integration.jira.v3
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: get_transitions
            auth_type: basic_auth
            base_url: 'https://your-domain.atlassian.net'
            basic_auth_login: email@toreplace
            basic_auth_password: '<JIRA_API_TOKEN>'
            get_transitions__issueIdOrKey: '{{ $steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body.key }}'
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 351
            'y': 441
          inputMode:
            command.parameters.create_issue__fields: json
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://your-domain.atlassian.net'
            command.parameters.basic_auth_login:
              wireDoc:
                nodes:
                  - type: text
                    value: email@toreplace
            command.parameters.basic_auth_password:
              wireDoc:
                nodes:
                  - type: text
                    value: '<JIRA_API_TOKEN>'
            command.parameters.create_issue__fields:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      {
                        "summary": "New TheHive Alert :
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: ' - '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: .title
                  - type: text
                    value: |-
                      ",
                        "project": {
                          "key": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["2ae594c8-4eed-47e0-b301-07479f51b12b"]
                          type: variable
                  - type: text
                    value: |-
                      "
                        },
                        "issuetype": {
                          "name": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["476856f8-d6b0-4e3b-ad6b-4c62218d6987"]
                          type: variable
                  - type: text
                    value: |-
                      "
                        },
                        "description": {
                          "type": "doc",
                          "version": 1,
                          "content": [
                            {
                              "type": "paragraph",
                              "content": [
                                {
                                  "type": "text",
                                  "text":
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: .description | tojson
                  - type: text
                    value: |2-

                                }
                              ]
                            }
                          ]
                        }
                      }
            command.parameters.get_transitions__issueIdOrKey:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body
                          type: variable
                        - type: text
                          value: .key
      92be09bd-c18a-4c3d-8679-7ba518f1d7aa:
        id: 92be09bd-c18a-4c3d-8679-7ba518f1d7aa
        name: For Each (While)
        type: foreach
        on_success: 80008f0f-e5b4-4737-8327-a73cb7272549
        foreach:
          foreach: range(1;10)
          key_variable: idx
          key_variable_id: 6a6672a5-d01e-4e27-a6c7-542d43266e00
          value_variable: item
          value_variable_id: 2181c18b-77eb-4db7-b16d-06cbb46f3c19
          body: 5ab01604-2730-4928-b69d-7465c17169fc
        ui:
          position:
            x: 233.99999999999997
            'y': 337
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - type: text
                    value: range(1;10)
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d:
        id: 97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d
        name: TheHive Get Alert
        type: action
        on_success: b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: get_alert
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            get_alert__alertId: '{{ $input.payload.body.context._id }}'
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 233.99999999999997
            'y': 185
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.get_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input.payload
                          type: variable
                        - type: text
                          value: .body.context._id
      9cae18b7-85f2-4d55-ac89-479008bc952b:
        id: 9cae18b7-85f2-4d55-ac89-479008bc952b
        name: TheHive Update Comments
        type: action
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: update_comment
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
            update_comment__commentId: >-
              {{
              $steps["55b8600c-4bbb-44fe-b673-a5dcbb90269f"]["bcd7e0db-ec92-4b76-b964-723be675ef7c"]._id
              }}
            update_comment__message: >-
              {{ "[Synced]
              "+($steps["55b8600c-4bbb-44fe-b673-a5dcbb90269f"]["bcd7e0db-ec92-4b76-b964-723be675ef7c"].message
              // "") }}
        ui:
          position:
            x: 234
            'y': 925
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      [
                              {
                                  "_name": "getAlert",
                                  "idOrName":
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: |2-

                              },
                              {
                                  "_name": "comments"
                              }
                      ]
            command.parameters.get_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input.payload
                          type: variable
                        - type: text
                          value: .body.context._id
            command.parameters.update_comment__message:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - type: text
                          value: '"[Synced] "+('
                        - key: steps["55b8600c-4bbb-44fe-b673-a5dcbb90269f"]["bcd7e0db-ec92-4b76-b964-723be675ef7c"]
                          type: variable
                        - type: text
                          value: .message // "")
            command.parameters.update_comment__commentId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["55b8600c-4bbb-44fe-b673-a5dcbb90269f"]["bcd7e0db-ec92-4b76-b964-723be675ef7c"]
                          type: variable
                        - type: text
                          value: ._id
      a62d3626-4a91-4803-a1ea-0430d7ffd39e:
        id: a62d3626-4a91-4803-a1ea-0430d7ffd39e
        name: TheHive Get Comments
        type: action
        on_success: 55b8600c-4bbb-44fe-b673-a5dcbb90269f
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: post_query
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
            post_query__query: |-
              [
                      {
                          "_name": "getAlert",
                          "idOrName": "{{ $steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body._id }}"
                      },
                      {
                          "_name": "comments"
                      }
              ]
        ui:
          position:
            x: 234
            'y': 697
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.post_query__query:
              wireDoc:
                nodes:
                  - type: text
                    value: |-
                      [
                              {
                                  "_name": "getAlert",
                                  "idOrName": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: |-
                      "
                              },
                              {
                                  "_name": "comments"
                              }
                      ]
            command.parameters.get_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input.payload
                          type: variable
                        - type: text
                          value: .body.context._id
      b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5:
        id: b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5
        name: Create Jira Issue
        type: action
        on_success: 92be09bd-c18a-4c3d-8679-7ba518f1d7aa
        command:
          command: strangebee.integration.jira.v3
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: create_issue
            auth_type: basic_auth
            base_url: 'https://your-domain.atlassian.net'
            basic_auth_login: email@toreplace
            basic_auth_password: '<JIRA_API_TOKEN>'
            create_issue__fields: |-
              {
                "summary": "New TheHive Alert : {{ $steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body._id }} - {{ $steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body.title }}",
                "project": {
                  "key": "{{ $steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["2ae594c8-4eed-47e0-b301-07479f51b12b"] }}"
                },
                "issuetype": {
                  "name": "{{ $steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["476856f8-d6b0-4e3b-ad6b-4c62218d6987"] }}"
                },
                "description": {
                  "type": "doc",
                  "version": 1,
                  "content": [
                    {
                      "type": "paragraph",
                      "content": [
                        {
                          "type": "text",
                          "text": {{ $steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body.description | tojson }}
                        }
                      ]
                    }
                  ]
                }
              }
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 233.99999999999997
            'y': 261
          inputMode:
            command.parameters.create_issue__fields: json
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://your-domain.atlassian.net'
            command.parameters.basic_auth_login:
              wireDoc:
                nodes:
                  - type: text
                    value: email@toreplace
            command.parameters.basic_auth_password:
              wireDoc:
                nodes:
                  - type: text
                    value: '<JIRA_API_TOKEN>'
            command.parameters.create_issue__fields:
              wireDoc:
                nodes:
                  - type: text
                    value: "{\n  \"summary\": \"New TheHive Alert : "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: ._id
                  - type: text
                    value: ' - '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: .title
                  - type: text
                    value: |-
                      ",
                        "project": {
                          "key": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["2ae594c8-4eed-47e0-b301-07479f51b12b"]
                          type: variable
                  - type: text
                    value: |-
                      "
                        },
                        "issuetype": {
                          "name": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["e1d9a445-6ea6-4b01-ab09-ccbb08524a8d"]["476856f8-d6b0-4e3b-ad6b-4c62218d6987"]
                          type: variable
                  - type: text
                    value: "\"\n  },\n  \"description\": {\n    \"type\": \"doc\",\n    \"version\": 1,\n    \"content\": [\n      {\n        \"type\": \"paragraph\",\n        \"content\": [\n          {\n            \"type\": \"text\",\n            \"text\": "
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: .description | tojson
                  - type: text
                    value: |2-

                                }
                              ]
                            }
                          ]
                        }
                      }
      b6108bab-2bd2-48b7-81b8-a20b0c660518:
        id: b6108bab-2bd2-48b7-81b8-a20b0c660518
        name: Jira close issue
        type: action
        command:
          command: strangebee.integration.jira.v3
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: do_transition
            auth_type: basic_auth
            base_url: 'https://your-domain.atlassian.net'
            basic_auth_login: email@toreplace
            basic_auth_password: '<JIRA_API_TOKEN>'
            do_transition__issueIdOrKey: '{{ $steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body.key }}'
            do_transition__transition: >-
              {"id" : {{
              $steps["80008f0f-e5b4-4737-8327-a73cb7272549"].body.transitions[] |
              select(.name == "Done") | .id }}}
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 351
            'y': 517
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://your-domain.atlassian.net'
            command.parameters.basic_auth_login:
              wireDoc:
                nodes:
                  - type: text
                    value: email@toreplace
            command.parameters.basic_auth_password:
              wireDoc:
                nodes:
                  - type: text
                    value: '<JIRA_API_TOKEN>'
            command.parameters.add_comment__issueIdOrKey:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body
                          type: variable
                        - type: text
                          value: .key
            command.parameters.do_transition__transition:
              wireDoc:
                nodes:
                  - type: text
                    value: '{"id" : '
                  - type: context
                    expression:
                      nodes:
                        - key: steps["80008f0f-e5b4-4737-8327-a73cb7272549"].body
                          type: variable
                        - type: text
                          value: .transitions[] | select(.name == "Done") | .id
                  - type: text
                    value: '}'
            command.parameters.do_transition__issueIdOrKey:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["b3bc5fb5-305d-437c-9ffb-ee2a4cc6c1b5"].body
                          type: variable
                        - type: text
                          value: .key
      bfcd8d69-1923-4441-b52b-fcfdb5e3976f:
        id: bfcd8d69-1923-4441-b52b-fcfdb5e3976f
        name: Create TheHive comment
        type: action
        on_success: 47f251b7-69b7-4a5b-a65a-0d9b372705b8
        command:
          command: strangebee.integration.thehive.v1
          version: v1.0.0
          type: strangebee
          parameters:
            proxy_mode: disabled
            ssl_verification: default
            action: create_comment_in_alert
            auth_type: bearer_token
            base_url: 'https://thehive.example.com'
            bearer_token: '<THEHIVE_API_KEY>'
            create_comment_in_alert__alertId: '{{ $steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body._id }}'
            create_comment_in_alert__message: >-
              [From Jira] {{
              [$steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"].body
              | .. | objects | select(has("text")) | .text] | join("") }}
            editor_mode: form
            ssl_mtls: disabled
            manual_status_handling: false
        ui:
          position:
            x: 0
            'y': 697
          variableInputs:
            command.parameters.base_url:
              wireDoc:
                nodes:
                  - type: text
                    value: 'https://thehive.example.com'
            command.parameters.bearer_token:
              wireDoc:
                nodes:
                  - type: text
                    value: '<THEHIVE_API_KEY>'
            command.parameters.get_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: input.payload
                          type: variable
                        - type: text
                          value: .body.context._id
            command.parameters.create_comment_in_alert__alertId:
              wireDoc:
                nodes:
                  - type: context
                    expression:
                      nodes:
                        - key: steps["97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d"].body
                          type: variable
                        - type: text
                          value: ._id
            command.parameters.create_comment_in_alert__message:
              wireDoc:
                nodes:
                  - type: text
                    value: '[From Jira] '
                  - type: context
                    expression:
                      nodes:
                        - type: text
                          value: '['
                        - key: steps["d2783791-2971-4932-8c0c-7d0dc9a4f04a"]["92405c94-bc64-4d40-8b7f-b833477f367c"]
                          type: variable
                        - type: text
                          value: >-
                            .body | .. | objects | select(has("text")) | .text] |
                            join("")
      d2783791-2971-4932-8c0c-7d0dc9a4f04a:
        id: d2783791-2971-4932-8c0c-7d0dc9a4f04a
        name: ForEach Jira comments
        type: foreach
        on_success: a62d3626-4a91-4803-a1ea-0430d7ffd39e
        foreach:
          foreach: >-
            $steps["5d90b86c-6832-486c-b8e9-d214ed360c44"].body.comments

            | map(select((([.body | .. | objects | select(has("text")) | .text] |
            join(""))
                | startswith("[From TheHive]") | not)
              and (([.body | .. | objects | select(has("text")) | .text] | join(""))
                | startswith("[Synced]") | not)))
          key_variable: idx
          key_variable_id: 7c946d4f-8435-4ffa-a76b-f9d1e5bec055
          value_variable: item
          value_variable_id: 92405c94-bc64-4d40-8b7f-b833477f367c
          body: bfcd8d69-1923-4441-b52b-fcfdb5e3976f
        ui:
          position:
            x: 117
            'y': 593
          variableInputs:
            foreach.foreach:
              wireDoc:
                nodes:
                  - key: steps["5d90b86c-6832-486c-b8e9-d214ed360c44"].body
                    type: variable
                  - type: text
                    value: >-
                      .comments

                      | map(select((([.body | .. | objects | select(has("text")) |
                      .text] | join(""))
                          | startswith("[From TheHive]") | not)
                        and (([.body | .. | objects | select(has("text")) | .text] | join(""))
                          | startswith("[Synced]") | not)))
            foreach.key_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: idx
            foreach.value_variable:
              wireDoc:
                nodes:
                  - type: text
                    value: item
      e1d9a445-6ea6-4b01-ab09-ccbb08524a8d:
        id: e1d9a445-6ea6-4b01-ab09-ccbb08524a8d
        name: Set Jira Project Key and Issue Type
        type: action
        on_success: 97eb0a62-dcd5-4d4a-9785-4e0ad76a4c8d
        command:
          command: strangebee.variable.new
          version: v1.0.0
          type: strangebee
          parameters:
            variables:
              - id: 2ae594c8-4eed-47e0-b301-07479f51b12b
                name: jira_project_key
                type: string
                value: ''
              - id: 476856f8-d6b0-4e3b-ad6b-4c62218d6987
                name: jira_issue_type
                type: string
                value: ''
        ui:
          position:
            x: 233.99999999999997
            'y': 109
          variableInputs:
            command.parameters.variables:
              wireDocs:
                - nodes: []
                - nodes: []
      start--0:
        id: start--0
        type: start
        on_success: e1d9a445-6ea6-4b01-ab09-ccbb08524a8d
        ui:
          position:
            x: 233.99999999999997
            'y': 0
    created_by: admin@thehive.local
    created: '2026-09-10T13:27:37.018048Z'
    modified_by: admin@thehive.local
    modified: '2026-09-10T13:32:24.903579Z'
    ```

<h2>Next steps</h2>

* [Export or Import a Workflow](import-export-workflows.md)
* [Manage Workflows](manage-workflows.md)
* [Manage Global Variables](manage-global-variables.md)
