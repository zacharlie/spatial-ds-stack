# Commands

Reference commands for useful implementation and development operations.

## General

Squash the history on a notebook and clean it with 

```sh
jupyter nbconvert --clear-output --inplace my_notebook.ipynb
```

This operation is expected to be executed before committing changes to a notebook.

You can run a local instance of the pgadmin container _outside_ of the container stack with

```sh
podman run --rm -p 9999:80 -e PGADMIN_DEFAULT_EMAIL=pgadmin@local.host -e PGADMIN_DEFAULT_PASSWORD=replaceme docker.io/dpage/pgadmin4:7.3
```

to assist with troubleshooting container related issues such as dns or volume permissions.

## Nerd

Containers form a core part of the stack, so users should know (at least the basics of) how to use containers.

> Note that the Stack implementation has a focus on the use of `podman`, which should function identically to the `docker` cli tools for most cases.

For example, `podman run -d docker.io/supabase/postgres:15.1.0.73` will run postgres. Container engines now have desktop apps, so this should be fairly easy.

Example Cheatsheet: https://dockerlabs.collabnix.com/docker/cheatsheet/

## Copying to and from containers

Useful for mounting additional secrets, retrieving defaults, and debugging container operation scripts

The syntax `docker cp <containerId>:/file/path/within/container /host/path/target` copies a file from within the container to localhost path, e.g. `podman cp 01eaf8d882e131e998169473683c1d5545544eccbf198924e24d8871ae34452f:/etc/postgresql/postgresql.conf /mnt/d/pgconf.txt`.

Conversely, `podman cp /mnt/d/Dev/stack/utils/initdb-template.sh a539645de868:/docker-entrypoint-initdb.d/init.sh` copies a local file into a container.

## WSL

(Linux) Containers are going to likely be running on Windows Subsystem for Linux (regardless of daemon/ engine).

```
wsl -d podman-machine-default
```

## Geo2Db

The Geo2Db container is preconfigured to load spatial datasets (gpkg/ geojson) into the `geodata` database in the stacks postgresql.

It only watches for file changes using on the `inotify` operation, and this is not supported by WSL (even other utilities such as watchman and watchdog probably require polling to function).

The easiest approach to forcing an update is modifying a trigger file from within the container itself.

cd into the `/data` directory first and then create a trigger `rm .trigger & touch .trigger && rm .trigger`.

Currently, this will reload *all* data and overwrite the existing tables (but not drop existing ones).

## Packages

Keeping packages and dependencies in line with working versions and avoiding conflicts can be challenging. To list the available versions for a package use `conda search -f <package_name> -c conda-forge`.

## Jupyter

Useful functions within the python environment and using the included libraries.

### pandas

Direct SQL execution `df = pd.read_sql_query("select * from <table>", con=conn)`

### DuckDB

In Process-SQL-OLAP database, which basically provides an effective sql interface to dataframes and other content, amongst other things.

```python
import duckdb
r1 = duckdb.sql('SELECT 42 AS i')
duckdb.sql('SELECT i * 2 AS k FROM r1').show()
```

```python
# directly query a Pandas DataFrame
import pandas as pd
pandas_df = pd.DataFrame({'a': [42]})
duckdb.sql('SELECT * FROM pandas_df')
```

### Plotly

```python
import plotly.express as px
fig = px.scatter(x=data['Carat Weight'], y=data['Price'], 
                 facet_col = data['Cut'], opacity = 0.25, template = 'plotly_dark', trendline='ols',
                 trendline_color_override = 'red', title = 'SARAH GETS A DIAMOND - A CASE STUDY')
fig.show()
```

## External Docs

https://github.com/jupyter-widgets/ipyleaflet

https://pycaret.gitbook.io/docs/learn-pycaret/official-blog/easy-mlops-with-pycaret-and-mlflow
