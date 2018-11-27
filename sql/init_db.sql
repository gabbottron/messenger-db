/*
    This is the msgr relational DB
*/

GRANT ALL PRIVILEGES ON DATABASE msgr TO msgr;

CREATE SCHEMA IF NOT EXISTS msgr;

-- The main msgr user table
CREATE TABLE IF NOT EXISTS msgr.msgr_user (
    MsgrUserId              SERIAL       NOT NULL,
    UserName                VARCHAR(100) NOT NULL CHECK (char_length(UserName)  >= 3)   CONSTRAINT "DF_MsgrUser_UserName"   DEFAULT(null),
    Password                VARCHAR(100) NOT NULL CHECK (char_length(Password)  >= 8)   CONSTRAINT "DF_MsgrUser_Password"   DEFAULT(null),
    UserActiveStatus        BOOLEAN      NOT NULL CONSTRAINT "DF_MsgrUser_UserStatus"   DEFAULT (TRUE),
    CreateDate              TIMESTAMP    NOT NULL CONSTRAINT "DF_MsgrUser_CreateDate"   DEFAULT (NOW()),
    ModifiedDate            TIMESTAMP    NOT NULL CONSTRAINT "DF_MsgrUser_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "PK_MsgrUser_MsgrUserId" PRIMARY KEY (MsgrUserId),
    UNIQUE(UserName)
);

-- The message table
CREATE TABLE IF NOT EXISTS msgr.message (
    MessageId               SERIAL      NOT NULL,
    SenderId                INT         NOT NULL,
    RecipientId             INT         NOT NULL,
    --SequenceNumber          INT         NOT NULL,
    --MessageContentId        INT         NOT NULL,
    MessageContentType      VARCHAR(10) NOT NULL CHECK (MessageContentType IN ('text', 'image', 'video')) CONSTRAINT "DF_Message_MessageContentType" DEFAULT ('text'),
    CreateDate              TIMESTAMP   NOT NULL CONSTRAINT "DF_Message_CreateDate"   DEFAULT (NOW()),
    ModifiedDate            TIMESTAMP   NOT NULL CONSTRAINT "DF_Message_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "PK_Message_MessageId"   PRIMARY KEY (MessageId),
    CONSTRAINT "FK_Message_SenderId"    FOREIGN KEY (SenderId)      REFERENCES msgr.msgr_user (MsgrUserId),
    CONSTRAINT "FK_Message_RecipientId" FOREIGN KEY (RecipientId)   REFERENCES msgr.msgr_user (MsgrUserId)
);

-- The text message table
CREATE TABLE IF NOT EXISTS msgr.message_text (
    MessageTextId   SERIAL          NOT NULL,
    MessageId       INT             NOT NULL,
    MessageText     VARCHAR(250)    NULL,
    CreateDate      TIMESTAMP       NOT NULL CONSTRAINT "DF_MessageText_CreateDate"   DEFAULT (NOW()),
    ModifiedDate    TIMESTAMP       NOT NULL CONSTRAINT "DF_MessageText_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "PK_MessageText_MessageTextId"   PRIMARY KEY (MessageTextId),
    CONSTRAINT "FK_MessageText_MessageId"       FOREIGN KEY (MessageId) REFERENCES msgr.message (MessageId)
);

-- The image message table
CREATE TABLE IF NOT EXISTS msgr.message_image (
    MessageImageId  SERIAL         NOT NULL,
    MessageId       INT            NOT NULL,
    ImageUri        VARCHAR(250)   NULL,
    ImageType       VARCHAR(250)   NULL,
    CreateDate      TIMESTAMP      NOT NULL CONSTRAINT "DF_MessageImage_CreateDate"   DEFAULT (NOW()),
    ModifiedDate    TIMESTAMP      NOT NULL CONSTRAINT "DF_MessageImage_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "PK_MessageImage_MessageImageId"     PRIMARY KEY (MessageImageId),
    CONSTRAINT "FK_MessageImage_MessageId"          FOREIGN KEY (MessageId) REFERENCES msgr.message (MessageId)
);

-- The video message table
CREATE TABLE IF NOT EXISTS msgr.message_video (
    MessageVideoId  SERIAL          NOT NULL,
    MessageId       INT             NOT NULL,
    VideoUri        VARCHAR(250)    NULL,
    VideoEncoding   VARCHAR(250)    NULL,
    VideoLength     INT             NULL,
    CreateDate      TIMESTAMP       NOT NULL CONSTRAINT "DF_MessageVideo_CreateDate"   DEFAULT (NOW()),
    ModifiedDate    TIMESTAMP       NOT NULL CONSTRAINT "DF_MessageVideo_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "PK_MessageVideo_MessageVideoId"     PRIMARY KEY (MessageVideoId),
    CONSTRAINT "FK_MessageVideo_MessageId"          FOREIGN KEY (MessageId) REFERENCES msgr.message (MessageId)
);