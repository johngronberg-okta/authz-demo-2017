## Setup

### Configure Authorization Server in Okta
1. Navigate to your default authorization server (Security > API > Authorization Servers > default)
2. Create 2 new scopes by opening the scopes tab, then clicking “Add Scope”
	
	Scope 1
	* Name: "profile:read" 
	* Display Name: "Access your profile and billing information”
	* Description: "This scope allows an application to access CRM data on your behalf"
	* User consent: checked
	* Default scope: NOT checked
	
	Scope 2
	* Name: "usage:read" 
	* Display Name: "Access your solar panel information”
	* Description: "This will allow an application to read information about your solar panels production and consumption"
	* User consent: checked
	* Default scope: NOT checked

3. Ensure you have an access policy configured for all clients that allows access to all scopes (or at least the `profile:read` and `usage:read` scopes)

### Configure OIDC App in Okta
1. In your Okta developer org admin panel, navigate to applications > Add Application
2. Click create new app
3. Select "SPA" and OpenID Connect, click next
4. Enter the following:
	* Application Name: "PG&E"
	* App Logo: upload a small, square logo
	* Login Redirect URI: http://localhost:54321
5. Click "Save"
6. Click "Assignments" and assign the app to the "everyone" group. 

Note: you can also edit the app to include TOS and Policy URIs if you want those to be displayed on the consent screen

### Configure and Run Application
0. install yarn
    - `curl -o- -L https://yarnpkg.com/install.sh | bash`
    - if you dont have yarn, use `npm` instead of `yarn` at following steps.
1. install node-6.x or higher
2. `yarn install`
3. change the `.sample.config.json` at your convenience.
3. `yarn start`

## TODO

1. [ ] loading spinner when fetching userinfo.
