-- Drop the tables
DROP TABLE IF EXISTS customers;

-- Create tables
CREATE TABLE customers (
    id SERIAL,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

-- Populate data
INSERT INTO customers(first_name, last_name) VALUES 
	('Jane', 'Doe'),
	('Josh', 'Gruber'),
	('Hans', 'Gruber'),
	('John', 'Doe');

-- Real database starts here --

-- Drop tables
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS links CASCADE;
DROP TABLE IF EXISTS skills CASCADE;
DROP TABLE IF EXISTS technologies CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS event_comments CASCADE;
DROP TABLE IF EXISTS rsvp CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS post_comments CASCADE;
DROP TABLE IF EXISTS blogs CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS userroles CASCADE;
DROP TYPE IF EXISTS standing;
DROP TYPE IF EXISTS enumofroles;
DROP TYPE IF EXISTS poststatus;
DROP TYPE IF EXISTS enumofrsvpstatus;

-- Define the enumerations
CREATE TYPE standing as ENUM ('freshman', 'sophomore', 'junior', 'senior', 'alumnus');
CREATE TYPE enumofroles as ENUM ('user', 'officer', 'admin');
CREATE TYPE poststatus as ENUM ('pending', 'approved');
CREATE TYPE enumofrsvpstatus as ENUM ('attending', 'not attending', 'maybe');

-- Create the basic tables which support bigger tables

-- technologies

CREATE TABLE technologies (
	name VARCHAR(255) PRIMARY KEY
);

INSERT INTO technologies(name) VALUES 
	('Java'),
	('Spring (Java framework)'),
	('Javascript'),
	('ReactJS (JS library)'),
	('NodeJS'),
	('Python'),
	('Django (Python framework)'),
	('HTML 5'),
	('CSS 3'),
	('Bootstrap (HTML, CSS and JS library)'),
	('AngularJS (JS framework)');

-- links

CREATE TABLE links (
	id SERIAL PRIMARY KEY,
	github_link VARCHAR(255) UNIQUE,
	facebook_link VARCHAR(255) UNIQUE,
	twitter_link VARCHAR(255) UNIQUE,
	linkedin_link VARCHAR(255) UNIQUE,
	resume_link VARCHAR(255) UNIQUE,
	medium_link VARCHAR(255) UNIQUE,
	personal_link VARCHAR(255) UNIQUE
);

-- users
-- TODO: Remember to credit Freepik for the default avatar

CREATE TABLE users (
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	profile_url VARCHAR(255) NOT NULL DEFAULT 'https://i.imgur.com/gan8si2.png',
	current_standing standing NOT NULL,
	links_id INTEGER REFERENCES links(id),
	profile_email VARCHAR(255) NOT NULL,
	profile_pass VARCHAR(255) NOT NULL,
	profile_username VARCHAR(255) PRIMARY KEY, 
	account_created TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- roles

CREATE TABLE roles (
	role enumofroles PRIMARY KEY
);

INSERT INTO roles (role) VALUES ('user'),('officer'),('admin');

-- userroles

CREATE TABLE userroles (
	id SERIAL PRIMARY KEY, 
	user_name VARCHAR(255) REFERENCES users(profile_username),
	role_name enumofroles REFERENCES roles(role)
);

-- skills

CREATE TABLE skills (
	id SERIAL PRIMARY KEY,
	user_name VARCHAR(255) REFERENCES users(profile_username),
	technology VARCHAR(255) REFERENCES technologies(name),
	percent_confidence INT NOT NULL DEFAULT 0,
	CHECK (percent_confidence >= 0 AND percent_confidence <= 100)
);

-- posts

CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	author_name VARCHAR(255) REFERENCES users(profile_username),
	title VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	post_created TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	status poststatus NOT NULL DEFAULT 'pending',
	img_album_url VARCHAR(255)
);

-- comments

CREATE TABLE post_comments (
	id SERIAL PRIMARY KEY,
	comment TEXT NOT NULL,
	parent_comment_id INTEGER,
	upvotes INTEGER DEFAULT 0,
	post_id INTEGER NOT NULL REFERENCES posts(id),
	comment_created TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- blogs

CREATE TABLE blogs (
	id SERIAL PRIMARY KEY,
	author_name VARCHAR(255) REFERENCES users(profile_username),
	medium_link VARCHAR(255)
);

-- events

CREATE TABLE events (
	title VARCHAR(255) PRIMARY KEY,
	description TEXT NOT NULL,
	date_and_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	links_id INTEGER REFERENCES links(id),
	event_created TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE event_comments (
	id SERIAL PRIMARY KEY,
	comment TEXT NOT NULL,
	parent_comment_id INTEGER,
	upvotes INTEGER DEFAULT 0,
	event_name VARCHAR(255) NOT NULL REFERENCES events(title),
	comment_created TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- rsvp

CREATE TABLE rsvp (
	id SERIAL PRIMARY KEY,
	event_name VARCHAR(255) REFERENCES events(title),
	user_name VARCHAR(255) REFERENCES users(profile_username),
	status enumofrsvpstatus NOT NULL DEFAULT 'attending'
);

-- End of schema --