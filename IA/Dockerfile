# Utiliser une image de base Python légère
FROM python:3.9-slim

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier et installer les dépendances
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copier tout le code source dans le conteneur
COPY . .

# Exposer le port sur lequel Flask sera accessible
EXPOSE 8080

# Commande pour lancer Flask
CMD ["python", "flaskk.py"]
