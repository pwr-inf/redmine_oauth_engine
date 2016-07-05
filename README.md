# redmine_oauth_dataporten

## (This repository is made from https://github.com/twinslash/redmine_omniauth_google)

This plugin is used to authenticate Redmine users using Dataportens's OAuth2 provider.

### Installation:

Download the plugin and install required gems:

```console
cd /path/to/redmine/plugins
git clone https://github.com/kasperrt/redmine_oauth_dataporten.git
cd /path/to/redmine
bundle install
```

Restart the app
```console
touch /path/to/redmine/tmp/restart.txt
```

### Registration

To authenticate via Dataporten you must first register your redmine instance via the Dataporten Dashboard

* Go to the [registration](https://dashboard.dataporten.no) link.
* Enter "https://mydomain.com/redmine/_oauth2dataporten", where "mydomain.com/redmine" is the domain / path for your redmine instance. *** The plugin will not work without this setting ***
* Save the Client ID and Client Secret for the configuration of the Redmine plugin (see below)

### Configuration

* Login as a user with administrative privileges.
* In top menu select "Administration".
* Click "Plugins"
* In plugins list, click "Configure" in the row for "Redmine OAuth Dataporten plugin"
* Enter the Сlient ID & Client Secret shown when you registered your application via Dataporten Dashboard.
* Check the box near "Oauth authentication enabled"
* Click Apply.

Users can now to use their Dataporten Account to log in to your instance of Redmine.

Additionaly
* Setup value Autologin in Settings on tab Authentification


With the above configuration, only users with email addresses on the domains "onedomain.com" and "otherdomain.com" will be allowed to acccess your Redmine instance using Google OAuth.

### Authentication Workflow

1. An unauthenticated user requests the URL to your Redmine instance.
2. User clicks the "Login via Google" buton.
3. The plugin redirects them to a Dataporten sign in page if they are not already signed in to their Dataporten account.
4. Dataporten redirects user back to Redmine, where the Dataporten OAuth plugin's controller takes over.

One of the following cases will occur:
1. If self-registration is enabled (Under Administration > Settings > Authentication), user is redirected to 'my/page'
2. Otherwse, the an account is created for the user (referencing their Dataporten OAuth2 ID). A Redmine administrator must activate the account for it to work.
