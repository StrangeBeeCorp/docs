# Docs

[![Build Status](https://github.com/StrangeBeeCorp/docs/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/StrangeBeeCorp/docs/actions/workflows/pages/pages-build-deployment)

The documentation uses MkDocs to render the content.

## Test changes

### Option 1: Use Python locally

This method uses Python installed directly on your machine to run the MkDocs server.

#### 1. Install Python and pip (if not already installed)

#### 2. Create a virtual environment (recommended)
A virtual environment keeps dependencies isolated and avoids conflicts.

##### 2.1 Create the virtual environment

Place it in a dedicated directory outside your project directory:
```bash
python3 -m venv ~/venvs/mkdocs-env
```

 ##### 2.2 Activate the virtual environment

* Linux/macOS
```bash
source ~/venvs/mkdocs-env/bin/activate
```

* Windows (Command Prompt)
```cmd
~/venvs/mkdocs-env\Scripts\activate
```

* Windows (PowerShell)
```powershell
~/venvs/mkdocs-env\Scripts\Activate.ps1
```

##### 2.3 Verify activation

The name of your environment should appear in brackets at the beginning of your command line.

#### 3. Install the requirements

In your project directory, install the required dependencies:

```bash
pip3 install -r requirements.txt
```

#### 4. Start the MkDocs server

 ##### 4.1 Run the MkDocs development server:

```bash
mkdocs serve
```

If you want to catch potential issues, such as broken links or missing resources, you can run the development server in strict mode:

```bash
mkdocs serve --strict
```

##### 4.2 Once the server is running, open your browser and visit http://127.0.0.1:8000.

### Option 2: Use a Docker container

This method uses Docker to run the MkDocs server in an isolated container. All dependencies, including Python, are installed inside the container.

##### 1. Build the Docker image

The Docker image bundles Python, MkDocs, and all necessary dependencies:
```bash
docker build . -t docs
```

##### 2. Run the Docker container

Start the container and expose the documentation server locally:
```bash
docker run -it --rm -p 8000:8000 -v $PWD:/docs docs
```

##### 3. The documentation server will be accessible at: http://127.0.0.1:8000.

## Deployment

The `main` branch is automatically deployed to [docs.strangebee.com](https://docs.strangebee.com).

If not:

```bash
mkdocs gh-deploy --remote-branch gh-pages
```

:bulb: please also note that each PR is temporary deployed to `docs.strangebee.com/pr-preview/pr-${PR_ID}/`.
This environment is automatically created and dropped when the PR is closed or
merged!
