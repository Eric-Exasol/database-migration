# Test files for "Database migration" repository

###### Please note that this is an open source project which is *not officially supported* by Exasol. We will try to help you as much as possible, but can't guarantee anything since this is not an official Exasol product.

## Overview

This folder contains the test files needed to automatically test the scripts of the Exasol "Database Migration" repository.
The executable test files are in the subfolder `testing_files`.

## Test structure
Before the tests are executed, an exasol docker container has been built (the name of the container is `exasoldb`) with the commands found in the `exasol_docker.sh` file.


Each test has the same following structure : 
1. Running a container from another data management systems (MySQL, Postgres, SQL-Server, etc.)
2. Creating a database and inserting data within this container
3. Creating a connection from the `exasoldb` container to the other container
4. Creating the script corresponding to the data management system. For example, if we ran a mysql container, the script found in the `mysql_to_exasol.sql` file of the database-migration repository will be created. This script is created using the `create_script.py` file. (This python script uses the `generate_script.sql` file to only create the scripts find inside the `mysql_to_exasol.sql` file.)
5. Executing the script created : this step will create the statements to import the all the data from the other data management system into exasol and will write these statements into an `output.sql` file. The script execution is done by the `export_res.py` file.
6. Executing the `output.sql` file by the `exasoldb` container to create the tables and import the data into an exasol database.

If there is any errors in any of these steps, the travis build will break and fail. 
If there is no errors, the build will succeed.