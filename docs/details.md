
### Functionality

The stack spins up a local PostgreSQL instance alongside an MLFlow server and Jupyter labs notebook within a docker compose stack. PGAdmin is included for database management, as well as a flatfile geodata loading service (currently wip).

The default image for (jupyter/scipy-notebook)[
https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile#!] should include packages for common data science tasks, including:

- `pandas` - data
- `numpy` - maths
- `matplotlib` - dataviz
- `seaborn` - dataviz
- `bokeh` - dataviz
- `sqlalchemy` - orm
- `dask` - compute

and more.

We still need to include additional libraries in the build, such as:

- `mlflow`: mlflow manages ml lifecycles
- `psycopg`: psycopg (2) is a postgresql connector (mlflow and jupyter need it, but psycopg3 is the fresher async version)
- `pycaret`: a low-code mlops tool
- `scikit-learn`: a convenient and easy to use ml toolkit


### General Info

- default database name (stack postgresql instance) = `dbdata`
- default db admin username = `dbadmin`
- provided db username and password for operations (non-superuser credential) `nbuser` `Fhbw1b7y1dlwvT0BRamW`. When changing this value be sure to change it in both the jupyter config credential and the .env config.
