class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery except: [:new, :edit, :create, :update]
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_filter :verify_authenticity_token, if: :format_json?
  ADMIN_MESSAGE = 'You must be an administrator to do that'

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name << :age << :gender << :profession << :phone << :companyName
  end

  def if_first_visit_of_user_then_redirect
    if current_user.first_visit == true
      current_user.first_visit = false
      current_user.generated_password = nil
      current_user.save
      reset_session
      flash[:notice] = "Letter with password was sent to your email"
      redirect_to new_user_session_path
    end
  end

  def format_json?
    request.format.json?
  end

  def errors_of_object(object_name)
    errors = object_name.errors.messages
    if errors.size > 1
      errors = "You didn't fill in couple of fields"
    else
      errors = errors.to_a.flatten.join(' ')
    end
  end

  def current_user_admin?
    current_user.admin?
  end

  def authenticate_admin!
    unless current_user_admin?
      respond_to do |format|
        flash[:error] = ADMIN_MESSAGE
        format.html { redirect_to articles_path }
        format.json { render 'articles/failure', :locals => { :error_description => ADMIN_MESSAGE } }
      end
    end
  end

end
