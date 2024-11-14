
from google.cloud import aiplatform
from dotenv import load_dotenv
import os
import json 
from google.oauth2 import service_account
import vertexai
from vertexai.preview.language_models import TextGenerationModel
from vertexai.generative_models import GenerativeModel


# Charger les variables d'environnement du fichier .env
load_dotenv()

# Charger la clé JSON depuis la variable d'environnement
credentials_json = os.getenv("GOOGLE_APPLICATION_CREDENTIALS_JSON")

# Convertir la chaîne JSON en dictionnaire Python
credentials_info = json.loads(credentials_json)

# Initialiser les informations d'identification
credentials = service_account.Credentials.from_service_account_info(credentials_info)

# Initialiser Vertex AI avec les informations d'identification
project_id = "shining-energy-441715-q9"
vertexai.init(project=project_id, location="us-central1", credentials=credentials)

                                    
PROJECT_ID = "shining-energy-441715-q9"
REGION = "us-central1"

vertexai.init(
    project = PROJECT_ID,
    location= REGION,
    credentials = credentials
)


model = GenerativeModel(model_name="gemini-1.5-flash-002")

import json

def generer_questions(theme: str, niveau_difficulte: str, nbquestion : int):
    """
    Génère des questions QCM basées sur un thème et un niveau de difficulté.

    Paramètres:
    - theme (str): Le thème des questions.
    - niveau_difficulte (str): Le niveau de difficulté des questions.

    Retourne:
    - dict: Les questions générées sous forme de JSON structuré.
    """
    # Simplifier le prompt pour réduire la complexité
    prompt = f"""Génère '{nbquestion}' questions de type QCM sur le thème '{theme}' avec un niveau de difficulté '{niveau_difficulte}'.
    Chaque question doit comporter quatre options de réponses et une seule réponse correcte.
    Renvoie les questions sous forme d'un fichier JSON où chaque élément est structuré comme suit :
    - "question" : la question posée
    - "answers" : un tableau de quatre options de réponse
    - "correct" : l'indice (0 à 3) de la réponse correcte.
    """
    
    # Appeler le modèle pour générer le contenu
    response = model.generate_content(prompt)
    
    # Nettoyer et convertir la réponse en JSON
    questions = parse_questions(response.text)
    
    return questions

def parse_questions(response_text):
    """
    Parse le texte de la réponse pour extraire les questions et options en format JSON.

    Paramètres:
    - response_text (str): Le texte brut de la réponse du modèle.

    Retourne:
    - list: Une liste de questions structurées en JSON.
    """
    # Supprimer les caractères superflus potentiels et charger en JSON
    clean_response = response_text.strip("```json\n").strip("\n```")
    
    try:
        questions_json = json.loads(clean_response)
    except json.JSONDecodeError as e:
        print("Erreur de décodage JSON:", e)
        return []
    
    return questions_json




