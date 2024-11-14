
from google.cloud import aiplatform

import os
from google.oauth2 import service_account
import vertexai
from vertexai.preview.language_models import TextGenerationModel
from vertexai.generative_models import GenerativeModel

credentials = service_account.Credentials.from_service_account_file(r'C:\Users\lilyj\OneDrive - De Vinci\ESILV\A5 DIA\QuizzerAI\shining-energy-441715-q9-336c29f05a5a.json')
PROJECT_ID = "shining-energy-441715-q9"
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
    prompt = f"Créez dix questions de niveau {niveau_difficulte} sur le thème suivant : {theme}. Les questions doivent être de type qcm avec chacune 4 options de réponses dont une réponse juste."

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

def parse_questions(response_text):
    """Parse response text to extract questions and options in JSON format."""
    # This example assumes each question and its options are separated by newlines or another delimiter.
    # Adjust parsing based on the actual format returned by the model.
    questions = []
    
    # Example simple parsing, adjust based on actual response formatting
    for line in response_text.split("\n"):
        if line.strip():  # Skip empty lines
            question_data = {"question": line.strip(), "options": ["Option A", "Option B", "Option C", "Option D"]}
            questions.append(question_data)

    return questions



