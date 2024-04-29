from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import os

# URL_DATABASE = 'postgresql://postgres:postgres@localhost:5432/quiz'
# URL_DATABASE = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/quiz')
# URL_DATABASE = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@postgres-svc:5432/quiz')
URL_DATABASE = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@postgres-svc.default.svc.cluster.local:5432/quiz')

# URL_DATABASE = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@postgres-svc.default.svc.kubernetes.local:5432/quiz')


engine = create_engine(URL_DATABASE)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


