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

CREATE TABLE friend_pair(
	user_id INT NOT NULL,
	friend_id INT NOT NULL,
	status INT DEFAULT 0,
	PRIMARY KEY(user_id, friend_id)
);

ALTER TABLE friend_pair ADD FOREIGN KEY(user_id) REFERENCES user_profile(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE friend_pair ADD FOREIGN KEY(friend_id) REFERENCES user_profile(user_id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE friend_group (
	user_id INT NOT NULL,
	name VARCHAR(64) NOT NULL,
	PRIMARY KEY(user_id, name)
);

ALTER TABLE friend_group ADD FOREIGN KEY(user_id) REFERENCES user_profile(user_id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE friend_group_member(
	user_id INT NOT NULL,
	name VARCHAR(64) NOT NULL,
	friend_id INT NOT NULL,
	PRIMARY KEY(user_id, name, friend_id)
);

ALTER TABLE friend_group_member ADD FOREIGN KEY(user_id) REFERENCES user_profile(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE friend_group_member ADD FOREIGN KEY(friend_id) REFERENCES user_profile(user_id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE message(
	id INT PRIMARY KEY AUTO_INCREMENT,
	from_id INT NOT NULL,
	to_id INT NOT NULL,
	created TIMESTAMP NOT NULL,
	title VARCHAR(255),
	content TEXT NOT NULL,
	has_read INT DEFAULT 0
);

ALTER TABLE message ADD FOREIGN KEY(from_id) REFERENCES  user_profile(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE message ADD FOREIGN KEY(to_id) REFERENCES  user_profile(user_id) ON UPDATE CASCADE ON DELETE CASCADE;