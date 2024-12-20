import psycopg2
import streamlit as st
import os
from connection import connect_to_db

def check_folder():
    # проверка, существует ли папка ./assets/images
    image_folder = './assets/images'
    if not os.path.exists(image_folder):
        os.makedirs(image_folder)
    

def add_new_play(title, year_of_release, director, description, star_rating, number_of_ratings, pname, age_category, genres, actor_input):
    conn = connect_to_db()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO plays (title, year_of_release, director, description, star_rating, number_of_ratings, poster)
            VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING play_id
        """, (title, year_of_release, director, description, star_rating, number_of_ratings, pname))
        play_id = cursor.fetchone()[0]

        cursor.execute("""
            SELECT age_id FROM age_categories WHERE age = %s
        """, (age_category,))
        age_id = cursor.fetchone()[0]

        cursor.execute("""
            INSERT INTO ages_of_plays (play_id, age_id) VALUES (%s, %s)
        """, (play_id, age_id))

        for genre in genres:
            cursor.execute("""
                SELECT genre_id FROM genres WHERE genre_name = %s
            """, (genre,))
            genre_id = cursor.fetchone()[0]
            cursor.execute("""
                INSERT INTO play_genres (play_id, genre_id) VALUES (%s, %s)
            """, (play_id, genre_id))
        
        if actor_input:
            actors_with_bios = actor_input.split("$") 
            for actor_info in actors_with_bios:
                try:
                    actor_name, biography = actor_info.split(":", 1)  
                except ValueError:
                    st.error(f"Ошибка в формате ввода актера: '{actor_info}'")
                    continue

                actor_name = actor_name.strip()
                biography = biography.strip()

                # существует ли актер в бд
                cursor.execute("""
                    SELECT actor_id FROM actors WHERE name = %s
                """, (actor_name,))
                actor_result = cursor.fetchone()

                if actor_result:
                    actor_id = actor_result[0]
                    cursor.execute("""
                        UPDATE actors SET biography = %s WHERE actor_id = %s
                    """, (biography, actor_id))
                else:
                    cursor.execute("""
                        INSERT INTO actors (name, biography) 
                        VALUES (%s, %s)
                    """, (actor_name, biography))

                cursor.execute("""
                    SELECT actor_id FROM actors WHERE name = %s
                """, (actor_name,))
                actor_id = cursor.fetchone()[0]

                cursor.execute("""
                    INSERT INTO filmography_of_actors (actor_id, play_id) VALUES (%s, %s)
                """, (actor_id, play_id))
        
        conn.commit()
        st.success("Театральная постановка успешно добавлена!")
    except Exception as e:
        conn.rollback()
        st.error(f"Ошибка добавления театральной постановки: {e}")
    finally:
        cursor.close()
        conn.close()



def get_plays_by_title(search_query):
    conn = connect_to_db()
    if conn:
        try:
            cursor = conn.cursor()
            if search_query:
                cursor.execute("SELECT play_id, title FROM plays WHERE title ILIKE %s", (f"%{search_query}%",))
            else:
                cursor.execute("SELECT play_id, title FROM plays")
            plays = cursor.fetchall()
            cursor.close()
            return plays
        except Exception as e:
            st.error(f"Ошибка загрузки постановок: {e}")
            return
        finally:
            conn.close()
    return []


def delete_one_play(play_id):
    conn = connect_to_db()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM plays WHERE play_id = %s", (play_id,))
        conn.commit()
        st.success("Театральная постановка успешно удалена!")
        st.rerun()
    except Exception as e:
        conn.rollback()
        st.error(f"Ошибка удаления театральной постановки: {e}")
    finally:
        cursor.close()
        conn.close()

def view_logs():
    conn = connect_to_db()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM play_logs ORDER BY action_time DESC")
            logs = cursor.fetchall()
            st.subheader("Логи изменений театральных постановок")
            for log in logs:
                st.write(f"ID Лога: {log[0]}, Действие: {log[1]}, ID Постановки: {log[2]}, Время: {log[3]}")
            cursor.close()
        except Exception as e:
            st.error(f"Ошибка загрузки логов: {e}")
        finally:
            conn.close()

