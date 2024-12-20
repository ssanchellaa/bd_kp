CREATE TABLE IF NOT EXISTS performances (
    performance_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    year_of_premiere INT,
    director VARCHAR(255),
    description TEXT,
    rating DECIMAL(3, 2),
    number_of_reviews INT,
    poster VARCHAR(255)
);

INSERT INTO performances (title, year_of_premiere, director, description, rating, number_of_reviews, poster)
VALUES
('Hamlet', 1600, 'William Shakespeare', 'A tragedy about the prince of Denmark seeking revenge.', 9.2, 1500, 'hamlet_poster.jpg'),
('Les Misérables', 1980, 'Claude-Michel Schönberg', 'A musical based on the novel by Victor Hugo, exploring love, justice, and revolution.', 8.7, 2200, 'les_miserables.jpg'),
('The Phantom of the Opera', 1986, 'Andrew Lloyd Webber', 'A haunting love story set in the Paris Opera House.', 9.0, 1800, 'phantom_of_the_opera.jpg'),
('Romeo and Juliet', 1597, 'William Shakespeare', 'The classic tale of forbidden love between two young lovers from feuding families.', 8.8, 2000, 'romeo_and_juliet.jpg'),
('Cats', 1981, 'Andrew Lloyd Webber', 'A musical about a tribe of cats who must decide which one will ascend to the Heaviside Layer and be reborn.', 7.5, 1200, 'cats.jpg'),
('Wicked', 2003, 'Stephen Schwartz', 'A prequel to The Wizard of Oz, focusing on the relationship between Glinda the Good Witch and the Wicked Witch of the West.', 8.9, 2100, 'wicked.jpg'),
('The Lion King', 1997, 'Julie Taymor', 'A musical based on the Disney animated film, telling the story of Simba and his journey to become king.', 9.3, 2500, 'lion_king.jpg'),
('Mamma Mia!', 1999, 'Phyllida Lloyd', 'A light-hearted musical based on the songs of ABBA, set on a Greek island.', 7.6, 1400, 'mamma_mia.jpg');

CREATE TABLE IF NOT EXISTS performance_logs (
    log_id SERIAL PRIMARY KEY,
    action TEXT NOT NULL,
    performance_id INTEGER NOT NULL,
    action_time TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION log_performance_changes()
RETURNS TRIGGER AS $$ 
BEGIN 
    IF TG_OP = 'INSERT' THEN
        INSERT INTO performance_logs(action, performance_id, action_time)
        VALUES ('Добавление', NEW.performance_id, NOW());
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO performance_logs(action, performance_id, action_time)
        VALUES ('Удаление', OLD.performance_id, NOW());
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER performance_changes_trigger
AFTER INSERT OR DELETE ON performances
FOR EACH ROW
EXECUTE FUNCTION log_performance_changes();


CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    age INT,
    role VARCHAR(50),
    password_hash TEXT
);

INSERT INTO users (email, age, role, password_hash)
VALUES
('user1@example.com', 20, 'audience', 'hashed_password'),
('user@example.com', 25, 'audience', 'hashed_password'),
('user3@example.com', 20, 'audience', 'hashed_password'),
('user4@example.com', 25, 'audience', 'hashed_password'),
('admin', 10, 'admin', 'hashed_password');


CREATE TABLE IF NOT EXISTS age_categories (
    age_id SERIAL PRIMARY KEY,
    age_range VARCHAR(50), -- возрастной диапазон
    description TEXT
);

INSERT INTO age_categories (age_range, description)
VALUES
('6-11', 'Для детей младшего возраста.'),
('12-15', 'Для подростков.'),
('16-17', 'Для старших подростков.'),
('18+', 'Для взрослых зрителей.');

CREATE TABLE IF NOT EXISTS performance_age_categories (
    performance_id INT,
    age_id INT,
    PRIMARY KEY (performance_id, age_id),
    FOREIGN KEY (performance_id) REFERENCES performances(performance_id) ON DELETE CASCADE, 
    FOREIGN KEY (age_id) REFERENCES age_categories(age_id) ON DELETE CASCADE
);

