Role
* name

User
* email
* encrypted_password
* role_id

Domain
* name

Membership
* user_id
* mailbox_id

Mailbox
* email
* mailbox_type (primary, shared, alias)
* alias_of_id
* domain_id

MailThread
* mailbox_id
* subject

Mail
* mail_thread_id
* from
* to
* cc
* bcc
* subject
* plain_body
* html_body
* mail_label_ids

MailLabel
* name
* primary
