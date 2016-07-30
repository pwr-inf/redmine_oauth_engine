require 'account_controller'
require 'json'

class RedmineOauthController < AccountController
  include Helpers::MailHelper
  include Helpers::Checker
  def oauth_engine
    if Setting.plugin_redmine_oauth_engine[:oauth_authentification]
      session[:back_url] = params[:back_url]
      redirect_to oauth_client.auth_code.authorize_url(:redirect_uri => oauth_engine_callback_url)
    else
      password_authentication
    end
  end

  def authorization(client_id, client_secret)
    'Basic ' + Base64.encode64(client_id + ':' + client_secret).gsub("\n", '')
  end

  def oauth_engine_callback
    if params[:error]
      flash[:error] = l(:notice_access_denied)
      redirect_to signin_path
    else
      token = oauth_client.auth_code.get_token(params[:code], :redirect_uri => oauth_engine_callback_url, :headers => { 'Authorization' => authorization(settings[:client_id], settings[:client_secret])})
      result = token.get('https://sso.datasciencegroup.pl/user')
      info = JSON.parse(result.body)
      if info
        try_to_login info
      else
        flash[:error] = l(:notice_unable_to_obtain_engine_credentials)
        redirect_to signin_path
      end
    end
  end

  def try_to_login info
   params[:back_url] = session[:back_url]
   session.delete(:back_url)
   user = User.joins(:email_addresses).where(:email_addresses => { :address => info["user"]["email"] }).first_or_create
    if user.new_record?
      # Self-registration off
      redirect_to(home_url) && return unless Setting.self_registration?
      # Create on the fly
      user.firstname = info["principal"]["name"]
      user.lastname  = info["principal"]["surname"] 
      user.mail = info["principal"]["email"]
      user.login = info["principal"]["username"]
      user.login ||= [user.firstname, user.lastname]*"."
      user.random_password
      user.register

      case Setting.self_registration
      when '1'
        register_by_email_activation(user) do
          onthefly_creation_failed(user)
        end
      when '3'
        register_automatically(user) do
          onthefly_creation_failed(user)
        end
      else
        register_manually_by_administrator(user) do
          onthefly_creation_failed(user)
        end
      end
    else
      # Existing record
      if user.active?
        successful_authentication(user)
      else
        # Redmine 2.4 adds an argument to account_pending
        if Redmine::VERSION::MAJOR > 2 or
          (Redmine::VERSION::MAJOR == 2 and Redmine::VERSION::MINOR >= 4)
          account_pending(user)
        else
          account_pending
        end
      end
    end
  end

  def oauth_client
    @client ||= OAuth2::Client.new(settings[:client_id], settings[:client_secret],
      :site => 'https://sso.datascience.pl',
      :authorize_url => '/oauth/authorize',
      :token_url => '/oauth/token')
  end

  def settings
    @settings ||= Setting.plugin_redmine_oauth_engine
  end

end
