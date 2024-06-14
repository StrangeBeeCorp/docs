
# Troubleshooting

For some issues, additional information in logs is needed to troubleshoot and understand the root causes. To gather and share this information, please carefully read and follow these steps.

!!! Warning
    **ENABLING TRACE LOGS HAS A SIGNIFICANT IMPACT ON PERFORMANCE. DO NOT ENABLE IT ON PRODUCTION SERVERS.**

--- 

## Step 1: Stop TheHive Service

First, stop TheHive service:

```bash
service thehive stop
```

Ensure the service is stopped with the following command:

```bash
service thehive status
```

---

## Step 2: Renew `application.log` File

Move the existing `application.log` file to a backup location:

```bash
mv /var/log/thehive/application.log /var/log/thehive/application.log.bak
```

---

## Step 3: Update Log Configuration

Edit the log configuration file `/etc/thehive/logback.xml`. Locate the line containing `<logger name="org.thp" level="INFO"/>` and update it to the following:

```xml
    <logger name="org.thp" level="TRACE"/>
```

Save the file after making the changes.

---

## Step 4: Restart TheHive Service

Restart TheHive service:

```bash
service thehive start
```

A new log file `/var/log/thehive/application.log` will be created and will contain extensive logging information.

---

## Step 5: Monitor and Save Logs

Wait for the issue to occur or for the application to stop. Then, copy the log file to a safe location:

```bash
cp /var/log/thehive/application.log /root
```

---

## Step 6: Share the Logs

Create an issue on [GitHub](https://github.com/StrangeBeeCorp/TheHive-feedback/issues/new?assignees=&labels=bug%2C+TheHive&template=bug_report.md&title=%5BBug%5D) and include the following information:

- **Context:**
  - Instance type (single node/cluster, backend type, index engine)
  - System details (Operating System, amount of RAM, number of CPUs for each server/node)

- **Symptoms:**
  - Actions taken, how the situation occurred, and what happened

- **Log File:**
  - Attach the log file with trace information

---

## Step 7: Revert Log Configuration

To revert to the normal log configuration:

1. Stop TheHive service.
2. Edit the `logback.xml` file to restore the previous log level configuration.
3. Restart TheHive service.

```bash
service thehive stop
# Restore the logback.xml file to previous state
service thehive start
```

&nbsp;