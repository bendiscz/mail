-- CREATE USER mail_relay ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_relay;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail.relays TO mail_relay;
