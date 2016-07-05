get 'oauth_dataporten', :to => 'redmine_oauth#oauth_dataporten'
get '_oauth2dataporten', :to => 'redmine_oauth#oauth_dataporten_callback', :as => 'oauth_dataporten_callback'
