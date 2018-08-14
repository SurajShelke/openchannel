class HomeController < ApplicationController
  before_action :set_list_url
  before_action :set_featured_app_url, only: [:index]
  before_action :set_http

  # for home page
  def index
    @featured_apps1 = ThirdpartyService.get_app_version(@featured_app_url, AUTH, @featured_http)
    
    # Uncomment following line in case line API doesn't return response
    # @featured_apps1 = ThirdpartyService.get_json_version(@featured_app_url, AUTH, @featured_http)
    unless @featured_apps1.empty?
      @featured_apps = @featured_apps1['list']
      
      @apps = ThirdpartyService.get_app_version(@url, AUTH, @http)['list']
      # Uncomment following line in case line API doesn't return response
      # @apps = ThirdpartyService.get_json_version(@url, AUTH, @http)['list']
    end
  end

  # for getting filtered apps with respect to category and text
  def filter_apps
    @apps = ThirdpartyService.get_app_version(@url, AUTH, @http)['list']
    filter_result = render_to_string(partial: 'home/app_list', layout: false)
    render json: { filter_result: filter_result }
  end

  private

  def set_list_url
    @url = helpers.get_api_url_by_params(params)
  end

  def set_featured_app_url    
    @featured_app_url = URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=" + ENV['USER_ID'] + "&query="+ CGI.escape("{'status.value':'approved','attributes.featured':'yes'}") + "&limit=4&sort=" + CGI.escape("{'randomize':1}"))
    @featured_http = Net::HTTP.new(@featured_app_url.host, @featured_app_url.port)
    @featured_http.use_ssl = true
  end

  def set_http
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end
end
