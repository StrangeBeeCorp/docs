!!! danger "Only run code you trust"
    The script is executed as is on the server, with the same trust as the person who wrote it. Unlike the other nodes, the script has no network restrictions: it can reach any system the server can, including your internal network. Only paste code you understand, and review the code nodes of any [imported workflow](/flow/user-guides/import-export-workflows/) before running it.

    A [secret variable](/flow/user-guides/manage-global-variables/) the script reads is handed to it in clear. Anything the script prints ends up in its `script_out` output and in the [execution logs](/flow/user-guides/display-execution-logs/), so never print a secret.
