-- CREATE USER mail_sa ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail_sa TO mail_sa;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail_sa.awl TO mail_sa;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail_sa.bayes_expire TO mail_sa;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail_sa.bayes_global_vars TO mail_sa;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail_sa.bayes_seen TO mail_sa;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail_sa.bayes_token TO mail_sa;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail_sa.bayes_vars TO mail_sa;
GRANT SELECT, UPDATE ON mail_sa.bayes_vars_id_seq TO mail_sa;
GRANT EXECUTE ON FUNCTION mail_sa.greatest_int(integer, integer) TO mail_sa;
GRANT EXECUTE ON FUNCTION mail_sa.least_int(integer, integer) TO mail_sa;
GRANT EXECUTE ON FUNCTION mail_sa.put_tokens(integer, bytea[], integer, integer, integer) TO mail_sa;
