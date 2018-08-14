class Api::AppController < ApplicationController

  require 'net/http'
  require 'rest-client'

  before_action :set_create_url, only: :create
  before_action :set_update_url, only: :update
  before_action :set_body, only: [:create, :update]
  before_action :set_publish_url, only: :publish
  before_action :set_delete_url, only: :delete
  before_action :set_status_url, only: :status

  # Create app route
  def create
    @app = ThirdpartyService.get_app(@url, AUTH, @http, @body)
    # If error was returned, display error message and return
    if @app['code'] != nil
      session[:toast_type] = 'error'
      session[:toast_message] = @app['errors'][0]['message']
      redirect_to app_create_path
      return
    end
    if params[:publish] == 'true'
      url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + @app['appId'] + '/publish')
      @published_app = ThirdpartyService.publish_app(url, AUTH, @http, @app, @app['version'])

      # If error is retreived, display error message and return
      if @published_app['code'] != nil
        session[:toast_type] = 'error';
        session[:toast_message] = 'There was an error publishing the app. Please try again'
        redirect_to app_list_path
        return
      end
      # Display success message
      session[:toast_type] = 'publish';
      redirect_to app_list_path
      return
    end
    session[:toast_type] = 'create';
    redirect_to app_list_path
  end

  # Update app route
  def update
    @app = ThirdpartyService.get_app(@url, AUTH, @http, @body)
    # If error was retrieved, display error message and return
    if @app['code'] != nil
      session[:toast_type] = 'error'
      session[:toast_message] = @app['errors'][0]['message']
      redirect_to '/apps/update/' + params[:appId] + '/' + params[:version];
      return
    end
    if params[:publish] == 'true'
      url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + @app['appId'] + '/publish')
      @published_app = ThirdpartyService.publish_app(url, AUTH, @http, @app, @app['version'])

      # If error is retreived, display error message and return
      if @published_app['code'] != nil
        session[:toast_type] = 'error';
        session[:toast_message] = 'There was an error publishing the app. Please try again later'
        redirect_to app_list_path
        return
      end
      # Display success message
      session[:toast_type] = 'publish';
      redirect_to app_list_path
      return
    end
    session[:toast_type] = 'update';
    redirect_to app_list_path
  end

  # Publish app route
  def publish
    @published_app = ThirdpartyService.publish_app(@url, AUTH, @http, @app, params[:version].to_i)

    if @published_app['code'] != nil
      session[:toast_type] = 'error';
      session[:toast_message] = 'There was an error publshing the app. Please try again later'
      redirect_to app_list_path
      return
    end
    # Display success message
    session[:toast_type] = 'publish';
  end

  # Delete app route
  def delete
    @deleted_app = ThirdpartyService.delete_app(@url, AUTH, @http)
    if @deleted_app['code'] != nil
      session[:toast_type] = 'error'
      session[:toast_message] = @deleted_app['errors'][0]['message']
      redirect_to app_list_path
      return
    end
    session[:toast_type] = 'delete';
  end

  # Suspend or unsuspend route
  def status
    @app = ThirdpartyService.get_app(@url, AUTH, @http, @body)
    if @app['code'] != nil
      session[:toast_type] = 'error'
      session[:toast_message] = @app['errors'][0]['message']
      redirect_to app_list_path
      return
    end
    # Display success message
    session[:toast_type] = 'status'
    session[:toast_message] = 'App ' + params[:status] + 'ed successfully'
  end

  # File upload route
  def upload
    file = params[:file]
    result = ActiveSupport::JSON.decode( RestClient.post(ENV['BASE_URL'] + '/v2/files', { :file => File.new(file.path) }, { :Authorization => AUTH }) )
    render :plain => result['fileUrl']
  end


  private

  def set_create_url
    @url = URI.parse(ENV['BASE_URL'] + '/v2/apps')
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end

  def set_body
    images = params[:images].split(",")
    files = params[:files].split(",")
    @body = {
      'developerId' => ENV['DEVELOPER_ID'] ,
      'name' => params[:name],
      'customData' => {summary: params[:summary],description: params[:description],icon: params[:icon],images: images,files: files,category: params[:category],website: params[:website],video: params[:video]}
    }
  end

  def set_update_url
    @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + params[:appId] + '/versions/' + params[:version])
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end

  def set_publish_url
    @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + params[:appId] + '/publish')
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end


  def set_delete_url
    # If version is set, delete that version
    if params[:version] != nil
      @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + params[:appId] + '/versions/' + params[:version].to_s + '?developerId=' + ENV['DEVELOPER_ID'])
      # If version is not set, delete all app versions
    else
      @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + params[:appId] + '?developerId=' + ENV['DEVELOPER_ID'])
    end
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end


  def set_status_url
  	@body = {
      'developerId' => ENV['DEVELOPER_ID'],
      'status' => params[:status]
    }
    @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + params[:appId] + '/status')
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end
end
