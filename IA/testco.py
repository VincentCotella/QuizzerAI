
import vertexai
from vertexai.generative_models import GenerativeModel
from flask import Flask, request, jsonify
import os
import PyPDF2  # for extracting text from PDFs

# TODO(developer): Update and un-comment below line
project_id = "shining-energy-441715-q9"

vertexai.init(project=project_id, location="us-central1")

model = GenerativeModel(model_name="gemini-1.5-flash-002")

def extract_text_from_pdf(doc):
    """Extract text from a PDF file."""
    text = ""
    with open(doc, "rb") as file:
        pdf_reader = PyPDF2.PdfReader(file)
        for page in pdf_reader.pages:
            text += page.extract_text() if page.extract_text() else ""
    return text

def generate_qcm(theme=None, niveau=None, doc=None):
    """Generate QCM questions based on theme, niveau, or document."""

    # Handle the document input (if provided)
    document_text = ""
    if doc:
        if doc.endswith(".pdf"):
            document_text = extract_text_from_pdf(doc)
        else:
            document_text = doc  # if doc is plain text

    # Construct the prompt with the available parameters
    prompt = f"Generate 10 multiple-choice questions (QCM) with four options each."

    if theme:
        prompt += f" Theme: {theme}."
    if niveau:
        prompt += f" Difficulty level: {niveau}."
    if document_text:
        prompt += f" Document content: {document_text[:1000]}."  # Limit document text to 1000 chars to avoid prompt overload.

    # Generate content with Vertex AI model
    response = model.generate_content(prompt)

    # Parse and structure the response as JSON
    questions = parse_questions(response.text)  # Implement parse_questions to process the response text

    # Return questions in JSON format
    return jsonify({"questions": questions})

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




'''
# Initialiser Flask
app = Flask(__name__)

@app.route('/generate_qcm', methods=['POST'])

data = request.json
theme = data.get("theme", "niveau")

# Exécuter l'application Flask
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000) 

'''

