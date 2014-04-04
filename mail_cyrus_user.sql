-- CREATE USER mail_cyrus ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_cyrus;
GRANT SELECT ON mail.domains TO mail_cyrus;
GRANT SELECT ON mail.users TO mail_cyrus;
