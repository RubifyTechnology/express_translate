class RubifyLanguages::Ajax::PackagesController < ActionController::Base
  require 'redis'
  require 'json'
  require 'csv'
  include RubifyLanguages
  
  def package_add
    load_content_package(Package.add(params))
  end
  
  def package_update
    load_content_package(Package.update(params))
  end
  
  def package_delete
    load_content_package(Package.delete(params[:id]))
  end
  
  private
  
  def load_content_package(check)
    if check['success']
      @packages = Package.all
      render :action => :package_update
    else
      render :json => check
    end
  end
end