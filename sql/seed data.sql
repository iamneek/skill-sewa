use skillsewa;

INSERT INTO categories (name) VALUES 
('Technology'), ('Language'), ('Music'), ('Art'), ('Fitness'), ('Cooking'), ('Academic'), ('Other');

INSERT INTO users (user_id, full_name, email, password, role)
VALUES ('admin8848', 'Admin', 'admin@skillsewa.com', 'Admin1234$', 'admin');

INSERT INTO users (user_id, full_name, email, password, phone)
VALUES ('user8848', 'Test User', 'user@skillsewa.com', 'User1234$', '9812345678');


select * from users;