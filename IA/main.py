from testco import generate_qcm
from testco import parse_questions

# Bloc principal pour tester la fonction
if __name__ == "__main__":
    # Test de la fonction generate_qcm avec un thème et un niveau
    qcm_json = generate_qcm(theme="Data Science", niveau="Beginner")

    # Afficher le résultat pour vérification
    print(qcm_json.get_data(as_text=True))