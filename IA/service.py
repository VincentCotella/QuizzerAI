##service python 

##jfgt
## génère les questions, prend en entré soit thème soit documents
# prompt, appel à gemini et génère 10 questions à mettre dans un JSON
## préciser la langue dans le prompt

import vertexai
from vertexai.generative_models import GenerativeModel
from flask import Flask, request, jsonify
import os

# Remplacez "PROJECT_ID" par votre identifiant de projet Google Cloud.
project_id = "PROJECT_ID"
vertexai.init(project=project_id, location="us-central1")

# Initialiser le modèle GenerativeModel avec le modèle Gemini-1.5-flash-002.
model = GenerativeModel(model_name="gemini-1.5-flash-002")

# Initialiser Flask
app = Flask(__name__)

@app.route('/generate_qcm', methods=['POST'])
def generate_qcm():
    # Extraire le thème ou document depuis la requête POST
    data = request.json
    theme = data.get("theme", "")
    
    # Gérer le cas où le thème n'est pas fourni
    if not theme:
        return jsonify({"error": "Theme is required"}), 400
    
    # Générer le contenu avec le modèle Vertex AI
    prompt = f"Si tu as en entrée un thème et un niveau (en français), explore le thème en fonction du niveau et génère 10 questions type QCM 
     qui ont toutes 4 options de réponses. Si tu as un document en entrée explore le et combine des connaissances qui correspondet au niveau du document
     et génère 10 questions type QCM qui ont toutes 4 options de réponses. {theme}."
    response = model.generate_content(prompt)
    
    # Récupérer et structurer la réponse en JSON
    # Supposons que la réponse contienne un format de type liste de questions et options.
    questions = parse_questions(response.text)  # Fonction pour formater la réponse
    
    # Renvoyer les questions en JSON
    return jsonify({"questions": questions})

def parse_questions(response_text):
    # Ici, vous pouvez ajouter une logique pour analyser la sortie texte du modèle
    # et organiser les questions dans une structure JSON.
    # Exemple de format final attendu pour chaque question:
    # {"question": "Question text", "options": ["Option 1", "Option 2", "Option 3", "Option 4"], "correct_answer": "Option 1"}
    questions = []
    
    # Exemple de parsing simple (à adapter selon la sortie réelle du modèle)
    for line in response_text.split("\n"):
        if line.strip():
            question = {"question": line.strip(), "options": ["Option A", "Option B", "Option C", "Option D"]}
            questions.append(question)
    
    return questions

# Exécuter l'application Flask
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
