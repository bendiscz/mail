-- CREATE USER mail_sam ENCRYPTED PASSWORD '???';


GRANT USAGE ON SCHEMA mail TO mail_sam;
GRANT SELECT ON mail.recipients TO mail_sam;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail.senders TO mail_sam;
GRANT SELECT, UPDATE ON mail.senders_sender_id_seq TO mail_sam;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail.wblist TO mail_sam;
GRANT SELECT, INSERT, UPDATE, DELETE ON mail.policies TO mail_sam;
GRANT SELECT, UPDATE ON mail.policies_policy_id_seq TO mail_sam;
