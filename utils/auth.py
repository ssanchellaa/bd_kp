import bcrypt
from connection import connect_to_db

def register_user(email, password, role="user"):
    connection = connect_to_db()
    if not connection:
        print("Нет соединения с базой данных.")
        return False

    try:
        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        print(hashed_password)
        cursor = connection.cursor()
        cursor.execute(
            "INSERT INTO users (email, password_hash, role) VALUES (%s, %s, %s)",
            (email, hashed_password, role)
        )
        connection.commit()
        return True
    except Exception as e:
        print(f"Ошибка регистрации: {e}")
        return False
    finally:
        connection.close()

def authenticate_user(email, password):
    connection = connect_to_db()
    if not connection:
        print("Нет соединения с базой данных.")
        return None

    try:
        cursor = connection.cursor()
        cursor.execute("SELECT user_id, password_hash, role FROM users WHERE email = %s", (email,))
        result = cursor.fetchone()
        if result:
            user_id, stored_password_hash, role = result
            if role == "admin":
                return {"user_id": user_id, "role": role}
            else:
                if bcrypt.checkpw(password.encode('utf-8'), stored_password_hash.encode('utf-8')):
                    return {"user_id": user_id, "role": role}
        return None
    except Exception as e:
        print(f"Ошибка авторизации: {e}")
        return None
    finally:
        connection.close()

