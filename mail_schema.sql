-- CREATE USER mail;
-- CREATE DATABASE mail OWNER mail;
-- \c mail mail;


CREATE SCHEMA mail;


CREATE TABLE mail.domains (
	domain_id			SERIAL		PRIMARY KEY,

	name				varchar(127)	UNIQUE NOT NULL CHECK (char_length(name) > 0),
	catchall			varchar(255)	CHECK ((catchall IS NULL) OR (char_length(catchall) > 0)),
	active				boolean		NOT NULL default true
);


CREATE TABLE mail.users (
	user_id				SERIAL		PRIMARY KEY,

	name				varchar(127)	NOT NULL CHECK (char_length(name) > 0),
	passwd				varchar(255)	NOT NULL,
	active				boolean		NOT NULL default true,

	domain_id			integer		NOT NULL REFERENCES mail.domains,

	UNIQUE (name, domain_id)
);


CREATE TABLE mail.aliases (
	alias_id			SERIAL		PRIMARY KEY,

	source				varchar(127)	NOT NULL CHECK (char_length(source) > 0),
	target				varchar(255)	NOT NULL CHECK (char_length(target) > 0),

	domain_id			integer		NOT NULL REFERENCES mail.domains
);

CREATE TABLE mail.std_aliases (
	std_alias_id			SERIAL		PRIMARY KEY,

	source				varchar(127)	UNIQUE NOT NULL CHECK (char_length(source) > 0),

	domain_id			integer		NOT NULL REFERENCES mail.domains
);


CREATE TABLE mail.policies (
	policy_id			SERIAL		PRIMARY KEY,

	virus_lover			char(1)		default NULL,     -- Y/N
	spam_lover			char(1)		default NULL,     -- Y/N
	unchecked_lover			char(1)		default NULL,     -- Y/N
	banned_files_lover		char(1)		default NULL,     -- Y/N
	bad_header_lover		char(1)		default NULL,     -- Y/N

	bypass_virus_checks		char(1)		default NULL,     -- Y/N
	bypass_spam_checks		char(1)		default NULL,     -- Y/N
	bypass_banned_checks		char(1)		default NULL,     -- Y/N
	bypass_header_checks		char(1)		default NULL,     -- Y/N

	virus_quarantine_to		varchar(64)	default NULL,
	spam_quarantine_to		varchar(64)	default NULL,
	banned_quarantine_to		varchar(64)	default NULL,
	unchecked_quarantine_to		varchar(64)	default NULL,
	bad_header_quarantine_to	varchar(64)	default NULL,
	clean_quarantine_to		varchar(64)	default NULL,
	archive_quarantine_to		varchar(64)	default NULL,

	spam_tag_level			real		default NULL, -- higher score inserts spam info headers
	spam_tag2_level			real		default NULL, -- inserts 'declared spam' header fields
	spam_tag3_level			real		default NULL, -- inserts 'blatant spam' header fields
	spam_kill_level			real		default NULL, -- higher score triggers evasive actions

	spam_dsn_cutoff_level		real		default NULL,
	spam_quarantine_cutoff_level	real		default NULL,

	addr_extension_virus		varchar(64)	default NULL,
	addr_extension_spam		varchar(64)	default NULL,
	addr_extension_banned		varchar(64)	default NULL,
	addr_extension_bad_header	varchar(64)	default NULL,

	warnvirusrecip			char(1)		default NULL, -- Y/N
	warnbannedrecip			char(1)		default NULL, -- Y/N
	warnbadhrecip			char(1)		default NULL, -- Y/N
	newvirus_admin			varchar(64)	default NULL,
	virus_admin			varchar(64)	default NULL,
	banned_admin			varchar(64)	default NULL,
	bad_header_admin		varchar(64)	default NULL,
	spam_admin			varchar(64)	default NULL,
	spam_subject_tag		varchar(64)	default NULL,
	spam_subject_tag2		varchar(64)	default NULL,
	spam_subject_tag3		varchar(64)	default NULL,
	message_size_limit		integer		default NULL, -- max size in bytes, 0 disable
	banned_rulenames		varchar(64)	default NULL, -- comma-separated list of ...
								      -- names mapped through %banned_rules to actual banned_filename tables
	disclaimer_options		varchar(64)	default NULL,
	forward_method			varchar(64)	default NULL,
	sa_userconf			varchar(64)	default NULL,
	sa_username			varchar(64)	default NULL,

	user_id				integer		UNIQUE NOT NULL REFERENCES mail.users ON DELETE CASCADE
);


