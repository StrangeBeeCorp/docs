# Logs Configuration

TheHive uses [logback](https://logback.qos.ch/) to log information about the running process. The loggers are configured in the file `/etc/thehive/logback.xml`. Edit this file and reload the service to apply your changes.

By default, logs are stored in `/var/log/thehive/`. The last log file is called `application.log` and older filed are stored in a compressed format in `application.%i.log.zip`. 


## How to increase/decrease the log level

Logback supports several log levels. 

To log more things you can update the root level to `DEBUG` (or `TRACE`):

```xml title="logback.xml"
    <!-- ... -->
    <root level="DEBUG">
        <!-- ... -->
    </root>
```

To log less things you can use `WARN`, `ERROR` or `OFF` levels.

The log level can also be updated individually by changing the level of a specific logger:

```xml title="logback.xml"
    <logger name="org.thp" level="DEBUG"/>
```

## How to create an access log

By changing the logback configuration, you can redirect certain logs from the application.
Below is an example where access logs are redirected to the file `access.log` and uses a rolling file strategy.

To apply this in your configuration, copy the `appender`s and modify the `root` definition.

```xml title="logback.xml"
<?xml version="1.0" encoding="UTF-8"?>
<configuration debug="false">

    <!-- ... other appenders and settings -->

    <appender name="ACCESSFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <filter class="ch.qos.logback.core.filter.EvaluatorFilter">
            <evaluator>
                <expression>return logger.contains("org.thp.scalligraph.AccessLogFilter") || logger.contains("org.thp.scalligraph.controllers.Entrypoint");</expression>
            </evaluator>
            <OnMismatch>DENY</OnMismatch>
            <OnMatch>NEUTRAL</OnMatch>
        </filter>

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
        <appender-ref ref="ASYNCACCESSFILE"/>
        <!-- other appender-refs ... -->
    </root>

</configuration>

```

!!! attention

    Logback's `evaluator` requires the library janino to be included in the classpath of TheHive ([see docs](https://logback.qos.ch/setup.html#janino)).
    This library is **not included** in TheHive < 5.1 but is included in superior versions starting from version 5.1

    If the library is not included and the evaluator is used, you will get the error ` java.lang.NoClassDefFoundError: org/codehaus/janino/ScriptEvaluator`


## Logs in docker

In the docker container the logger is configured with the file `/etc/thehive/logback.xml` and the application by default will log to `stdout` and to `/var/log/thehive/application.log`.

If you want to change the default configuration, you can mount your own logback file to `/etc/thehive/logback.xml`.
