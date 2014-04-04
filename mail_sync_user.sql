-- CREATE USER mail_sync ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_sync;
GRANT SELECT ON mail.destinations TO mail_sync;
GRANT EXECUTE ON FUNCTION mail.version_check(varchar(32)) TO mail_sync;
