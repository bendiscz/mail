-- CREATE USER mail_passwd ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_passwd;
GRANT SELECT, UPDATE ON mail.users TO mail_passwd;
GRANT SELECT ON mail.domains TO mail_passwd;
