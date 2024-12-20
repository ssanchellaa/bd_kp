# запустить 1 раз

import bcrypt
import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

ADMIN_EMAIL = os.getenv("ADMIN_EMAIL")
ADMIN_PASSWORD = os.getenv("ADMIN_PASSWORD")
ADMIN_ROLE = os.getenv("ADMIN_ROLE")

DB_CONFIG = {
    "host": "localhost",
    "database": "postgre",
    "user": "postgre",
    "password": "postgre",
    "port": "5432",
}

def connect_to_db():
    try:
        connection = psycopg2.connect(**DB_CONFIG)
        return connection
    except Exception as e:
        print(f"Ошибка подключения: {e}")
        return None

def initialize_admin():
    connection = connect_to_db()
    if not connection:
        return

    try:
        cursor = connection.cursor()
        cursor.execute("SELECT COUNT(*) FROM users WHERE email = %s", (ADMIN_EMAIL,))
        count = cursor.fetchone()[0]
        if count > 0:
            print("Администратор уже существует в базе данных.")
        else:
            hashed_password = bcrypt.hashpw(ADMIN_PASSWORD.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
            cursor.execute(
                "INSERT INTO users (email, password_hash, role) VALUES (%s, %s, %s)",
                (ADMIN_EMAIL, hashed_password, ADMIN_ROLE)
            )
            connection.commit()
            print("Администратор успешно добавлен.")
        cursor.close()
    except Exception as e:
        print(f"Ошибка добавления администратора: {e}")
    finally:
        connection.close()

if __name__ == "__main__":
    initialize_admin()
