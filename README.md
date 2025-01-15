# Docs

[![Build Status](https://github.com/StrangeBeeCorp/docs/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/StrangeBeeCorp/docs/actions/workflows/pages/pages-build-deployment)

The documentation uses mkdocs to render the content.

## Test changes

### [Install Python and the Python manager pip](https://www.mkdocs.org/user-guide/installation/) (if not already installed)

### Create a virtual environment (recommended)
A virtual environment keeps dependencies isolated and avoids conflicts.

1. Create the virtual environment

Place it in a dedicated directory outside your project directory:

```bash
python3 -m venv ~/venvs/mkdocs-env
```

2. Activate the virtual environment

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

After activating, the name of your environment should appear in brackets at the beginning of your command line.

### Install the requirements

In your project directory, install the required dependencies:

```bash
pip install -r requirements.txt
```

### Start the mkdocs server in development mode

1. Run the MkDocs development server:

```bash
mkdocs serve
```

2. Once the server is running, open your browser and visit:

```http://127.0.0.1:8000```

#### Alternatively you can use a Docker container

If you prefer to use Docker instead of installing dependencies locally:

1. Build the Docker image

```bash
docker build . -t docs
```

2. Run the Docker container

```bash
docker run -it --rm -p 8000:8000 -v $PWD:/docs docs
```

## Deployment

The `main` branch is automatically deployed to [docs.strangebee.com](https://docs.strangebee.com)

If not:

```bash
mkdocs gh-deploy --remote-branch gh-pages
```

