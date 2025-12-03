from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
import os

app = Flask(__name__)
CORS(app)

# Database connection
def get_db_connection():
    conn = psycopg2.connect(
        host=os.getenv('DB_HOST', 'notes-db'),
        database=os.getenv('DB_NAME', 'notesdb'),
        user=os.getenv('DB_USER', 'notesuser'),
        password=os.getenv('DB_PASSWORD', 'notespass')
    )
    return conn

# Initialize database
def init_db():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS notes (
                id SERIAL PRIMARY KEY,
                content TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Database initialization error: {e}")

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

@app.route('/notes', methods=['GET'])
def get_notes():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT id, content, created_at FROM notes ORDER BY created_at DESC')
    notes = cur.fetchall()
    cur.close()
    conn.close()
    
    return jsonify([
        {"id": note[0], "content": note[1], "created_at": str(note[2])}
        for note in notes
    ])

@app.route('/add', methods=['POST'])
def add_note():
    content = request.json.get('content')
    if not content:
        return jsonify({"error": "Content is required"}), 400
    
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('INSERT INTO notes (content) VALUES (%s) RETURNING id', (content,))
    note_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    
    return jsonify({"id": note_id, "content": content}), 201

@app.route('/delete/<int:note_id>', methods=['DELETE'])
def delete_note(note_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('DELETE FROM notes WHERE id = %s', (note_id,))
    conn.commit()
    cur.close()
    conn.close()
    
    return jsonify({"message": "Note deleted"}), 200

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
