# Spatial DS Stack

A simple stack for using Jupyter Notebooks to analyze data from local sources in a geographic context.

- https://github.com/zacharlie/spatial-ds-stack
- https://zacharlie.github.io/spatial-ds-stack

> This is experimental and meant for testing and desktop use with a focus on convenience over security. Do not attempt to deploy this stack on shared infrastructure without either having a clear understanding of what you are doing or working with the support of a competent consultant.

## TL;DR

```sh
git clone https://github.com/zacharlie/spatial-ds-stack.git
```

Run `config/_prepare.cmd` to clone example configs and edit accordingly.

Run the stack by navigating to the root directory and running

```sh
podman-compose up -d --build
```

Navigate to the Jupyter Environment by pointing your browser to http://127.0.0.1:8888

Shut it down

```sh
podman-compose down -v
```

## Quickstart

You need to configure your database and gateway credentials before spinning up the stack. Database credentials may need to be adjusted in multiple locations for various services, however most of the files which require bespoke configuration include the `.example` extension and simply making a copy of these files (sans `.example` file extension).

### Prerequisites

[Docker](https://www.docker.com/products/docker-desktop/) and docker-compose, or [podman](https://podman-desktop.io/) and podman/ docker-compose (Install [python](https://www.python.org/downloads/) or [mamba](https://github.com/conda-forge/miniforge#mambaforge) and run `pip install podman-compose`).

### Configuration

First, copy the example files and set the relevant parameters.

- `.env`: Copy from provided example. This is not tracked by git as this may contain sensitive data, 
    such as service usernames and passwords. This file is automatically mounted into the compose context 
    as a series of environment variables (exposed only to the host), and you can assign specific environment 
    variables to individual containers in the relevant `environment` section. This allows for the majority of 
    stack configuration, such as the service ports exposed on the host system and administrative database 
    credentials, to be specified within a single file. This file should be kept secure and private at all times.
- `readme.ipynb`: This is mounted as a compose secret as a file component and shows how default notebooks can be 
    exposed to the jupyter environment in the root system (without adding them to a container volume).
- `jupyter-config-cred`: Copy from provided example. This is not tracked by git as this may contain sensitive data, 
    such as remote database connection details. This is mounted as a compose secret.
- `pgadmin-config-servers`: Copy from provided example. This is not tracked by git as this may contain
    sensitive data, such as remote database connection details. This is mounted as a compose secret. 
    The `servers.json` file which this maps to is used by pg admin to automatically create service hosts 
    which do not require manual creation on the server and provides an interface for exported PGAdmin services 
    to be introduced to the service by default. Note that the PGAdmin container should still include a named volume
    for service data, so manually created services should remain available to users and preserve service state,
    allowing for this option to be safely removed if deemed a security risk.
- `pgadmin-config-cred`: Copy from provided example. This is not tracked by git as this contains sensitive 
    data, including database and web service credentials. This is mounted as a compose secret. The file is mounted 
    as a [pgpassfile](https://www.postgresql.org/docs/current/libpq-pgpass.html) which contains database credential 
    details in the format of `hostname:port:database:username:password`. This should allow passwordless access to 
    databases in PGAdmin if defined with the relevant service configuration as illustrated in *pgadmin-config-servers*. 
    This is provided for illustration purposes and convenience but can be safely removed if deemed a security risk.
- `init-setup-db.sql`: Copy from provided example. This is not tracked by git as this may contain sensitive data, 
    such as custom user creation and sample data. This is mounted as a compose secret.

### Other files

Other available files should be mostly self explanatory, including service Dockerfiles for the relevant services and auxiliary files for the relevant container services.

- `init-create-db.sql`: An initialization script for the database container that is always available and always runs.
    Currently this file simply creates the mlflow database. This is added into the container image at build time.
- `wait-for-it.sh`: simple [bash script](https://github.com/vishnubob/wait-for-it) to wait for a database connection before running a service.

### Startup

Use docker-compose (or podman compose). Make sure you're running these commands in the root directory of this repo.

First run: `docker-compose up -d --build`

Thereafter: `docker-compose up -d`

To build a particular image (rebuild on credential changes):

```
docker-compose build db
docker-compose build jupyter
docker-compose build mlflow
docker-compose build pgadmin
```

### Shut Down

`docker-compose down` spins down the stack. To delete associated volumes use `docker-compose down -v`. To remove dangling volumes after shutdown (if you didn't use `-v`) use `docker volume prune` or `podman volume prune`.

### Cleanup

Remember that the container images may include sensitive data in the containers! Be sure to always use generic passwords and remove the stack when not in use. The easiest way to clean up the stack is by shutting down and using the prune command, e.g. `podman images prune -a` or `podman images prune -a`.

## Have Fun!

![Sample Image](./assets/avatar.png)
