# Docs

[![Build Status](https://drone.strangebee.com/api/badges/StrangeBeeCorp/docs/status.svg?ref=refs/heads/develop)](https://drone.strangebee.com/StrangeBeeCorp/docs)

The documentation uses mkdocs to render the content.

## Test changes

```bash
# Install the requirements first
pip install -r requirements.txt

# Start the mkdocs server in development mode
mkdocs serve
```

Alternatively you can use a docker container:

```bash
docker build . -t docs
docker run -it --rm -p 8000:8000 -v $PWD:/docs docs
```

## Deployment

The `main` branch is automatically deployed to [docs.strangebee.com](https://docs.strangebee.com)

If not:

```bash
mkdocs gh-deploy --remote-branch gh-pages
```

