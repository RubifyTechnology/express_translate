class ExpressTranslate::Ajax::PackagesController < ActionController::Base

  # Include and require Libraries
  require 'redis'
  require 'json'
  require 'csv'
  include ExpressTranslate
  
  # Add package
  # Load html content when add Package
  def package_add
    load_content_package(Package.add(params))
  end
  
  # Update package
  # Load html content when update Package
  def package_update
    load_content_package(Package.update(params))
  end
  
  # Delete package
  # Load html content when delete Package
  def package_delete
    load_content_package(Package.delete(params[:id]))
  end
  
  private
  
  # Load packages html content
  # The firstly: check status for action add, update, delete package
    # render to html content for successful
    # render to json content for error
  def load_content_package(check)
    if check['success']
      @packages = Package.all
      render :action => :package_update
    else
      render :json => check
    end
  end
end