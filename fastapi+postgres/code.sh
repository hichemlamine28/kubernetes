#!/bin/bash

pip install fastapi uvicorn sqlalchemy psycopg2-binary




# After code is OK tape this command:
uvicorn main:app --reload