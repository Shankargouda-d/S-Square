from flask import Flask, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# PostgreSQL connection config
DB_HOST = 'localhost'
DB_PORT = 5432
DB_NAME = 'kannada_db'
DB_USER = 'postgres'
DB_PASS = "postgres"

def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )
    return conn

# Get all words
@app.route('/words', methods=['GET'])
def get_words():
    conn = get_db_connection()
    with conn.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute("SELECT * FROM kannada_words;")
        words = cursor.fetchall()
    conn.close()
    return jsonify(words)

# Get word by ID
@app.route('/word/<int:word_id>', methods=['GET'])
def get_word(word_id):
    conn = get_db_connection()
    with conn.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute("SELECT * FROM kannada_words WHERE id = %s;", (word_id,))
        word = cursor.fetchone()
    conn.close()
    if word:
        return jsonify(word)
    else:
        return jsonify({"error": "Word not found"}), 404

# Search word by name
@app.route('/word/search', methods=['POST'])
def search_word():
    data = request.get_json()
    word_name = data.get('word')
    conn = get_db_connection()
    with conn.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute("SELECT * FROM kannada_words WHERE word = %s;", (word_name,))
        word = cursor.fetchone()
    conn.close()
    if word:
        return jsonify(word)
    else:
        return jsonify({"error": "Word not found"}), 404

# Add new word
@app.route('/word', methods=['POST'])
def add_word():
    data = request.get_json()
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute(
            """INSERT INTO kannada_words 
            (word, gender, vibhakti1, vibhakti2, vibhakti3, vibhakti4, 
             vibhakti5, vibhakti6, vibhakti7, vibhakti8) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id;""",
            (data['word'], data['gender'], data['vibhakti1'], data['vibhakti2'],
             data['vibhakti3'], data['vibhakti4'], data['vibhakti5'], 
             data['vibhakti6'], data['vibhakti7'], data['vibhakti8'])
        )
        conn.commit()
        new_id = cursor.fetchone()[0]
    conn.close()
    return jsonify({"id": new_id, "message": "Word added successfully"}), 201

# Update word
@app.route('/word/<int:word_id>', methods=['PUT'])
def update_word(word_id):
    data = request.get_json()
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute(
            """UPDATE kannada_words SET 
            word=%s, gender=%s, vibhakti1=%s, vibhakti2=%s, vibhakti3=%s, 
            vibhakti4=%s, vibhakti5=%s, vibhakti6=%s, vibhakti7=%s, vibhakti8=%s 
            WHERE id=%s;""",
            (data['word'], data['gender'], data['vibhakti1'], data['vibhakti2'],
             data['vibhakti3'], data['vibhakti4'], data['vibhakti5'], 
             data['vibhakti6'], data['vibhakti7'], data['vibhakti8'], word_id)
        )
        conn.commit()
    conn.close()
    return jsonify({"message": "Word updated successfully"})

# Delete word
@app.route('/word/<int:word_id>', methods=['DELETE'])
def delete_word(word_id):
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("DELETE FROM kannada_words WHERE id = %s;", (word_id,))
        conn.commit()
    conn.close()
    return jsonify({"message": "Word deleted successfully"})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
