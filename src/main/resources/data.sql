-- Make 2 dummy accounts

-- Test Account 01

WITH link_insert AS (
	INSERT INTO links (github_link, facebook_link, linkedin_link, personal_link, resume_link) VALUES (
		'https://github.com/deepankarmalhan',
		'https://www.facebook.com/DeepankarMalhan',
		'https://www.linkedin.com/in/deepankarmalhan/',
		'https://www.deepankar-malhan.info/',
		'https://www.deepankar-malhan.info/static/media/Resume.31acb91d.pdf'
	)
	RETURNING id AS links_ins_id
)
, user_insert AS (
   INSERT INTO users(first_name, last_name, current_standing, links_id, profile_email, profile_pass, profile_username)
   SELECT 'Test', 
   		'Account 01', 
   		'freshman', 
   		links_ins_id, 
   		'testaccount01@my.ccsu.edu', 
   		'$2a$10$dfzBKX4.VIYoHpwk9t0Tbe3z1YdJ8Gzn90UHHmNZTXYjkiLQ93juy', -- pass1 is the original value before hashed with bcrypt and "$2a$10$CcDLcwh7SuMS/LiPYFQgnOfiZiza3fsn37w/jqem9d07znRqnJoES" for the pass2
   		'testaccount01'
   	FROM link_insert
)
, user_skills_insert AS (
	INSERT INTO skills(user_name, technology, percent_confidence)
	VALUES ('testaccount01','Java', 90),
	('testaccount01', 'Spring (Java framework)', 40),
	('testaccount01', 'Javascript', 80),
	('testaccount01', 'ReactJS (JS library)', 90)
)
INSERT INTO userroles (user_name, role_name)
VALUES ('testaccount01', 'user'), ('testaccount01', 'admin'), ('testaccount01', 'officer');

-- Test Account 02

WITH link_insert AS (
	INSERT INTO links (github_link, facebook_link, linkedin_link) VALUES (
		'https://github.com/NilayBhatt/',
		'https://www.facebook.com/nilay.bhatt.94',
		'https://www.linkedin.com/in/nilay-bhatt-3a79a7100/'
	)
	RETURNING id AS links_ins_id
)
, user_insert AS (
   INSERT INTO users(first_name, last_name, current_standing, links_id, profile_email, profile_pass, profile_username)
   SELECT 'Test', 
   		'Account 02', 
   		'freshman', 
   		links_ins_id, 
   		'testaccount02@my.ccsu.edu', 
   		'$2a$10$CcDLcwh7SuMS/LiPYFQgnOfiZiza3fsn37w/jqem9d07znRqnJoES', -- pass2 is the original value before hashed with bcrypt
   		'testaccount02'
   	FROM link_insert
)
, user_skills_insert AS (
	INSERT INTO skills(user_name, technology, percent_confidence)
	VALUES ('testaccount02','NodeJS', 20),
	('testaccount02', 'Python', 65),
	('testaccount02', 'HTML 5', 100),
	('testaccount02', 'Bootstrap (HTML, CSS and JS library)', 50)
)
INSERT INTO userroles (user_name, role_name)
VALUES ('testaccount02', 'user'), ('testaccount02', 'admin'), ('testaccount02', 'officer');

-- Make 2 dummy events and have both dummy accounts rsvp

WITH event_link_insert AS (
	INSERT INTO links(facebook_link) 
	VALUES ('https://www.facebook.com/events/2077807209160810/')
	RETURNING id as link_ins_id
)
INSERT INTO events(title, description, date_and_time, links_id)
SELECT 'Test Event 01', 
	'Lorem ipsum dolor sit amet, consectetur adipisicing elit, 
	sed do eiusmod tempor incididunt ut labore et dolore magna 
	aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
	ullamco laboris nisi ut aliquip ex ea commodo consequat. 
	Duis aute irure dolor in reprehenderit in voluptate velit esse 
	cillum dolore eu fugiat nulla pariatur. Excepteur sint 
	occaecat cupidatat non proident, sunt in culpa qui officia
	deserunt mollit anim id est laborum.',
	'2018-08-23 19:20:00',
	link_ins_id
FROM event_link_insert;

WITH event_link_insert AS (
	INSERT INTO links(facebook_link) 
	VALUES ('https://www.facebook.com/events/599560187043759/')
	RETURNING id as link_ins_id
)
INSERT INTO events(title, description, date_and_time, links_id)
SELECT 'Test Event 02', 
	'Lorem ipsum dolor sit amet, consectetur adipisicing elit, 
	sed do eiusmod tempor incididunt ut labore et dolore magna 
	aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
	ullamco laboris nisi ut aliquip ex ea commodo consequat. 
	Duis aute irure dolor in reprehenderit in voluptate velit esse 
	cillum dolore eu fugiat nulla pariatur. Excepteur sint 
	occaecat cupidatat non proident, sunt in culpa qui officia
	deserunt mollit anim id est laborum.',
	'2018-12-25 19:20:00',
	link_ins_id
FROM event_link_insert;

-- Have the 2 dummy accounts RSVP to the 2 dummy events

INSERT INTO rsvp(event_name, user_name,status) VALUES
('Test Event 01', 'testaccount01', 'attending'),
('Test Event 01', 'testaccount02', 'maybe'),
('Test Event 02', 'testaccount01', 'not attending'),
('Test Event 02', 'testaccount02', 'attending');

-- Make comments for the events

WITH first_comment_ins AS (
	INSERT INTO event_comments(comment, upvotes, event_name)
	VALUES ('This is a test parent comment 01 :)', 300, 'Test Event 01')
	RETURNING id as parent_cmnt_id
),
child_to_first_cmnt_ins AS (
	INSERT INTO event_comments(comment, upvotes, event_name, parent_comment_id)
	SELECT 'This is a test parent comment 01 :)', 700, 'Test Event 01', parent_cmnt_id FROM first_comment_ins
)
INSERT INTO event_comments(comment, upvotes, event_name)
VALUES ('This is a test parent comment 02 :)', 500, 'Test Event 01');

WITH first_comment_ins AS (
	INSERT INTO event_comments(comment, upvotes, event_name)
	VALUES ('This is a test parent comment 01 :)', 300, 'Test Event 02')
	RETURNING id as parent_cmnt_id
),
child_to_first_cmnt_ins AS (
	INSERT INTO event_comments(comment, upvotes, event_name, parent_comment_id)
	SELECT 'This is a test parent comment 01 :)', 700, 'Test Event 02', parent_cmnt_id FROM first_comment_ins
)
INSERT INTO event_comments(comment, upvotes, event_name)
VALUES ('This is a test parent comment 02 :)', 500, 'Test Event 02');

-- Make dummy posts

INSERT INTO posts(author_name, title, description, status) VALUES
('testaccount01', 'Test Post 01', 'I have something to say here, I swear!', 'pending'),
('testaccount01', 'Test Post 02', 'I have something to say here, I swear!', 'approved'),
('testaccount02', 'Test Post 03', 'I have something to say here, I swear!', 'pending'),
('testaccount02', 'Test Post 04', 'I have something to say here, I swear!', 'approved');