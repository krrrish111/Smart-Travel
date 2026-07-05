import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv('C:/Users/Dell/Desktop/antigravity/.env')

host = os.getenv('DB_HOST')
port = int(os.getenv('DB_PORT', 3306))
db_name = os.getenv('DB_NAME')
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')

print(f"Connecting to {host}:{port} database {db_name}")

conn = mysql.connector.connect(
    host=host,
    port=port,
    user=db_user,
    password=db_password,
    database=db_name
)

cursor = conn.cursor()

try:
    cursor.execute("ALTER TABLE posts ADD COLUMN rating INT DEFAULT NULL")
    conn.commit()
    print("Migration successful: rating column added.")
except Exception as e:
    print("Error or already added:", e)

try:
    cursor.execute("SHOW CREATE TABLE posts")
    res = cursor.fetchone()
    print(res[1])
except Exception as e:
    print("Error showing table:", e)

cursor.close()
conn.close()
