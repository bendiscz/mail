-- CREATE USER mail_amavis ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_amavis;
GRANT SELECT ON mail.domains TO mail_amavis;
GRANT SELECT ON mail.users TO mail_amavis;
GRANT SELECT ON mail.policies TO mail_amavis;
GRANT SELECT ON mail.senders TO mail_amavis;
GRANT SELECT ON mail.wblist TO mail_amavis;
