class MyController < ApplicationController
  
  def params
    @blobject_params ||= blobject(super)
  end
  
  
  def create
    model = find_model
    
    data = params.user_data
    
    if params.has_password?

      log("UPDATED: " + data.email)

      model.update_attributes(data)
      respond_with model
    end
    
    redirect_to 'http://rickroller.com'
  end
end