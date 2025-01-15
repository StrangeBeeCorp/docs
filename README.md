# Docs

[![Build Status](https://github.com/StrangeBeeCorp/docs/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/StrangeBeeCorp/docs/actions/workflows/pages/pages-build-deployment)

The documentation uses MkDocs to render the content.

## Test changes

1. Install Python and the Python manager pip (if not already installed)

2. Create a virtual environment (recommended)
A virtual environment keeps dependencies isolated and avoids conflicts.

   - Create the virtual environment

Place it in a dedicated directory outside your project directory:

```bash
python3 -m venv ~/venvs/mkdocs-env
```

   - Activate the virtual environment

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

3. Install the requirements

In your project directory, install the required dependencies:

```bash
pip install -r requirements.txt
```

4. Start the MkDocs server in development mode

   - Run the MkDocs development server:

```bash
mkdocs serve
```

   - Once the server is running, open your browser and visit http://127.0.0.1:8000

#### Alternatively: Use a Docker container

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

