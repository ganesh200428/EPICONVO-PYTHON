import os
from flask import Flask, request, jsonify, render_template
import cohere
import mysql.connector
from flask_cors import CORS
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS

# Cohere API Setup
COHERE_API_KEY = os.getenv("COHERE_API_KEY")
co = cohere.Client(COHERE_API_KEY)

# MySQL Database Connection
db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME")
)
cursor = db.cursor()

# Route to Serve HTML
@app.route("/")
def index():
    return render_template("index.html")

# Chatbot API Endpoint
@app.route("/chat", methods=["POST"])
def chat():
    data = request.json
    user_message = data.get("message")

    if not user_message:
        return jsonify({"error": "Message cannot be empty."}), 400

    try:
        # Store user message in MySQL
        cursor.execute("INSERT INTO chat_history (user_message) VALUES (%s)", (user_message,))
        db.commit()

        # Send message to Cohere API
        response = co.generate(
            model='command-xlarge',  
            prompt=user_message,
            max_tokens=100,
            temperature=0.7
        )
        ai_response = response.generations[0].text.strip()

        # Store AI response in MySQL
        cursor.execute("UPDATE chat_history SET ai_response = %s WHERE user_message = %s", (ai_response, user_message))
        db.commit()

        return jsonify({"response": ai_response})

    except mysql.connector.Error as db_error:
        db.rollback()
        return jsonify({"error": f"Database error: {str(db_error)}"}), 500

    except Exception as e:
        return jsonify({"error": f"Error: {str(e)}"}), 500

# Run Flask App
if __name__ == "__main__":
    app.run(debug=True)
