class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :user_signed_in?

  before_filter :reload_libs if Rails.env.development?
  before_filter :require_login

  private
    def reload_libs
      Dir["#{Rails.root}/lib/**/*.rb"].each { |path| require_dependency path }
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def user_signed_in?
      return 1 if current_user
    end

    def require_login
      unless current_user
        flash[:error] = 'You need to sign in before accessing this page!'
        redirect_to :root
      end
    end
end
