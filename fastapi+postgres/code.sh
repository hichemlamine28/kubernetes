#!/bin/bash

pip install fastapi uvicorn sqlalchemy psycopg2-binary




# After code is OK tape this command:
uvicorn main:app --reload


# For Docker Build:
docker build -t hichemlamine/fastapi:postgres .

# Push
docker push hichemlamine/fastapi:postgres

# Run Docker
docker run --network=host -e "DB_DBNAME=quiz" -e "DB_PORT=5432" -e "DB_USER=postgres" -e "DB_PASS=postgres" -e "DB_HOST=127.0.0.1" -p 8000:80 hichemlamine/fastapi:postgres

# OR Just:
docker run --network=host -p 8000:80 hichemlamine/fastapi:postgres

