
import psycopg2
from contextlib import closing
from dotenv import load_dotenv
import os

load_dotenv()
DB_CONFIG = {
    "host": "localhost",
    "database": "theater_db",
    "user": "theater_user",
    "password": "theater_password",
    "port": "5432",
}


def connect_to_db():
    try:
        connection = psycopg2.connect(**DB_CONFIG)
        return connection
    except Exception as e:
        print(f"Ошибка подключения: ёпт{e}")
        return None

def get_performances():
    connection = connect_to_db()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT * FROM performances;")
            performances = cursor.fetchall()
            cursor.close()
            return performances
        except Exception as e:
            print(f"Ошибка запроса: {e}")
        finally:
            connection.close()
    return []

def get_performance_details(performance_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            SELECT title, year_of_premiere, director, description, rating, number_of_reviews, poster
            FROM performances
            WHERE performance_id = %s
            """,
            (performance_id,)
        )
        performance = cursor.fetchone()
    return performance

def get_performance_cast(performance_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            SELECT actors.name
            FROM castings
            RIGHT JOIN actors ON castings.actor_id = actors.actor_id
            WHERE castings.performance_id = %s
            """,
            (performance_id,)
        )
        cast = cursor.fetchall()
    return [actor[0] for actor in cast] 


def update_performance_rating(performance_id, old_average, count, new_rating):
    new_average = (old_average * count + new_rating) / (count + 1)
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            UPDATE performances
            SET rating = %s, number_of_reviews = %s
            WHERE performance_id = %s
            """,
            (new_average, count + 1, performance_id)
        )
        connection.commit()

def add_to_favorites(user_id, performance_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            INSERT INTO liked_performances (user_id, performance_id)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
            """,
            (user_id, performance_id)
        )
        connection.commit()

def get_user_rating(user_id, performance_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            SELECT rating
            FROM ratings
            WHERE user_id = %s AND performance_id = %s
            """,
            (user_id, performance_id)
        )
        result = cursor.fetchone()
    return result[0] if result else None

def update_user_rating(user_id, performance_id, rating):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            INSERT INTO ratings (user_id, performance_id, rating)
            VALUES (%s, %s, %s)
            ON CONFLICT (user_id, performance_id) DO UPDATE
            SET rating = EXCLUDED.rating
            """,
            (user_id, performance_id, rating)
        )
        connection.commit()

def delete_user_rating(user_id, performance_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            SELECT rating FROM ratings
            WHERE user_id = %s AND performance_id = %s
            """,
            (user_id, performance_id)
        )
        user_rating = cursor.fetchone()

        if user_rating:
            user_rating = user_rating[0] 
            
            cursor.execute(
                """
                DELETE FROM ratings
                WHERE user_id = %s AND performance_id = %s
                """,
                (user_id, performance_id)
            )

            cursor.execute(
                """
                SELECT rating, number_of_reviews
                FROM performances
                WHERE performance_id = %s
                """,
                (performance_id,)
            )
            performance_data = cursor.fetchone()

            if performance_data:
                old_average, count = performance_data
                if count > 1:
                    new_average = (old_average * count - user_rating) / (count - 1)
                    new_count = count - 1
                else:
                    new_average = 0
                    new_count = 0

                cursor.execute(
                    """
                    UPDATE performances
                    SET rating = %s, number_of_reviews = %s
                    WHERE performance_id = %s
                    """,
                    (new_average, new_count, performance_id)
                )

            connection.commit()
            return True  
        
        return False  # не нашли оценку

def remove_from_favorites(user_id, performance_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            DELETE FROM liked_performances
            WHERE user_id = %s AND performance_id = %s
            """,
            (user_id, performance_id)
        )
        connection.commit()

def is_favorite(user_id, performance_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            SELECT 1
            FROM liked_performances
            WHERE user_id = %s AND performance_id = %s
            """,
            (user_id, performance_id)
        )
        return cursor.fetchone() is not None

def get_favorite_performances(user_id):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(
            """
            SELECT p.performance_id, p.title, p.year_of_premiere, p.director, p.description, p.rating, p.number_of_reviews, p.poster
            FROM performances p
            JOIN liked_performances ON p.performance_id = liked_performances.performance_id
            WHERE liked_performances.user_id = %s
            """,
            (user_id,)
        )
        return cursor.fetchall()

def search_performances(query):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        
        cursor.execute(
            """
            SELECT * FROM performances
            WHERE title LIKE %s
            """,
            (f"%{query}%",)
        )
        return cursor.fetchall()


def get_actor_details(actor_name):
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute("SELECT name, biography FROM actors WHERE name = %s", (actor_name,))
        result = cursor.fetchone()
        if result:
            return {"name": result[0], "biography": result[1]}
        return None


def get_performance_genres(performance_id):
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT genre_name FROM genres
        JOIN performance_genres ON genres.genre_id = performance_genres.genre_id
        WHERE performance_genres.performance_id = %s
    """, (performance_id,))
    genres = cursor.fetchall()
    cursor.close()
    conn.close()
    return [genre[0] for genre in genres]

def get_age_category_for_performance(performance_id):
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT age_categories.age FROM age_categories
        JOIN age_categories_of_performances ON age_categories.age_id = age_categories_of_performances.age_id
        WHERE age_categories_of_performances.performance_id = %s
    """, (performance_id,))
    age_category = cursor.fetchone()
    cursor.close()
    conn.close()
    return age_category[0] if age_category else "Не указано"

def add_review(user_id, performance_id, review_text):
    query = """
    INSERT INTO reviews (performance_id, user_id, review_text, date_of_writing)
    VALUES (%s, %s, %s, CURRENT_TIMESTAMP)
    """
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(query, (performance_id, user_id, review_text))
        connection.commit()

def get_reviews(performance_id):
    query = """
    SELECT user_id, review_text, date_of_writing
    FROM reviews
    WHERE performance_id = %s
    ORDER BY date_of_writing DESC
    """
    
    connection = connect_to_db()
    if connection:
        cursor = connection.cursor()
        cursor.execute(query, (performance_id,))
        result = cursor.fetchall()
        
        reviews = []
        for row in result:
            review = {
                "user_id": row[0],
                "review_text": row[1],
                "date_of_writing": row[2]
            }
            reviews.append(review)
        
        cursor.close()
        connection.close()
        return reviews
    return []

def get_user_name(user_id):
    query = """
    SELECT email FROM users WHERE user_id = %s
    """
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(query, (user_id,))
        result = cursor.fetchone()  
    return result[0] if result else "Неизвестный пользователь"

def get_performance_title(performance_id):
    query = """
    SELECT title FROM performances WHERE performance_id = %s
    """
    with closing(connect_to_db()) as connection:
        cursor = connection.cursor()
        cursor.execute(query, (performance_id,))
        result = cursor.fetchone()
    return result[0] if result else None
