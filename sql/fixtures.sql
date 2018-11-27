/*
	These are some basic fixtures for dev.
*/

-- msgr_user ----------------------------------------------------------------------------
INSERT INTO msgr.msgr_user 
		(UserName, Password) 
	VALUES 
		('gabbott', '$2a$10$8283VgLJDQJ7.L/8/kHGJeMoeNxehft5HE1fPv7q3pVRodn6TihsK');

INSERT INTO msgr.msgr_user 
		(UserName, Password) 
	VALUES 
		('testwan', '$2a$10$8283VgLJDQJ7.L/8/kHGJeMoeNxehft5HE1fPv7q3pVRodn6TihsK');


-- message ------------------------------------------------------------------------------
INSERT INTO msgr.message 
		(SenderId, RecipientId, MessageContentType) 
	VALUES 
		(1, 2, 'text');

INSERT INTO msgr.message 
		(SenderId, RecipientId, MessageContentType) 
	VALUES 
		(1, 2, 'text');

INSERT INTO msgr.message 
		(SenderId, RecipientId, MessageContentType) 
	VALUES 
		(2, 1, 'text');

INSERT INTO msgr.message 
		(SenderId, RecipientId, MessageContentType) 
	VALUES 
		(1, 2, 'text');

INSERT INTO msgr.message 
		(SenderId, RecipientId, MessageContentType) 
	VALUES 
		(2, 1, 'image');

-- message_text -------------------------------------------------------------------------
INSERT INTO msgr.message_text 
		(MessageId, MessageText) 
	VALUES 
		(1, 'Hey brah, what up?');

INSERT INTO msgr.message_text 
		(MessageId, MessageText) 
	VALUES 
		(2, 'You wanna get some lunch?');

INSERT INTO msgr.message_text 
		(MessageId, MessageText) 
	VALUES 
		(3, 'Not much.. lemme check mah skedge');

INSERT INTO msgr.message_text 
		(MessageId, MessageText) 
	VALUES 
		(4, 'word');

-- message_image ------------------------------------------------------------------------
INSERT INTO msgr.message_image 
		(MessageId, ImageUri, ImageType) 
	VALUES 
		(5, 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/220px-SNice.svg.png', 'png');