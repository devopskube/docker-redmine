require 'redmine'
require 'redmine_openid_connect/application_controller_patch'
require 'redmine_openid_connect/account_controller_patch'
require 'redmine_openid_connect/hooks'

Redmine::Plugin.register :redmine_openid_connect do
  name 'Redmine Openid Connect plugin'
  author 'Alfonso Juan Dillera'
  description 'OpenID Connect implementation for Redmine'
  version '0.9.1'
  url 'http://bitbucket.org/intelimina/redmine_openid_connect'
  author_url 'http://github.com/adillera'

  settings :default => {
    :enabled => {{OPENDID_ENABLED}},
    :client_id => '{{OPENID_CLIENT_ID}}',
    :openid_connect_server_url => '{{KEYCLOAK_PROTOCOL}}://{{KEYCLOAK_HOST}}/auth/realms/devopskube',
    :client_secret => '{{OPENID_CLIENT_SECRET}}',
    :group => '{{OPENID_USER_GROUP}}',
    :admin_group => '{{OPENID_ADMIN_GROUP}}',
    :dynamic_config_expiry => 86400,
    :disable_ssl_validation => {{OPENID_DISABLE_SSL_VALIDATION}},
  }, partial: 'settings/redmine_openid_connect_settings'
end

Rails.configuration.to_prepare do
  ApplicationController.send(:include, RedmineOpenidConnect::ApplicationControllerPatch)
  AccountController.send(:include, RedmineOpenidConnect::AccountControllerPatch)
end
