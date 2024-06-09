
# Introduction to Docker and Docker Compose

## What is Docker?

Docker is a platform that allows you to develop, ship, and run applications in containers. Containers are lightweight, portable, and ensure that your application works seamlessly in any environment. Here are some key points about Docker:

- **Isolation**: Containers isolate your application from the underlying system, ensuring consistency across different environments.
- **Portability**: Docker containers can run on any machine that has Docker installed, making it easy to move applications between development, testing, and production environments.
- **Efficiency**: Containers share the host system's kernel, making them more lightweight than traditional virtual machines.

## Installing Docker

To install Docker on your system, follow these steps:

1. Go to the [Docker website](https://www.docker.com/products/docker-desktop) and download Docker Desktop for your operating system.
2. Follow the installation instructions for your OS.
3. After installation, open Docker Desktop to ensure it is running correctly.

## Basic Docker Commands

Here are some basic Docker commands to get you started:

- `docker pull <image>`: Downloads a Docker image from Docker Hub.
- `docker run <image>`: Runs a container from the specified image.
- `docker ps`: Lists all running containers.
- `docker stop <container_id>`: Stops a running container.
- `docker rm <container_id>`: Removes a stopped container.
- `docker images`: Lists all downloaded Docker images.

## What is Docker Compose?

Docker Compose is a tool that allows you to define and manage multi-container Docker applications. Using a YAML file, you can specify the services, networks, and volumes needed for your application. This makes it easy to manage and deploy complex applications with a single command.

## Installing Docker Compose

Docker Compose is included with Docker Desktop. If you need to install it separately, follow these steps:

1. Go to the [Docker Compose release page](https://github.com/docker/compose/releases).
2. Download the appropriate version for your operating system.
3. Follow the installation instructions for your OS.

## Basic Docker Compose Commands

Here are some basic Docker Compose commands to get you started:

- `docker-compose up`: Builds, (re)creates, starts, and attaches to containers for a service.
- `docker-compose down`: Stops and removes containers, networks, images, and volumes created by `docker-compose up`.
- `docker-compose build`: Builds or rebuilds services.
- `docker-compose ps`: Lists containers.
- `docker-compose logs`: Shows logs of running services.

## Example Docker Compose File

Below is an example of a simple `docker-compose.yml` file that defines a web application and a database service:

```yaml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
  db:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: example
```

## Conclusion

This guide provides a brief overview of Docker and Docker Compose. These tools are powerful and can greatly simplify the process of developing, shipping, and running applications. In the next sections, we will focus on how to use these tools specifically with TheHive.
