require 'redmine'
require_dependency 'redmine_oauth_dataporten/hooks'

Redmine::Plugin.register :redmine_oauth_dataporten do
  name 'Redmine OAuth Dataporten plugin'
  author 'Kasper Rynning-Tønnesen'
  description 'This is a plugin for Redmine registration through Dataporten'
  version '0.0.1'
  url 'https://github.com/kasperrt/redmine_oauth_dataporten'
  author_url 'http://kasperrt.no'

  settings :default => {
    :client_id => "",
    :client_secret => "",
    :oauth_autentification => false,
    :allowed_domains => ""
  }, :partial => 'settings/dataporten_settings'
end