INSERT INTO performance_age_categories (performance_id, age_id)
SELECT 1, age_id FROM age_categories WHERE age_range = '18+'; -- Hamlet
INSERT INTO performance_age_categories (performance_id, age_id)
SELECT 2, age_id FROM age_categories WHERE age_range = '18+'; -- Les Misérables
INSERT INTO performance_age_categories (performance_id, age_id)
SELECT 3, age_id FROM age_categories WHERE age_range = '18+'; -- Phantom of the Opera

CREATE TABLE IF NOT EXISTS reviews (
    performance_id INT,
    user_id INT,
    review_text TEXT,    
    date_of_writing TIMESTAMP,
    PRIMARY KEY (user_id, performance_id),
    FOREIGN KEY (performance_id) REFERENCES performances(performance_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE 
);

INSERT INTO reviews (performance_id, user_id, review_text, date_of_writing)
VALUES
(1, 1, 'An unforgettable experience, a true masterpiece!', '2024-01-01 18:00:00'),
(2, 2, 'The depth of the characters is amazing.', '2024-01-02 20:00:00'),
(3, 3, 'A hauntingly beautiful production.', '2024-01-03 22:00:00'),
(4, 4, 'A timeless story, brilliantly executed.', '2024-01-04 23:00:00')
ON CONFLICT (performance_id, user_id) DO NOTHING;

CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(255)    
);

INSERT INTO genres (genre_name)
VALUES
('Drama'),
('Musical'),
('Comedy'),
('Fantasy'),
('Romance'),
('Thriller');

CREATE TABLE IF NOT EXISTS performance_genres (
    performance_id INT,
    genre_id INT,
    PRIMARY KEY (performance_id, genre_id),
    FOREIGN KEY (performance_id) REFERENCES performances(performance_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
);

INSERT INTO performance_genres (performance_id, genre_id)
VALUES
(1, 1), -- Hamlet - Drama
(2, 2), -- Les Misérables - Musical
(3, 2), -- Phantom of the Opera - Musical
(4, 1), -- Romeo and Juliet - Drama
(5, 2), -- Cats - Musical
(6, 2), -- Wicked - Musical
(7, 2), -- The Lion King - Musical
(8, 2) -- Mamma Mia! - Musical
ON CONFLICT (performance_id, genre_id) DO NOTHING;

CREATE TABLE IF NOT EXISTS actors (
    actor_id SERIAL PRIMARY KEY,
    name VARCHAR(255), 
    biography TEXT 
);

INSERT INTO actors (name, biography)
VALUES
('Ian McKellen', 'English actor known for his roles in Shakespearean plays and The Lord of the Rings film series.'),
('Lupita Nyong\'o', 'Kenyan actress known for her performance in The Lion King.'),
('Hugh Jackman', 'Australian actor known for his roles in musicals like Les Misérables.'),
('Meryl Streep', 'American actress, considered one of the greatest of all time, known for her roles in drama films and musicals.'),
('Helen Mirren', 'English actress known for her roles in drama and historical films.'),
('Andrew Lloyd Webber', 'English composer of musical theatre, known for creating many popular musicals.'),
('Julie Andrews', 'English actress and singer, known for her roles in musical films and plays.'),
('Lin-Manuel Miranda', 'American composer, lyricist, and actor, known for his work in musicals like Hamilton.');

CREATE TABLE IF NOT EXISTS actor_performances (
    actor_id INT,
    performance_id INT,
    PRIMARY KEY (actor_id, performance_id),
    FOREIGN KEY (actor_id) REFERENCES actors(actor_id) ON DELETE CASCADE, -- foreign key to actors
    FOREIGN KEY (performance_id) REFERENCES performances(performance_id)
);

INSERT INTO actor_performances (actor_id, performance_id)
VALUES
(1, 1), -- Ian McKellen - Hamlet
(2, 7), -- Lupita Nyong'o - The Lion King
(3, 2), -- Hugh Jackman - Les Misérables
(4, 4), -- Meryl Streep - Romeo and Juliet
(5, 5), -- Helen Mirren - Cats
(6, 6), -- Andrew Lloyd Webber - Wicked
(7, 3), -- Julie Andrews - Phantom of the Opera
(8, 8) -- Lin-Manuel Miranda - Mamma Mia!
ON CONFLICT (actor_id, performance_id) DO NOTHING;
