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

## Docs

Check out the [docs site](https://zacharlie.github.io/spatial-ds-stack) or folder, or run a local web server with the root at the docs dir to load the docs with docsify.

You can also simply run a web server in the docs dir, as illustrated by `serve.cmd`.
