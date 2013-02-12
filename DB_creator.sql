CREATE DATABASE esocial;
USE esocial;

-- 							USERS AND PROFILES
CREATE TABLE user (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	password VARCHAR(255) NOT NULL UNIQUE,
	email VARCHAR(255) NOT NULL,
	created TIMESTAMP NOT NULL
);

CREATE TABLE user_profile (
	user_id INT NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	gender char(1),
	avatar_pic TEXT,
	birthdate DATE,
	show_bdate SMALLINT DEFAULT 0,
	hometown VARCHAR(255),
	location VARCHAR(255),
	about TEXT
);

ALTER TABLE user_profile ADD FOREIGN KEY(user_id) REFERENCES user(id) ON UPDATE CASCADE ON DELETE CASCADE;
