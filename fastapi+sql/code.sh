#!/bin/bash

pip install fastapi uvicorn sqlalchemy pymysql 





# After code is OK tape this command:
uvicorn main:app --reload