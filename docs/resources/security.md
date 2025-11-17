# Security and Data Protection

TheHive follows responsible security disclosure practices and implements specific data protection measures.

## Responsible disclosure

Our Responsible Vulnerability Disclosure policy and security advisories are available on our [Security GitHub repository](https://github.com/StrangeBeeCorp/Security){target=_blank}.

## Data protection

TheHive stores data using a combination of Cassandra database and Elasticsearch indexing. For more information, see [TheHive architecture](../thehive/overview/index.md#architecture).

### Database and storage

TheHive uses Cassandra, which relies on a [Bigtable model](https://docs.cloud.google.com/bigtable/docs/overview?hl=en){target=_blank} for data storage. Data are indexed in Elasticsearch.

TheHive doesn't support database encryption—data are stored in plaintext within the database. [Attachments](../thehive/user-guides/analyst-corner/cases/attachments/about-attachments.md) from cases, alerts, and organizations, as well as [observables](../thehive/user-guides/analyst-corner/cases/observables/about-observables.md) of type *file*, are also stored in their original form as plaintext.

### Password storage

Local account passwords are stored using strong cryptographic hashing. TheHive implements PBKDF2 (HMAC-SHA512 with 120,000 iterations) to protect user credentials.

This approach ensures that passwords remain protected against brute-force attacks even if the database is compromised.

<h2>Next steps</h2>

* [Install TheHive on Linux Systems](../thehive/installation/installation-guide-linux-standalone-server.md)
* [Configure a Local Authentication Provider](../thehive/administration/authentication/local.md)