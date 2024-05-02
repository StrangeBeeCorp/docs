# Logs Configuration

TheHive utilizes [logback](https://logback.qos.ch/) for logging purposes, allowing users to monitor the running process effectively. The logging settings are managed through the configuration file located at `/etc/thehive/logback.xml`. Changes made to this file require a service reload to take effect.

By default, logs are stored in `/var/log/thehive/`, with the most recent log file named application.log, while older files are compressed and stored as `application.%i.log.zip`.

---

## Adjusting Log Levels

Logback offers various log levels to control the amount of information logged. To increase or decrease the log level: 

Update the root level to DEBUG or TRACE to log more information:

```xml title="logback.xml"
    <!-- ... -->
    <root level="DEBUG">
        <!-- ... -->
    </root>
```

Alternatively, adjust the log level for specific loggers:

```xml title="logback.xml"
    <logger name="org.thp" level="DEBUG"/>
```

You have the option to select from the following additional log levels: WARN, ERROR, or OFF.

---

## Docker Logs Configuration

In a Docker container, TheHive logs to stdout and `/var/log/thehive/application.log` by default. To customize this behavior, mount your own logback file to `/etc/thehive/logback.xml`.

---

## Debugging Logback Configuration

To troubleshoot logback configuration issues, set the debug flag to true in logback.xml:

```xml title="logback.xml"
<?xml version="1.0" encoding="UTF-8"?>
<configuration debug="true">

```

This will log the logback configuration in the console during application startup.

---

## Creating an Access Log

To redirect certain logs from the application, such as access logs, modify the logback configuration. Here's an example configuration for redirecting access logs to a file named access.log using a rolling file strategy:

To add this into your configuration, duplicate the definitions of `appender` and `logger` as demonstrated below.

```xml title="logback.xml"
<?xml version="1.0" encoding="UTF-8"?>
<configuration debug="false">

    <!-- ... other appenders and settings -->

    <appender name="ACCESSFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>/var/log/thehive/access.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
            <fileNamePattern>/var/log/thehive/access.%i.log.zip</fileNamePattern>
            <minIndex>1</minIndex>
            <maxIndex>10</maxIndex>
        </rollingPolicy>
        <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
            <maxFileSize>10MB</maxFileSize>
        </triggeringPolicy>

        <encoder>
            <pattern>%date [%level] from %logger [%traceID] %message%n%xException</pattern>
        </encoder>
    </appender>

    <appender name="ASYNCACCESSFILE" class="ch.qos.logback.classic.AsyncAppender">
        <appender-ref ref="ACCESSFILE"/>
    </appender>

    <logger name="org.thp.scalligraph.AccessLogFilter">
        <appender-ref ref="ASYNCACCESSFILE" />
    </logger>
    <logger name="org.thp.scalligraph.controllers.Entrypoint">
        <appender-ref ref="ASYNCACCESSFILE" />
    </logger>

    <root level="INFO">
        <!-- other appender-refs ... -->
    </root>

</configuration>

```

---

## Sending Logs to Syslog

To send logs to syslog, add a `SyslogAppender` to the logback configuration:

```xml title="logback.xml"
<?xml version="1.0" encoding="UTF-8"?>
<configuration debug="false">

    <!-- ... other appenders and settings -->

    <appender name="SYSLOG" class="ch.qos.logback.classic.net.SyslogAppender">
        <syslogHost>remote_host</syslogHost>
        <facility>AUTH</facility>
        <suffixPattern>[%thread] %logger %msg</suffixPattern>
    </appender>

    <root level="INFO">
        <appender-ref ref="SYSLOG" />
        <!-- other appender-refs ... -->
    </root>

```

Refer to the [**official documentation**](https://logback.qos.ch/manual/appenders.html#SyslogAppender) for more details.

**Limitations:**
The official syslog appender only supports sending logs via UDP to a server and does not support TCP and TLS.

&nbsp;