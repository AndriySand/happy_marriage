class RegistrationsController < Devise::RegistrationsController

  def json_create
    sign_up_params = params.select{|k,v| (k != 'action' && k != 'controller' && k != 'registration' && k != 'user')}
    build_resource(sign_up_params)
    if resource.save
      render :json => { :meta => { :success => true,
                                   :count => 1,
                                   :totalCount => User.all.size,
                                   :countPerPage => 1,
                                   :pageIndex => 1,
                                   :totalPageCount => 1 },
                        :data => [ { :user => { :id => resource.id,
                                                :email => resource.email,
                                                :name => resource.name
                                              }
                                    }
                                  ]
                      }
    else
      render 'failure', :locals => { :error_description => errors_of_object(resource) }
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

end