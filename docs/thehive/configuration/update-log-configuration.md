# Update Log Configuration

TheHive uses [logback](https://logback.qos.ch/) for logging. You can adjust log levels to control the amount of information recorded for troubleshooting and monitoring purposes. By default, logs are stored in `/var/log/thehive/`, with the current log in `application.log` and older logs compressed as `application.%i.log.zip`.

{% include-markdown "includes/maintenance-window-required.md" %}

## Adjust log levels

Control the detail of logged information by modifying log levels in the logback configuration. Higher log levels capture more detailed information for troubleshooting.

!!! info "Docker deployment"
    Docker containers write logs to both stdout and `/var/log/thehive/application.log` by default. To use custom logging settings, mount your logback configuration file to `/etc/thehive/logback.xml`.

1. Stop TheHive service.

    !!! info "Service commands"
        For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

2. Open the `logback.xml` file using a text editor.

3. Modify the log level based on your needs.

    * To set a global log level:

    ```xml
    <!-- ... -->
    <root level="<log_level>">
        <!-- ... -->
    </root>
    ```

    * To set a specific logger level:

    ```xml
    <logger name="<logger_name>" level="log_level"/>
    ```

4. Choose the appropriate log level from least to most verbose.

    * OFF: No logging
    * ERROR: Only errors
    * WARN: Warnings and errors
    * INFO: General information (default)
    * DEBUG: Detailed debugging information
    * TRACE: Very detailed trace information

    !!! warning "Performance impact"
        Setting log levels to `DEBUG` or `TRACE` significantly increases log volume and may impact performance. Use these levels only for troubleshooting, then return to `INFO` for normal operation.

5. Save your modifications in the `logback.xml` file.

6. Restart TheHive service to apply the new configuration.

## Debug logback configuration

Enable logback debug mode to troubleshoot logging configuration issues. This displays logback internal status messages in the console during TheHive startup.

1. Stop TheHive service.

    !!! info "Service commands"
        For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

2. Open the `logback.xml` file using a text editor.

3. Set the debug attribute to `true`.

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <configuration debug="true">
    ```

4. Save your modifications in the `logback.xml` file.

5. Restart TheHive service to apply the new configuration.

6. Check the console output for logback configuration details during startup.

## Create an access log

Separate access logs from application logs by configuring dedicated log appenders. This allows you to track API requests and user access patterns independently from system logs.

1. Stop TheHive service.

    !!! info "Service commands"
        For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

2. Open the `logback.xml` file using a text editor.

3. Add an appender for access logs after the existing appenders:

    ```xml
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
    <root level="INFO">
        <!-- other appender-refs ... -->
    </root>
    ```

4. Configure the loggers to use the access appender.

    ```xml
    <logger name="org.thp.scalligraph.AccessLogFilter">
        <appender-ref ref="ASYNCACCESSFILE" />
    </logger>
    <logger name="org.thp.scalligraph.controllers.Entrypoint">
        <appender-ref ref="ASYNCACCESSFILE" />
    </logger>
    ```

5. Adjust the `maxFileSize` and `maxIndex` parameters as needed.

6. Save your modifications in the `logback.xml` file.

7. Restart TheHive service to apply the new configuration.

8. Verify access logs are being written to `/var/log/thehive/access.log`.

## Send logs to syslog

Forward TheHive logs to a centralized syslog server for aggregation and monitoring.

1. Stop TheHive service.

    !!! info "Service commands"
        For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

2. Open the `logback.xml` file using a text editor.

3. Add a syslog appender after the existing appenders.

    ```xml
    <!-- ... other appenders and settings -->
    <appender name="SYSLOG" class="ch.qos.logback.classic.net.SyslogAppender">
        <syslogHost><remote_host></syslogHost>
        <facility>AUTH</facility>
        <suffixPattern>[%thread] %logger %msg</suffixPattern>
    </appender>
    ```

4. Replace `<remote_host>` with your syslog server's host name or IP address.

5. Add the syslog appender to the root logger.

    ```xml
    <root level="INFO">
    <appender-ref ref="SYSLOG" />
    <!-- other appender-refs ... -->
    </root>
    ```

6. Save your modifications in the `logback.xml` file.

7. Restart TheHive service to apply the new configuration.

!!! warning "Limitations"
    The logback syslog appender only supports UDP protocol. For TCP or TLS connections, use a third-party appender or forward logs through a local syslog daemon. See the [logback documentation](https://logback.qos.ch/manual/appenders.html#SyslogAppender) for alternatives.

<h2>Next steps</h2>

* [Perform Initial Login and Setup as an Admin](../administration/perform-initial-setup-as-admin.md)