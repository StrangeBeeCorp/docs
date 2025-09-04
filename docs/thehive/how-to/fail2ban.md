# Fail2ban

Fail2ban is an intrusion prevention software designed to enhance the security of Linux systems by actively monitoring logs for suspicious activity and dynamically blocking malicious IP addresses. By automatically responding to potential threats such as repeated failed login attempts or suspicious access patterns, Fail2ban acts as a proactive defense mechanism, fortifying servers against various forms of cyberattacks.

---

## Adding TheHive into Fail2ban

To integrate TheHive logs with Fail2ban, follow the steps below. Assume TheHive logs are located at `/var/log/thehive/application.log` and Fail2ban configuration files are located in `/etc/fail2ban`.

1. **Step 1**: Create a Filter File

    - Create a filter file in `/etc/fail2ban/filter.d` named `thehive.conf` with the following content:

    ```
    [INCLUDES]
    before = common.conf
    
    [Definition]
    failregex = ^.*- <HOST> (?:POST \/api\/login|GET .*) .*returned 401.*$
    ignoreregex =
    ```

2. **Step 2**: Create a Jail File

    - Create a jail file in `/etc/fail2ban/jail.d` named `thehive.local` with the following content:

    ```
    [thehive]
    enabled = true
    port = 80,443
    filter = thehive
    action = iptables-multiport[name=thehive, port="80,443"]
    logpath = /var/log/thehive/application.log
    maxretry = 5
    bantime = 14400
    findtime = 1200
    ```

    This configuration will ban any IP address for 4 hours after 5 failed authentication attempts within a 20-minute period.

3. **Step 3**: Reload Fail2ban Configuration

    - Reload the Fail2ban configuration to apply the changes:

    ```bash
    fail2ban-client reload
    ```

---

## Review Banned IP Addresses

Here is a step-by-step guide to reviewing banned IP addresses on Fail2ban:

1. Step 1: Check Fail2ban Status:

    Use the following command to get an overview of Fail2ban status and active jails:

    ```bash
    sudo fail2ban-client status
    ```

2. Step 2: Review Banned IPs for a Specific Jail

    Use this command to view banned IPs in a particular jail.

    ```bash
    sudo fail2ban-client status thehive
    ```

---

## Unban an IP Address

Use the following command to remove the ban on a specific IP address. Replace `jail_name` with the jail's name and `IP_address` with the specific IP address you want to unban:

```bash
sudo fail2ban-client set thehive unbanip 1.1.1.1
```

&nbsp;