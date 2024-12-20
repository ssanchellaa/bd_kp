PGDMP      6                |            postgres    17.0 (Debian 17.0-1.pgdg120+1)     17.2 (Ubuntu 17.2-1.pgdg20.04+1) :    t           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            u           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            v           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            w           1262    5    postgres    DATABASE     s   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE postgres;
                     postgres    false            x           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                        postgres    false    3447            �            1259    33477    actors    TABLE     s   CREATE TABLE public.actors (
    actor_id integer NOT NULL,
    name character varying(255),
    biography text
);
    DROP TABLE public.actors;
       public         heap r       cat    false            �            1259    33482    actors_actor_id_seq    SEQUENCE     �   CREATE SEQUENCE public.actors_actor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.actors_actor_id_seq;
       public               cat    false    217            y           0    0    actors_actor_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.actors_actor_id_seq OWNED BY public.actors.actor_id;
          public               cat    false    218            �            1259    33483    age_categorys    TABLE     �   CREATE TABLE public.age_categorys (
    age_id integer NOT NULL,
    age character varying(50),
    characteristic_of_category text
);
 !   DROP TABLE public.age_categorys;
       public         heap r       cat    false            �            1259    33488    age_categorys_age_id_seq    SEQUENCE     �   CREATE SEQUENCE public.age_categorys_age_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.age_categorys_age_id_seq;
       public               cat    false    219            z           0    0    age_categorys_age_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.age_categorys_age_id_seq OWNED BY public.age_categorys.age_id;
          public               cat    false    220            �            1259    33489    ages_of_films    TABLE     b   CREATE TABLE public.ages_of_films (
    movie_id integer NOT NULL,
    age_id integer NOT NULL
);
 !   DROP TABLE public.ages_of_films;
       public         heap r       cat    false            �            1259    33492    filmography_of_actors    TABLE     l   CREATE TABLE public.filmography_of_actors (
    actor_id integer NOT NULL,
    movie_id integer NOT NULL
);
 )   DROP TABLE public.filmography_of_actors;
       public         heap r       cat    false            �            1259    33495    genres    TABLE     e   CREATE TABLE public.genres (
    genre_id integer NOT NULL,
    genre_name character varying(255)
);
    DROP TABLE public.genres;
       public         heap r       cat    false            �            1259    33498    genres_genre_id_seq    SEQUENCE     �   CREATE SEQUENCE public.genres_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.genres_genre_id_seq;
       public               cat    false    223            {           0    0    genres_genre_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.genres_genre_id_seq OWNED BY public.genres.genre_id;
          public               cat    false    224            �            1259    33499    liked_movies    TABLE     b   CREATE TABLE public.liked_movies (
    user_id integer NOT NULL,
    movie_id integer NOT NULL
);
     DROP TABLE public.liked_movies;
       public         heap r       cat    false            �            1259    33502    movie_genres    TABLE     c   CREATE TABLE public.movie_genres (
    movie_id integer NOT NULL,
    genre_id integer NOT NULL
);
     DROP TABLE public.movie_genres;
       public         heap r       cat    false            �            1259    33505    movies    TABLE       CREATE TABLE public.movies (
    movie_id integer NOT NULL,
    title character varying(255),
    year_of_release integer,
    director character varying(255),
    description text,
    star_rating numeric(3,2),
    number_of_ratings integer,
    poster character varying(255)
);
    DROP TABLE public.movies;
       public         heap r       cat    false            �            1259    33510    movies_movie_id_seq    SEQUENCE     �   CREATE SEQUENCE public.movies_movie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.movies_movie_id_seq;
       public               cat    false    227            |           0    0    movies_movie_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.movies_movie_id_seq OWNED BY public.movies.movie_id;
          public               cat    false    228            �            1259    33511    reviews    TABLE     �   CREATE TABLE public.reviews (
    movie_id integer,
    user_id integer,
    review_text text,
    date_of_writing timestamp without time zone
);
    DROP TABLE public.reviews;
       public         heap r       cat    false            �            1259    33516    stars    TABLE     x   CREATE TABLE public.stars (
    movie_id integer NOT NULL,
    user_id integer NOT NULL,
    number_of_stars integer
);
    DROP TABLE public.stars;
       public         heap r       cat    false            �            1259    33519    users    TABLE     �   CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(255),
    age integer,
    role character varying(50),
    password_hash text
);
    DROP TABLE public.users;
       public         heap r       cat    false            �            1259    33524    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public               cat    false    231            }           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public               cat    false    232            �           2604    33525    actors actor_id    DEFAULT     r   ALTER TABLE ONLY public.actors ALTER COLUMN actor_id SET DEFAULT nextval('public.actors_actor_id_seq'::regclass);
 >   ALTER TABLE public.actors ALTER COLUMN actor_id DROP DEFAULT;
       public               cat    false    218    217            �           2604    33526    age_categorys age_id    DEFAULT     |   ALTER TABLE ONLY public.age_categorys ALTER COLUMN age_id SET DEFAULT nextval('public.age_categorys_age_id_seq'::regclass);
 C   ALTER TABLE public.age_categorys ALTER COLUMN age_id DROP DEFAULT;
       public               cat    false    220    219            �           2604    33527    genres genre_id    DEFAULT     r   ALTER TABLE ONLY public.genres ALTER COLUMN genre_id SET DEFAULT nextval('public.genres_genre_id_seq'::regclass);
 >   ALTER TABLE public.genres ALTER COLUMN genre_id DROP DEFAULT;
       public               cat    false    224    223            �           2604    33528    movies movie_id    DEFAULT     r   ALTER TABLE ONLY public.movies ALTER COLUMN movie_id SET DEFAULT nextval('public.movies_movie_id_seq'::regclass);
 >   ALTER TABLE public.movies ALTER COLUMN movie_id DROP DEFAULT;
       public               cat    false    228    227            �           2604    33529    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public               cat    false    232    231            b          0    33477    actors 
   TABLE DATA           ;   COPY public.actors (actor_id, name, biography) FROM stdin;
    public               cat    false    217   )>       d          0    33483    age_categorys 
   TABLE DATA           P   COPY public.age_categorys (age_id, age, characteristic_of_category) FROM stdin;
    public               cat    false    219   �?       f          0    33489    ages_of_films 
   TABLE DATA           9   COPY public.ages_of_films (movie_id, age_id) FROM stdin;
    public               cat    false    221   �@       g          0    33492    filmography_of_actors 
   TABLE DATA           C   COPY public.filmography_of_actors (actor_id, movie_id) FROM stdin;
    public               cat    false    222   �@       h          0    33495    genres 
   TABLE DATA           6   COPY public.genres (genre_id, genre_name) FROM stdin;
    public               cat    false    223   A       j          0    33499    liked_movies 
   TABLE DATA           9   COPY public.liked_movies (user_id, movie_id) FROM stdin;
    public               cat    false    225   dA       k          0    33502    movie_genres 
   TABLE DATA           :   COPY public.movie_genres (movie_id, genre_id) FROM stdin;
    public               cat    false    226   �A       l          0    33505    movies 
   TABLE DATA           �   COPY public.movies (movie_id, title, year_of_release, director, description, star_rating, number_of_ratings, poster) FROM stdin;
    public               cat    false    227   �A       n          0    33511    reviews 
   TABLE DATA           R   COPY public.reviews (movie_id, user_id, review_text, date_of_writing) FROM stdin;
    public               cat    false    229   F       o          0    33516    stars 
   TABLE DATA           C   COPY public.stars (movie_id, user_id, number_of_stars) FROM stdin;
    public               cat    false    230   �F       p          0    33519    users 
   TABLE DATA           I   COPY public.users (user_id, email, age, role, password_hash) FROM stdin;
    public               cat    false    231   G       ~           0    0    actors_actor_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.actors_actor_id_seq', 8, true);
          public               cat    false    218                       0    0    age_categorys_age_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.age_categorys_age_id_seq', 4, true);
          public               cat    false    220            �           0    0    genres_genre_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.genres_genre_id_seq', 7, true);
          public               cat    false    224            �           0    0    movies_movie_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.movies_movie_id_seq', 9, true);
          public               cat    false    228            �           0    0    users_user_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_user_id_seq', 7, true);
          public               cat    false    232            �           2606    33531    actors actors_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.actors
    ADD CONSTRAINT actors_pkey PRIMARY KEY (actor_id);
 <   ALTER TABLE ONLY public.actors DROP CONSTRAINT actors_pkey;
       public                 cat    false    217            �           2606    33533     age_categorys age_categorys_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.age_categorys
    ADD CONSTRAINT age_categorys_pkey PRIMARY KEY (age_id);
 J   ALTER TABLE ONLY public.age_categorys DROP CONSTRAINT age_categorys_pkey;
       public                 cat    false    219            �           2606    33535     ages_of_films ages_of_films_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.ages_of_films
    ADD CONSTRAINT ages_of_films_pkey PRIMARY KEY (movie_id, age_id);
 J   ALTER TABLE ONLY public.ages_of_films DROP CONSTRAINT ages_of_films_pkey;
       public                 cat    false    221    221            �           2606    33537 0   filmography_of_actors filmography_of_actors_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.filmography_of_actors
    ADD CONSTRAINT filmography_of_actors_pkey PRIMARY KEY (actor_id, movie_id);
 Z   ALTER TABLE ONLY public.filmography_of_actors DROP CONSTRAINT filmography_of_actors_pkey;
       public                 cat    false    222    222            �           2606    33539    genres genres_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genre_id);
 <   ALTER TABLE ONLY public.genres DROP CONSTRAINT genres_pkey;
       public                 cat    false    223            �           2606    33541    liked_movies liked_movies_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.liked_movies
    ADD CONSTRAINT liked_movies_pkey PRIMARY KEY (user_id, movie_id);
 H   ALTER TABLE ONLY public.liked_movies DROP CONSTRAINT liked_movies_pkey;
       public                 cat    false    225    225            �           2606    33543    movie_genres movie_genres_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.movie_genres
    ADD CONSTRAINT movie_genres_pkey PRIMARY KEY (movie_id, genre_id);
 H   ALTER TABLE ONLY public.movie_genres DROP CONSTRAINT movie_genres_pkey;
       public                 cat    false    226    226            �           2606    33545    movies movies_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (movie_id);
 <   ALTER TABLE ONLY public.movies DROP CONSTRAINT movies_pkey;
       public                 cat    false    227            �           2606    33547    stars stars_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.stars
    ADD CONSTRAINT stars_pkey PRIMARY KEY (user_id, movie_id);
 :   ALTER TABLE ONLY public.stars DROP CONSTRAINT stars_pkey;
       public                 cat    false    230    230            �           2606    33549    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public                 cat    false    231            �           2606    33551    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 cat    false    231            b   �  x����J1���S�Ȃ�^k�T[��%���Z��V����
��ŵ��+L���*�PD��f3���3��,ۑI,t5�5U������;�hq�ڴf�
���?� '�2ƾ���� Ѻ.ESZ;	)�2���c�;�+�Z�%bX�d���=]���`����+:�Ň���{�:y�C�>(���7t�����g�P�`�R����P���_� קo-���鞅��H}bd	�vPP��.��h��>�y�m�?���Q�UŨ$�"+D�'**�՜�:���K�u�\	I�X�7��+�:&ڄ*��$��	$f�b��I�Sa�=�l�YW���5����/cϤGuI�^.n��������w�RCied
-q���_���ddKh�#)�T�j�	�Q�9��N      d   �   x�m�M
�0��/��^H�=���� ��ލj���9ü9	�W�%��L�e�y/�!�-����N�-0j�g���@h�
oB�z%::��;���3�<�1���oG����	s&N�Z�\b^ЂTpf)���
�T*sR�����ӯę����q��i�_qf�1{X��      f   *   x�3�4��2� �D��3NC#.sN3.NC3�=... ���      g   *   x���  ��w;�w�ø�&�m&��X��k��[�V5�      h   L   x�3�tL.����2�t)J�M�2�N��u��2�tK�+I,��2�t���M+3���M�KN�2�t.��M����� �S      j      x�3�4�2� bC �-�b���� )�"      k   *   x�3�4�2�4�2�&�F\�@l�i�e�i�e�i����� U�      l   )  x�mU�n�6�f��<@lH��ؗA���ЭC��t,q�H����O��PvӋ�!����ܨ����7�:���m�SЮ6��|h����Z�;���|��`z�fv:�yI�Ƶ4��uG	;��H�w)xK�@���v�d��	L���v��v��wk�_o
��-
�^���ګw�K�8��:�MQn�CLL~�;�;�:uO�u/C��`}$�tbK�~l;�4��w�2Gq�u���K	В cG@���3Sܟ�I۵ڭoU2?!� K��yH�;AX�ao\���5"Pk��+?&j�G�L�i���;hR���_��y��9M�;����R�׳������>�8&(�7V���=�� W�����,V3���K�A�/�a%��`>޺c��5�T��o&�<눴��k�mޮb�(�I�U���U���M��G�͙�KBs�y���eJ=;q���gc~���"�Z�t��	�gx�#��5t�	�#u���L�}$�l>����٧N�[$v�?@�3�}�>�v�'S�X���V�9�C�E�/��5'�¦i��$<Ė�� hb+pW��/*k 7A>E�@��CX@9�i��a������ː�A��A�F�o����TJP d���N�L����l�^�f2��s�}�K|`t��Y2�J"P;�=hk"YI�D<N:ku#�@�E��y�[n��I�|
{�Q�`���_D�;�������KB�K�{'?��ZL�4:���#�"���m�r�&p����)7	��!)����C�\h>wD(2Ř���Z�I���ҙ��=Z;��AlS���ѳ���+��EDmI�	���q>!�(f�)a� |�X���}x\�{��Z���>26;;��仂�N$Pu���R�4B���o����9b*��^�	c�����}�U�{�3T�������sp9����0LM�f"�˲��/���ry-�׌NI?b$��cv볽�@L�R,���3,M�'<p}��&���������w}uu����      n   �   x�M��j�0D�믘~@���!��
��zY+j� �F+��_	�ax�驧c��?H�U~�^`��|߮jM��;w�_����ܚ���#��:ŀ%��$�>`���RԪJƛİ�6�@��j(���in�Ƚ�3��gv �Ǝ4�g���W�3� ���(f�^��a��]�� ��E�      o   D   x���	�0ѳTL`m�ǽ��:2���B���뭥��qj��[�e��Ao�ʁ��J�'������ -��      p     x���[o�0 ����wxݕp����6b��)"�E��~�e.Y��'o>T%�ʔ�,;9���7\�J��+˦�1$������ޙV���� ��$���s~V0"�H!#[^���l���/��km{��x�T]}��7'=�~�=�)A�ɜ�ӌ%G$�k���7��xIƑnǹ[i���m�Ꜵ��IW��+ʴI^����Ǡ38u���4�<�{k~*��ۺ�{�9/�+ɝ�.�0�iZsS����r�C�oᴐ�     