# Manage users in your Organisation

!!! Info
    _org-admin_ profile or at least the permission _manageUser_ is required to manage users in your organisation.


## List of users

In your organisation, click on _Organisation_ in the menu on the left to access the list of users. The first tab is _Users_.

![](./images/organisation-list-users.png)

Click the :fontawesome-regular-square-plus: button to add a new account to the current Organsation.

## User information

To access detailed information about a user, click the _Preview_ button

![](./images/organisation-user-details.png)

### Configuration parameters 

Avatar
  : Update the avatar associated with the user by drag&drop a new file (PNG or JPG files).

Login
  : User login

Email
  : email address of the user. _Login_ is used if no email is filled there

Type
  : Type of the account. _Normal_ or _Service_. A _Service_ account cannot open interactive session

Locked
  : Block a user from logging in the application

MFA
  : Tells if a user has configured MFA or not (_Multi Factor Authentication_). If yes, _Yes_ is displayed

API Key
  : Define, Renew, Reveal or Revoke API key of the account

Profile
  : Information about the profile given to the user

Permissions
  : List of permissions included in the profile

Password
  : Create of update the password of the user

Reset Password
  : If the application is configured with a [SMTP server](../../administration/smtp.md), send an email with a magic link to the user

Sessions
  : List of opened interactive sessions. Click delete to close a session


## Add Users

*org-admin* users or users with the role `manageUser` in their profile can add users in the current Organisation. 

Click the :fontawesome-regular-square-plus: button to add an account, and follow *[create an account](../../administration/accounts.md#create-an-account)* and *[update an account](../../administration/accounts.md#update-an-account)* guides.

## User management

Accounts can be deleted or locked, only in the current organisation.
