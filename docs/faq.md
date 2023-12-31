
## FAQ

Frequently asked questions nobody asked.

### Security

This stack is designed for convenience and not security. Use a password manager and experiment behind safe network environments but DO NOT USE THE CONFIGURATION DEFAULTS FOR A PRODUCTION DEPLOYMENT. Config files with sensitive data are loaded into the containers for convenience and these should be swapped out for an appropriate secret management solution.

Bind-mounts of files in rootless podman/ container environments are a non-trivial solve, so injecting the files directly into the container at build time is often a more robust way to get demos up and running. At any point, sensitive configs could be committed to a container snapshot, so BE CAREFUL.

### Using Secrets

Secrets are a much better solution than mounting configuration files into the container, but they are not as easy to use and may vary between environments. There are other considerations to security anyway, so for production deployments it is assumed you know what you are doing, or at least will hire a consultant or seek out appropriate community advice. The default configuration leverages the secrets functionality from docker/ podman compose and should be sensible, but this is not a panacea and as stated above less desirable options may be included.

### PGPASS

The PGPASS file is likely to contain sensitive data that is not encrypted. Using the default configuration, it is additionally copied and mounted from the location of the compose secret and placed into the pgadmin volume mount, further increasing exposure.

### Jupyter Data

The Jupyter labs environment is configured to be tokenless to provide easy access to browser based notebooks with a preconfigured environment. If you wish to set up a central service for multiple users, it is recommended to integrate jupyter hub which is beyond the scope of this stacks intended functionality.

The jupyter data is mounted in the user home under the "work" directory. That means that when deploying with default configuration settings, any notebooks you save to `/work` should be available on the host machine. **The jupyter environment is not stateful outside of this directory and anything else you save outside of this directory will not be available when the service restarts**.

### Adding other ML/ AI Frameworks

This project includes sensible and simple defaults. Larger project contexts, such as using Tensorflow with GPU enabled processing from a containerized environment, have additional considerations that fall beyond the scope of this project. Jupyter even have more appropriate starting containers for some of those projects, but they aren't likely to be considered here.

### Podman

The stack was designed and built in an environment that utilizes Podman Desktop on Windows, and so should be compatible with OCI and rootless podman environments. Docker plugin support is required for healthchecks to work appropriately, and users of Docker may . Named volumes are used to prevent permission issues. Some container images, such as jupyter and pgadmin, may "add" configuration files into the container image (which contain sensitive data - this is the default setting for convenience but may be changed as needed) rather than mounting local relative path files as a volume or secret. This is primarily done to ensure ease of use across OCI compatible environments but users of Docker may switch those out as necessary (which is **required** when deploying a centralized service).

Your podman machine might also require plugins to function as expected, which can be installed with `sudo dnf -y install podman-plugins containernetworking-plugins`.

### DNS Issues

Podman desktop may experience issues with DNS resolution between containers.

https://github.com/containers/podman-desktop/issues/401

cat /etc/resolv.conf

```
# This file was automatically generated by WSL. To stop automatic generation of this file, add the following entry to /etc/wsl.conf:
# [network]
# generateResolvConf = false
nameserver 172.24.64.1
```

`sudo vi /etc/wsl.conf`.

```
[network]
generateResolvConf = false
```

`sudo vi /etc/resolv.conf`

```
nameserver 8.8.8.8
```

### Exposing Port 80

A bunch of distros won't allow lower ports to be exposed by default, which likely includes the default setup of podman desktop with rootless configuration. Using a reverse proxy is typically recommended for such functions, however some desktop users may want to utilize/ expose lower ports by default. Various other limits may exist for your environment, but if using podman desktop you can review the details on the [containers repo](
https://github.com/containers/podman/blob/main/rootless.md).

Note that if you are proxying to pgadmin under a route or "subpath", you will need to set the `X-Script-Name` header on your proxy to prevent issues with links and redirects within the application.
