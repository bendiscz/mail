-- CREATE USER mail_postfix ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_postfix;
GRANT SELECT ON mail.domains TO mail_postfix;
GRANT SELECT ON mail.users TO mail_postfix;
GRANT SELECT ON mail.aliases TO mail_postfix;
GRANT SELECT ON mail.std_aliases TO mail_postfix;
GRANT SELECT ON mail.relays TO mail_postfix;
