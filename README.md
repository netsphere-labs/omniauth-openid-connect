# A new joint project launched

I am pleased to inform you.

The original `omniauth-openid-connect` package has been not maintained long a long time. So many many forks have been created and maintained individually.

On 29th January 2022, some repository maintainers agreed to create a new joint project and consolidate our projects there.
The new project is here: 
  https://github.com/omniauth/omniauth_openid_connect/
This is a part of the OmniAuth project.
I (Horikawa) also participate.

My project has a large number of changes, so a bit of time is needed until that changes are merged into a new project. And then, I will archive mine.

The new project is open. We welcome your participation. Thank you.



# OmniAuth::OpenIDConnect renewed

Authentication strategy using OpenID Connect for OmniAuth2. 

[![Maintainability](https://api.codeclimate.com/v1/badges/15feb4c312e95c116ede/maintainability)](https://codeclimate.com/github/netsphere-labs/omniauth-openid-connect/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/15feb4c312e95c116ede/test_coverage)](https://codeclimate.com/github/netsphere-labs/omniauth-openid-connect/test_coverage)
[![Build Status](https://travis-ci.com/netsphere-labs/omniauth-openid-connect.svg?branch=master)](https://travis-ci.com/netsphere-labs/omniauth-openid-connect)


The original is [jjbohn/omniauth-openid-connect](https://github.com/jjbohn/omniauth-openid-connect). I gathered the changes that were scattered in many places and integrated them here. In particular, [Shopify/omniauth-identity](https://github.com/Shopify/omniauth-identity), [patatoid/omniauth-openid-reconnect](https://github.com/patatoid/omniauth-openid-reconnect) and [m0n9oose/omniauth_openid_connect](https://github.com/m0n9oose/omniauth_openid_connect). 

This package is the successor to the following: 
 - omniauth-google-oauth2
 - omniauth-yahoojp
 - omniauth-azure-oauth2
 - omniauth-azure-adv2
 - omniauth-line 
 - omniauth-line-openid-connect
 - omniauth-salesforce

**Important:** OmniAuth v1.9.1 and earlier is vulnerable to Cross-Site Request Forgery. Application developers need to avoid this vulnerability. See [CVE-2015-9284](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-9284), [Resolving CVE 2015 9284 · omniauth/omniauth Wiki](https://github.com/omniauth/omniauth/wiki/Resolving-CVE-2015-9284).



## OpenID Connect

If you use the raw OAuth 2.0 for *authentication* purposes, it will cause a huge security vulnerability. The OAuth 2.0 is a mechanism for *authorization* and does not identify who the access token belongs to. Therefore, there is a risk of token hijacking.

Each company has created its countermeasures. OpenID Connect is a standardized, simple identity layer on top of the OAuth 2.0 protocol. By using OpenID Connect, we don't need to implement variety extensions of each company.

OpenID Connect uses a mechanism `id_token`. In addition to `access_token`, the authentication server and clients exchange 
the `id_token`, and verifying the signature and nonce makes preventing spoofing.

There is no technical continuity with OpenID 2.0 and OpenID Connect. Only names are similar.
For more information on OpenID Connect, see [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html).



## Features

<i>OmniAuth::OpenIDConnect renewed</i> is tested under Ruby v2.5, v2.6, v2.7 and v3.0.

Single Sign-On: OpenID Connect Core 1.0 the Authorization Code Flow and the Implicit Flow.
Single Logout (SLO): OpenID Connect RP-Initiated Logout 1.0.


## Tested OpenID Providers

|Organization  |Implementation   |Note            |
|--------------|-----------------|----------------|
|Google        |Google Identity Platform |[Developer's Guide](https://developers.google.com/identity/protocols/oauth2/openid-connect)  |
|Yahoo! JAPAN  |Yahoo! ID連携 v2          |[Developer's Guide](https://developer.yahoo.co.jp/yconnect/v2/) |
|Microsoft     |Azure Active Directory (v1), Microsoft ID Platform (v2)  |[Understand the OpenID Connect authentication code flow in Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols) |
|nov           |OpenID Connect OP sample |[Sample Application](https://github.com/netsphere-labs/openid_connect_sample) |
|Red Hat       |Keycloak           |[Securing Applications](https://www.keycloak.org/docs/latest/securing_apps/)|

<s>(2017-09) As of now, Azure AD doesn't meet the OpenID Connect specification. You must set `true` of  `:send_client_secret_to_token_endpoint` option.</s> (2020.6) OmniAuth::OpenIDConnect v0.8 has configured automatically for Azure AD. Simply set the option `discovery:true`.




## Installation

This repository is a forked version. You can install gem file locally.
Clone this repository:

    $ git clone https://github.com/netsphere-labs/omniauth-openid-connect.git
    $ cd omniauth-openid-connect
    $ git checkout v0.8.1.pre
    $ rake build
    omniauth-openid-connect 0.8.1.pre built to pkg/omniauth-openid-connect-0.8.1.pre.gem.
    $ su
    # rake install:local
    omniauth-openid-connect (0.8.1.pre) installed.
    # gem list omniauth-openid-connect
    omniauth-openid-connect (0.8.1.pre)



Gemfile:

```ruby
    # 認証系
    gem "omniauth"

    # Facebook OAuth2 Strategy for OmniAuth
    # https://github.com/mkdynamic/omniauth-facebook
    gem "omniauth-facebook"

    # OpenID Connect対応
    # googleはこちら。
    gem 'openid_connect', '1.1.5'   # バージョン固定.
    gem "omniauth-openid-connect"
```


And then execute:

    $ bundle

    



## Usage

A sample Rails + OmniAuth program: https://gitlab.com/netsphere/rails-omniauth-oidc-rp-sample/
(1) OpenID Connect Authorization Code Flow によるログイン, (2) 同 Implicit Flow によるログイン. (3) OpenID Connect RP-Initiated Logout 1.0 によるシングルログアウト (SLO).

Manual: https://www.nslabs.jp/omniauth-openid-connect.rhtml


### Options Overview

| Field                        | Description                         | Required | Default                           |
|------------------------------|-------------------------------------|----------|-----------------------------------|
| name     [Symbol or String]  | Arbitrary string to identify connection and identify it from other openid_connect providers <br />`:my_idp`                            | Yes       | `'openid_connect'`                                                  |
| `issuer` [String]              | IdP identifier URI     <br />`https://auth.login.yahoo.co.jp/yconnect/v2`                                                              | Yes       | --                              |
| `discovery`                    | Should OpenID discovery be used. This is recommended if the IdP provides a discovery endpoint. See client config for how to manually enter discovered values. <br />one of: true, false | no       | false                                                   |
| `client_auth_method`           | Which authentication method to use to authenticate your app with the authorization server's token endpoint <br />`:basic`, `:secret_in_body`                  | no       | Sym: basic                                                  |
| scope                        | Which OpenID scopes to include (`:openid` is always required)  <br />[:openid, :profile, :email]                                                                                                 | no       | Array<sym> [:openid]                          |
| response_type                | Which OAuth2 response type to use with the authorization request. <br />one of: 'code', ['id_token', 'token']  <br />**Security note:** Do not use 'token' or 'id_token'. The 'token' (raw OAuth 2.0) MUST NOT be used for the authentication purpose. The 'id_token' is used only for the Self-Issued OpenID Providers. Instead, use ['id_token', 'token'] (the Implicit Flow).              | no       | String: code                                       |
| state                        | A value to be used for the OAuth2 state parameter on the authorization request. Can be a proc that generates a string. <br />`Proc.new {SecureRandom.hex(32)}`                                       | no       | Random 16 character string                    |
| `response_mode`                | The response mode per [OAuth 2.0 Form Post Response Mode](https://openid.net/specs/oauth-v2-form-post-response-mode-1_0.html) <br />one of: :query, :fragment, :form_post, :web_message                                                             | No. [NOT RECOMMENDED]  | nil                       |
| display                      | An optional parameter to the authorization request to determine how the authorization and consent page <br />one of: :page, :popup, :touch, :wap                                                        | no       | nil                                        |
| prompt                       | An optional parameter to the authrization request to determine what pages the user will be shown   <br />one of: :none, :login, :consent, :select_account                                                            | no       | nil                          |
| send_scope_to_token_endpoint | Should the scope parameter be sent to the authorization token endpoint?    <br />one of: true, false                                                                                   | no       | true                                                       |
| `post_logout_redirect_uri`     | The redirect-back URI after IdP's logout. To use per the [OpenID Connect RP-Initiated Logout 1.0](https://openid.net/specs/openid-connect-rpinitiated-1_0.html) <br />`https://myapp.com/logout/callback`                                  | no       | empty                                         |
| uid_field                    | The field of the user info response to be used as a unique id  <br />"sub", "preferred_username"                                                                                               | no       | 'sub'                                        |
| client_options               | A hash of client options detailed in its own section                                                                                                          | yes      |                                                                         |


### Additional Configuration Notes

  * `name` is arbitrary, I recommend using the name of your provider. The name
  configuration exists because you could be using multiple OpenID Connect
  providers in a single app.

  **NOTE**: if you use this gem with Devise you should use `:openid_connect` name,
  or Devise would route to 'users/auth/:provider' rather than 'users/auth/openid_connect'

  * `response_type` tells the authorization server which grant type the application wants to use,
  currently, only `'code'` (Authorization Code grant) and `['id_token', 'token']` (Implicit grant) are valid.
  Do not use `id_token`. This is valid only under Self-Issued OpenID Providers.

  * If you want to pass `state` paramete by yourself. You can set Proc Object.
  e.g. `state: Proc.new { SecureRandom.hex(32) }`

  * ON Authorization Code Flow, `nonce` is optional. If you don't want to pass the "nonce" parameter to provider, you should specify
  `false` to `send_nonce` option (default true). On Implicit Flow, the `nonce` is required. `send_nonce` option is ignored.




### Client Config Options

These are the configuration options for the `client_options` hash of the configuration.

| Field                  | Description                                                     | Default    | Replaced by discovery? |
|------------------------|-----------------------------------------------------------------|------------|------------------------|
| identifier             | The OAuth2 client_id                                            |            |                        |
| secret                 | The OAuth2 client secret                                        |            |                        |
| redirect_uri           | The OAuth2 authorization callback url in your app               |            |                        |
| scheme                 | The http scheme to use. If not set, built by `options.issuer`   | https      |                        |
| host                   | The host of the authorization server. If not set, built by `options.issuer`    | nil  |               |
| port                   | The port for the authorization server. If not set, built by `options.issuer`   | nil  |               |
| authorization_endpoint | The authorize endpoint on the authorization server              | /authorize | yes                    |
| token_endpoint         | The token endpoint on the authorization server                  | /token     | yes                    |
| userinfo_endpoint      | The user info endpoint on the authorization server              | /userinfo  | yes                    |
| expires_in             |                                                                 | nil        |                        |


These are strategy's options.

| Field                  | Description                                                     | Default    | Replaced by discovery? |
|------------------------|-----------------------------------------------------------------|------------|------------------------|
| jwks_uri               | The `jwks_uri` on the authorization server                      | /jwk       | yes                    |
| end_session_endpoint   | The url to call to log the user out at the authorization server. See <i>OpenID Connect RP-Initiated Logout 1.0</i> | nil  | yes   |



### Metadata Discovery

See [OpenID Connect Discovery 1.0](https://openid.net/specs/openid-connect-discovery-1_0.html)

  * If the provider supports "OpenID Connect Discovery", You should specify `true` to `discovery` option. (default false)

  * In the "OpenID Connect Discovery", generally provider has Webfinger endpoint.
  If provider does not have Webfinger endpoint, You can specify "Issuer" to option.
  e.g. `issuer: "https://myprovider.com"`
  It means to get configuration from "https://myprovider.com/.well-known/openid-configuration".
  * The uid is by default using the `sub` value from the `user_info` response,
  which in some applications is not the expected value. To avoid such limitations, the uid label can be
  configured by providing the omniauth `uid_field` option to a different label (i.e. `preferred_username`)
  that appears in the `user_info` details.
  * The `issuer` property should exactly match the provider's issuer link.

  * Some OpenID Connect providers require the `scope` attribute in requests to the token endpoint, even if
  this is not in the protocol specifications. In those cases, the `send_scope_to_token_endpoint`
  property can be used to add the attribute to the token request. Initial value is `true`, which means that the
  scope attribute is included by default.




## Contributing

1. Fork it ( https://github.com/netsphere-labs/omniauth-openid-connect )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Cover your changes with tests and make sure they're green (`bundle install && bundle exec rake test`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
