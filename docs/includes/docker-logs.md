!!! info "Docker deployment"
    Docker containers write logs to both stdout and `application.log` by default. To use custom logging settings, mount your logback configuration file to `logback.xml`.