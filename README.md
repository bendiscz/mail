mail
====

postfix+cyrus+amavis+clamav+spamassassin+postgresql mail system

Checklist
---------

1. Install postgresql, clamav, clamav-daemon, amavisd-new, postfix, cyrus-imapd, cyrus-pop3d, cyrus-admin, opendkim,
   opendmarc, spamassassin
2. Install libsasl2-modules-sql, libdbd-pg-perl, arj, cabextract, lzop, unrar, unrar-free, zoo, lhasa, nomarch, p7zip,
   pyzor, razor, postfix-pgsql, postfix-pcre, postfix-policyd-spf-python, python3-authres
3. Set up database schema (base + sa)
4. Set up database users
5. Copy and configure relay_sync
6. Configure spamassassin, secrets.cf go-rwx amavis:root
7. Configure amavis, 50-user go-rwx
8. Add clamav to the amavis group
9. Prepare TLS certificates
10. Configure dkim (see https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy)
11. Configure policy-spf
12. Configure opendmarc (see https://www.skelleton.net/2015/03/21/how-to-eliminate-spam-and-protect-your-name-with-dmarc/)
13. Configure cyrus, imapd.sasl go-rwx cyrus:root
14. Configure postfix
15. Add standard aliases to database (root, postmaster, hostmaster, abuse, webmaster, ...)
16. Add relay_sync to crontab

More to come?
-------------

* cyrus-caldav
