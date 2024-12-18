from flask import Flask, request, jsonify
from init_questions import generer_questions
app = Flask(__name__)

@app.route('/generer', methods=['POST'])


def generer():
    """
    Endpoint pour générer des questions.

    Attend un JSON avec les clés 'theme' et 'niveau_difficulte'.
    """
    try:
        # Récupérer les données JSON de la requête
        data = request.get_json()

        # Extraire le thème et le niveau de difficulté
        theme = data.get('theme')
        niveau_difficulte = data.get('niveau_difficulte')
        nbquestion = data.get('nbquestion')

        # Vérifier que les paramètres sont présents
        if not theme or not niveau_difficulte:
            return jsonify({'error': 'Les paramètres "theme" et "niveau_difficulte" sont requis.'}), 400

        # Appeler la fonction logique pour générer les questions
        questions = generer_questions(theme, niveau_difficulte, nbquestion)

        # Retourner les résultats sous forme de JSON
        return jsonify({'questions': questions}), 200

    except Exception as e:
        # Gérer les erreurs
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=8080)
