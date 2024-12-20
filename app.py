import streamlit as st
from utils.auth import authenticate_user, register_user
from utils.admin import admin_page
from connection import get_plays, get_play_details, get_play_cast, update_play_rating, add_to_favorites, get_favorite_plays
from connection import get_user_stars, update_user_stars, delete_user_stars, remove_from_favorites, is_favorite, search_plays
from connection import get_actor_details, get_play_genres, get_age_category_for_play, add_review, get_reviews, get_user_name
from connection import get_play_title
from contextlib import closing

if "user" not in st.session_state:
    st.session_state["user"] = None
    st.session_state["role"] = None

if "auth_page" not in st.session_state:
    st.session_state["auth_page"] = "Авторизация"

if not st.session_state["user"]:
    selected_page = st.session_state["auth_page"]
else:
    menu = ["Пьесы", "Ваш профиль", "Избранные пьесы"]
    if st.session_state["role"] == "admin":
        menu.append("Страница администратора")
    selected_page = st.sidebar.selectbox("Меню", menu)

def login_page():
    st.title("Авторизация")
    email = st.text_input("Никнейм")
    password = st.text_input("Пароль", type="password")
    if st.button("Войти"):
        user_data = authenticate_user(email, password)
        if user_data:
            st.session_state["user_id"] = user_data["user_id"]
            st.session_state["user"] = email
            st.session_state["role"] = user_data["role"]
            st.success("Успешная авторизация!")
            st.session_state["auth_page"] = None  # устанавливаем в None, пользователь авторизован
            st.rerun() 
        else:
            st.error("Неверные данные.")
    if st.button("Регистрация"):
        st.session_state["auth_page"] = "Регистрация"
        st.rerun() 

def register_page():
    st.title("Регистрация")
    email = st.text_input("Никнейм")
    password = st.text_input("Пароль", type="password")
    if st.button("Зарегистрироваться"):
        if register_user(email, password):
            st.success("Регистрация успешна!")
            st.session_state["auth_page"] = "Авторизация" 
            st.rerun() 
        else:
            st.error("Ошибка регистрации.")
    if st.button("Назад к авторизации"):
        st.session_state["auth_page"] = "Авторизация"
        st.rerun() 

def plays_page():
    if "user_id" not in st.session_state:
        st.error("Пожалуйста, войдите, чтобы пользоваться этим функционалом.")
        return
    
    if "selected_play" not in st.session_state:
        st.session_state["selected_play"] = None

    user_id = st.session_state["user_id"] 

    # Если выбран актер, показываем страницу актера
    if "selected_actor" in st.session_state and st.session_state["selected_actor"]:
        actor_page() 
        st.rerun()
    
    if "show_reviews" in st.session_state and st.session_state["show_reviews"]:
        reviews_page()
        st.rerun()

    if st.session_state["selected_play"] is None:
        search_query = st.text_input("Поиск по пьесам", "")
        if search_query:
            search_results = search_plays(search_query)
            if search_results:
                st.title(f"Результаты поиска: {search_query}")
                cols = st.columns(4)

                for index, play in enumerate(search_results):
                    with cols[index % 4]:
                        st.image(f"assets/images/{play[7]}", use_container_width=True)
                        if st.button(play[1], key=f"play_button_{play[0]}"):
                            st.session_state["selected_play"] = play[0]
                            st.rerun()
            else:
                st.write("Ничего не найдено.")

        else:
            st.title("Пьесы")
            plays = get_plays()
            cols = st.columns(4) 

            for index, play in enumerate(plays):
                with cols[index % 4]: 
                    st.image(f"assets/images/{play[7]}", use_container_width=True)
                    if st.button(play[1], key=f"play_button_{play[0]}"): 
                        st.session_state["selected_play"] = play[0]
                        st.rerun() 
    else:
        play_id = st.session_state["selected_play"]
        play = get_play_details(play_id)
        cast = get_play_cast(play_id) 
        user_rating = get_user_stars(user_id, play_id)

        if play:
            col1, spacer, col2, col3 = st.columns([1, 0.2, 2, 1])

            with col1:
                st.image(f"assets/images/{play[6]}", use_container_width=True)

            with col2:
                st.title(play[0])
                st.write(f"**Год выпуска:** {play[1]}")
                st.write(f"**Режиссер:** {play[2]}")
                st.write("**Жанры:**")
                genres = get_play_genres(play_id)
                st.write(", ".join(genres))
                st.write(f"**Возрастная категория:** {get_age_category_for_play(play_id)}")
                st.write("**Актеры:**")
                if cast:
                    for actor in cast:
                        if st.button(actor, key=f"actor_button_{

