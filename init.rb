require 'redmine'
require_dependency 'redmine_oauth_engine/hooks'

Redmine::Plugin.register :redmine_oauth_engine do
  name 'Redmine OAuth ENGINE plugin'
  author 'Piotr Szymanski'
  description 'This is a plugin for Redmine registration through the ENGINE platform'
  version '0.0.1'
  url 'https://github.com/kasperrt/redmine_oauth_engine'
  author_url 'http://niedakh.net'

  settings :default => {
    :client_id => "",
    :client_secret => "",
    :oauth_autentification => false,
    :allowed_domains => ""
  }, :partial => 'settings/engine_settings'
end
