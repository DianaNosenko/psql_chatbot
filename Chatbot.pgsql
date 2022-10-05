CREATE TABLE Users(
    user_id serial PRIMARY KEY,
    user_name varchar(30)CHECK (length(user_name)>0) NOT NULL,
    user_surname varchar(30) CHECK (length(user_surname)>0) NOT NULL,
    login varchar(60) UNIQUE CHECK (length(login)>0) DEFAULT 'NewUser' ,
    password varchar(60) CHECK (length(password)>0) NOT NULL
);

CREATE TABLE Chats(
    chat_id serial PRIMARY KEY,
    chat_name varchar(30) CHECK (length(chat_name)>0) NOT NULL,
    chat_date date DEFAULT now(),
    chat_creator int REFERENCES Users(user_id) NOT NULL
);

CREATE TABLE Messages(
    msg_id serial PRIMARY KEY,
    msg_create_date date DEFAULT now(),
    msg_update_date date,
    msg_creator_name int REFERENCES Users(user_id) NOT NULL
);

CREATE TABLE Info(
    user_id int REFERENCES Users(user_id) NOT NULL,
    chat_id int REFERENCES Chats(chat_id) NOT NULL,
    msg_id int REFERENCES Messages(msg_id) NOT NULL
);

INSERT INTO Users(user_name, user_surname, login, password) VALUES
('Vasya', 'Ivanov', 'Vasya_Ivanov', 'password1'),
('Ann', 'Petrova', 'Annabel', 'password2'),
('Elizabeth', 'Smith', 'Elsa', 'password3'),
('Johnatan', 'Fox', 'John_Fox', 'password4');

INSERT INTO Chats(chat_name, chat_date, chat_creator) VALUES
('Chat1', '2022-09-01', 1),
('Chat2', '2021-01-01', 1),
('Chat3', '2022-05-01', 1);

INSERT INTO Messages(msg_create_date, msg_creator_name) VALUES
('2022-10-01', 2),
('2022-10-01', 1),
('2022-10-01', 2),
('2022-10-02', 3),
('2022-10-02', 2),
('2022-10-03', 1),
('2022-10-03', 4),
('2022-10-03', 3);

/*ф-ція, яка повертає id користувача який залишив повідомлення*/
CREATE FUNCTION GetUserId(id integer) 
RETURNS integer AS $$
    SELECT msg_creator_name FROM Messages WHERE msg_id=id;
$$ LANGUAGE SQL;


INSERT INTO Info(user_id, chat_id, msg_id) VALUES
((SELECT GetUserId(1)), 1, 1),
((SELECT GetUserId(2)), 1, 2),
((SELECT GetUserId(3)), 2, 3),
((SELECT GetUserId(4)), 3, 4),
((SELECT GetUserId(5)), 1, 5),
((SELECT GetUserId(6)), 3, 6),
((SELECT GetUserId(7)), 3, 7),
((SELECT GetUserId(8)), 2, 8);

SELECT * FROM Info;


/*получить инфу о сообщениях */
SELECT * FROM Messages;

/*получить первое сообщение */
SELECT * FROM Messages 
WHERE msg_id=
    (SELECT  min(msg_id) 
    FROM Messages);

/*получить последнее сообщение */
SELECT * FROM Messages 
WHERE msg_id=
    (SELECT  max(msg_id) 
    FROM Messages);

/*получить количество сообщений по чату */
SELECT chat_id, count(msg_id)
FROM Info
GROUP BY chat_id;

/*получить количество чатов */
        /*способ 1*/
SELECT count(chat_id)
FROM Chats;

        /*способ 2*/
SELECT count(DISTINCT chat_id)
FROM Info;

/*количество сообщений в конкретном чате от конкретного пользователя */
SELECT count(msg_id)
FROM Info
WHERE user_id=2 and chat_id=1;

/*создать view (представление) - список сообщений (начиная с самого нового) для чата */
CREATE VIEW msg_list AS
(SELECT * FROM Messages)
ORDER BY msg_create_date DESC;

SELECT * FROM msg_list;
