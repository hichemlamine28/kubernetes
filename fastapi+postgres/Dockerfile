# Utilisation de l'image de base python pour l'application
FROM python:3.9

# Copier les fichiers requis dans le conteneur
WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Copier le reste des fichiers de l'application
COPY ./app /code/app
COPY ./app/static /code/static

ENV RUNNING_IN_DOCKER=true
# Commande pour lancer l'application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
# CMD ["sh", "-c", "sleep 300 && uvicorn app.main:app --host 0.0.0.0 --port 80"]