CREATE TABLE mail.senders (
	sender_id			SERIAL		PRIMARY KEY,

	priority			integer		NOT NULL default '7',
	email				varchar(255)	UNIQUE NOT NULL CHECK (char_length(email) > 0)
);


CREATE TABLE mail.wblist (
	user_id				integer		NOT NULL REFERENCES mail.users,   -- recipient
	sender_id			integer		NOT NULL REFERENCES mail.senders, -- sender

	wb				varchar(10)	NOT NULL,  -- W or Y / B or N / space=neutral / score

	PRIMARY KEY (user_id, sender_id)
);


CREATE VIEW mail.recipients AS
	SELECT u.user_id AS recipient_id, (u.name || '@' || d.name) AS email
	FROM mail.users u, mail.domains d
	WHERE u.domain_id = d.domain_id
	AND u.active AND d.active;


CREATE VIEW mail.destinations AS
	SELECT  u.name AS name, d.name AS domain
	FROM mail.users u, mail.domains d
	WHERE u.domain_id = d.domain_id
	AND u.active AND d.active
	UNION SELECT  a.source, d.name
	FROM mail.aliases a, mail.domains d
	WHERE a.domain_id = d.domain_id
	AND d.active
	UNION SELECT '', d.name
	FROM mail.domains d
	WHERE d.catchall IS NOT NULL
	AND d.active;


CREATE TABLE mail.relays (
	name				varchar(127) NOT NULL,
	domain				varchar(127) NOT NULL CHECK (char_length(domain) > 0),

	UNIQUE (name, domain)
);

CREATE INDEX relays_domain_idx ON mail.relays (domain);


CREATE TABLE mail.versions (
	system				varchar(32) PRIMARY KEY,
	version				integer NOT NULL default 0
);

INSERT INTO mail.versions (system, version) VALUES ('local', 1);


CREATE OR REPLACE FUNCTION mail.version_check(remote_system varchar(32)) RETURNS boolean AS $$
DECLARE
	local_version integer;
BEGIN
	-- get the local version
	SELECT version
	  INTO local_version
	  FROM mail.versions
	 WHERE system = 'local';

	-- update the version of the remote system
	UPDATE mail.versions
	   SET version = local_version
	 WHERE system = remote_system AND version < local_version;

	-- return true iff updated
	RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE OR REPLACE FUNCTION mail.version_inc() RETURNS trigger AS $$
BEGIN
	-- increment the local version
	UPDATE mail.versions
	   SET version = version + 1
	 WHERE system = 'local';

	RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE OR REPLACE FUNCTION mail.update_passwd(user_name text, domain_name text, new_passwd text) RETURNS void AS $$
DECLARE
    new_passwd_enc text;
BEGIN
    -- encode the password
    SELECT encode(convert_to(new_passwd, 'utf8'), 'base64')
      INTO new_passwd_enc;

    -- change the password
    UPDATE mail.users u
       SET passwd = new_passwd_enc
      FROM mail.domains d
     WHERE u.domain_id = d.domain_id AND u.name = user_name AND d.name = domain_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE TRIGGER inc_domains_version AFTER INSERT OR UPDATE OR DELETE ON mail.domains EXECUTE PROCEDURE mail.version_inc();
CREATE TRIGGER inc_users_version AFTER INSERT OR UPDATE OR DELETE ON mail.users EXECUTE PROCEDURE mail.version_inc();
CREATE TRIGGER inc_aliases_version AFTER INSERT OR UPDATE OR DELETE ON mail.aliases EXECUTE PROCEDURE mail.version_inc();
