/*
    This is the msgr relational DB
*/

GRANT ALL PRIVILEGES ON DATABASE msgr TO msgr;

CREATE SCHEMA IF NOT EXISTS msgr;

-- The main msgr user table
CREATE TABLE IF NOT EXISTS msgr.msgr_user (
    MsgrUserId              SERIAL       NOT NULL,
    Email                   VARCHAR(100) NOT NULL CHECK (char_length(Email)  >= 3)      CONSTRAINT "DF_MsgrUser_Email"      DEFAULT(null),
    Password                VARCHAR(100) NOT NULL CHECK (char_length(Password)  >= 8)   CONSTRAINT "DF_MsgrUser_Password"   DEFAULT(null),
    UserName                VARCHAR(100) NOT NULL CHECK (char_length(UserName)  >= 3)   CONSTRAINT "DF_MsgrUser_UserName"   DEFAULT(null),
    UserActiveStatus        BOOLEAN      NOT NULL CONSTRAINT "DF_MsgrUser_UserStatus"   DEFAULT (TRUE),
    CreateDate              TIMESTAMP    NOT NULL CONSTRAINT "DF_MsgrUser_CreateDate"   DEFAULT (NOW()),
    ModifiedDate            TIMESTAMP    NOT NULL CONSTRAINT "DF_MsgrUser_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "PK_MsgrUser_MsgrUserId" PRIMARY KEY (MsgrUserId),
    UNIQUE(Email),
    UNIQUE(UserName)
);

