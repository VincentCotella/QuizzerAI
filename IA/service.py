##service python 

##jfgt
## génère les questions, prend en entré soit thème soit documents
# prompt, appel à gemini et génère 10 questions à mettre dans un JSON
## préciser la langue dans le prompte

import vertexai
from vertexai.generative_models import GenerativeModel

# TODO(developer): Update and un-comment below line
# project_id = "PROJECT_ID"

vertexai.init(project=project_id, location="us-central1")

model = GenerativeModel(model_name="gemini-1.5-flash-001")

response = model.generate_content(
    "What's a good name for a flower shop that specializes in selling bouquets of dried flowers?"
)

print(response.text)

