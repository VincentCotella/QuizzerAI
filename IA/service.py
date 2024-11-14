
from google.cloud import aiplatform

import os
from google.oauth2 import service_account
import vertexai
from vertexai.preview.language_models import TextGenerationModel
from vertexai.generative_models import GenerativeModel

credentials = service_account.Credentials.from_service_account_file(
    r'C:\Users\romai\Documents\ESILV A5\QuizzerAI\IA\projet1-441715-f679d4bf8316.json'
)
PROJECT_ID = "projet1-441715"
REGION = "us-central1"

vertexai.init(
    project = PROJECT_ID,
    location= REGION,
    credentials = credentials
)


model = GenerativeModel(model_name="gemini-1.5-flash-002")

def generer_questions(theme: str, niveau_difficulte: str) -> str:
    """
    Génère des questions basées sur un thème et un niveau de difficulté.

    Paramètres:
    - theme (str): Le thème des questions.
    - niveau_difficulte (str): Le niveau de difficulté des questions.

    Retourne:
    - str: Les questions générées.

    
    """
    # Création du prompt en intégrant le thème et le niveau de difficulté
    prompt = f"Créez cinq questions de niveau {niveau_difficulte} sur le thème suivant : {theme}. Fournissez également les réponses à ces questions."

    # Génération du texte
    response = model.generate_content(
        prompt,
        #temperature=0.7,
        #max_output_tokens=512,
        #top_p=0.8,
        #top_k=40
    )

    # Retourne le texte généré
    return response.text

def test_generation():
    response = model.generate_content(
        "comment vas-tu"
    )
    print(f"Réponse : {response.text}")

test_generation()

