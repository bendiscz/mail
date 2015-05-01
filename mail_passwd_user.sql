-- CREATE USER mail_passwd ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_passwd;
GRANT EXECUTE ON FUNCTION mail.update_passwd(text, text, text) TO mail_passwd;
