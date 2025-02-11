# Downloading Cortex  

Cortex is available in multiple binary package formats, making installation flexible across various operating systems. Choose the method that best suits your environment.

---

## :material-debian: Debian / :material-ubuntu: Ubuntu Installation  

### Step 1: Import the GPG Key  

Before adding the repository, import TheHive project's GPG key for package verification:

```bash
wget -qO- https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | sudo gpg --dearmor -o /usr/share/keyrings/thehive-project-archive-keyring.gpg
```

### Step 2: Add TheHive Project Repository  

Create a new repository configuration file:

```text
# /etc/apt/sources.list.d/thehive-project.list
deb [signed-by=/usr/share/keyrings/thehive-project-archive-keyring.gpg] https://deb.thehive-project.org release main
```

### Step 3: Update Package Lists and Install Cortex  

```bash
sudo apt update
sudo apt install cortex
```

---

## :material-redhat: Red Hat Enterprise Linux / :material-fedora: Fedora Installation  

### Step 1: Import the GPG Key  

Run the following command to import TheHive project’s GPG key:

```bash
sudo rpm --import https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY
```

### Step 2: Add TheHive Project Repository  

Create a repository configuration file:

```text
# /etc/yum.repos.d/thehive-project.repo
[thehive-project]
enabled=1
priority=1
name=TheHive-Project RPM repository
baseurl=https://rpm.thehive-project.org/release/noarch
gpgcheck=1
```

### Step 3: Install Cortex  

```bash
sudo dnf install cortex  # Fedora
sudo yum install cortex  # RHEL-based systems
```

---

## :material-folder-zip: Download as a ZIP Archive  

For manual installation, download the latest Cortex release as a ZIP archive:

🔗 **[Download Cortex ZIP](https://download.thehive-project.org/cortex-latest.zip)**  

After downloading, extract the archive:  

```bash
unzip cortex-latest.zip -d cortex
cd cortex
```

---

## :material-docker: Docker Installation  

Cortex is also available as a Docker image, simplifying deployment.

### Step 1: Pull the Latest Cortex Image  

```bash
docker pull thehiveproject/cortex
```

### Step 2: Run Cortex  

```bash
docker run -d --name cortex -p 9001:9001 thehiveproject/cortex
```

🔗 **[View Cortex on Docker Hub](https://hub.docker.com/r/thehiveproject/cortex)**  

---

## Archives  

There are currently no archived versions of Cortex available.