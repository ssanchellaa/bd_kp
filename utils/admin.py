import streamlit as st
import subprocess
import os
from dotenv import load_dotenv
from utils.helpers import check_folder, add_new_performance, view_logs
from utils.helpers import get_performances_by_title, delete_one_performance

load_dotenv()

def admin_page():
    st.title("**Панель администратора**")

    if st.checkbox("Показать логи изменений постановок"):
        view_logs()
    
    st.subheader("Резервное копирование")
    backup_file = st.text_input("Укажите путь для сохранения резервной копии", "backup.sql")
    if st.button("Создать резервную копию"):
        result = backup_database(backup_file)
        st.info(result)

    st.subheader("Восстановление базы данных")
    restore_file = st.text_input("Укажите путь к файлу резервной копии для восстановления", "backup.sql")
    if st.button("Восстановить базу данных"):
        result = restore_database(restore_file)
        st.info(result)

    action = st.radio("Выберите действие", ["Добавить постановку", "Удалить постановку"], horizontal=True)
    
    if action == "Добавить постановку":
        add_performance()
    elif action == "Удалить постановку":
        delete_performance()


def backup_database(output_file):
    try:
        result = subprocess.run(
            [
                "pg_dump",
                "-U", os.getenv("DB_USER"),
                "-h", os.getenv("DB_HOST"),  
                "-d", os.getenv("DB_NAME"), 
                "-F", "c", 
                "-b",  
                "-v",  
                "-f", output_file  
            ],
            env={"PGPASSWORD": os.getenv("DB_PASSWORD")}, 
            check=True,
            text=True,
            capture_output=True
        )
        return f"Резервная копия успешно создана. {result.stdout}"
    except subprocess.CalledProcessError as e:
        return f"Ошибка создания резервной копии: {e.stderr}"

def add_performance():
    st.subheader("Добавить постановку")
    title = st.text_input("Название постановки")
    year_of_premiere = st.number_input("Год премьеры", min_value=1600, max_value=2050, step=1)
    director = st.text_input("Режиссер")
    description = st.text_area("Описание постановки")
    star_rating = st.number_input("Рейтинг постановки", min_value=0.0, max_value=10.0, step=0.1)
    number_of_ratings = st.number_input("Количество оценок", min_value=0, max_value=1000000000, step=1)
    poster = st.file_uploader("Загрузите постер постановки", type=["jpg"])

    age_category = st.selectbox("Возрастная категория", ["6-11", "12-15", "16-17", "18+"])
    genres = st.multiselect("Выберите жанры", ["Драма", "Мюзикл", "Комедия", "Фэнтези", "Романтика", "Триллер"])

    actor_input = st.text_area("Введите актеров с их характеристиками (например, 'Актер 1: характеристика $ Актер 2: характеристика')")

    if st.button("Добавить постановку"):
        if title and year_of_premiere and director and description and poster and star_rating and number_of_ratings:
            check_folder()

            poster_path = os.path.join('./assets/images', poster.name)
            with open(poster_path, "wb") as f:
                f.write(poster.read())
            
            # добавление постановки в базу данных
            add_new_performance(title, year_of_premiere, director, description, star_rating, number_of_ratings, poster.name, age_category, genres, actor_input)
        else:
            st.error("Пожалуйста, заполните все поля и загрузите постер.")

def delete_performance():
    st.subheader("Удалить постановку")

    search_query = st.text_input("Введите название постановки для поиска")

    performances = get_performances_by_title(search_query)

    if not performances:
        st.info("Нет постановок, соответствующих запросу.")
        return

    performance_options = {f"{performance[1]} (ID: {performance[0]})": performance[0] for performance in performances}
    selected_performance = st.selectbox("Выберите постановку для удаления", list(performance_options.keys()))

    if st.button("Удалить постановку"):
        if selected_performance:
            performance_id = performance_options[selected_performance]
            delete_one_performance(performance_id)
        else:
            st.info("Выберите постановку.")


def restore_database(input_file):
    try:
        result = subprocess.run(
            [
                "pg_restore",
                "-U", os.getenv("DB_USER"), 
                "-h", os.getenv("DB_HOST"), 
                "-d", os.getenv("DB_NAME"), 
                "-c",  
                "-v", 
                input_file  
            ],
            env={"PGPASSWORD": os.getenv("DB_PASSWORD")},  
            check=True,
            text=True,
            capture_output=True
        )
        if "error" not in result.stderr.lower(): 
            return f"Восстановление успешно завершено."
        else:
            return f"Восстановление выполнено с предупреждениями: {result.stderr}"
    except subprocess.CalledProcessError as e:
        return f"Ошибка восстановления базы данных: {e.stderr}"

