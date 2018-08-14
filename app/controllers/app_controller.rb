class AppController < ApplicationController
  before_action :set_list_url, only: :list
  before_action :set_update_url, only: :update
  before_action :set_create_url, only: :create
  before_action :set_detail_url, only: :details
  before_action :set_http, except: [:install, :uninstall]

  def list
    @apps = ThirdpartyService.get_app_version(@url, AUTH, @http)['list']
    @statistics = ThirdpartyService.get_stats(@base_url, AUTH, @http)
    @views = ThirdpartyService.get_views(@statistics)
  end

  def create
  end

  #Edit page
  def update
    @app = ThirdpartyService.get_app_version(@url, AUTH, @http)
    @app = ThirdpartyService.set_lists(@app)
    @statistics = ThirdpartyService.get_stats(@base_url, AUTH, @http)
    @views = ThirdpartyService.get_views(@statistics)
  end

  # App detail page
  def details
    @app = ThirdpartyService.get_app_version(@url, AUTH, @http)
    @images = @app["customData"]["images"] if @app["customData"]["images"].present?
    @related_apps = helpers.get_related_apps(@app, AUTH)
  end

  def install
    @app = ThirdpartyService.install_app(params[:app_id], params[:model_id], AUTH)
    render json: { data: @app, success: true }
  end

  def uninstall
    ThirdpartyService.uninstall_app(params[:app_id], params[:ownership_id], AUTH)
    render json: { success: true }
  end

  private

  def set_list_url
    @url = URI.parse(ENV['BASE_URL'] + "/v2/apps/versions?developerId=1&query=" + CGI.escape('{$or: [{"status.value":"rejected",isLatestVersion:true},{isLive:true},{"status.value":{$in:["inDevelopment","inReview","pending"]}}]}'))
    @base_url= ENV['BASE_URL'] + '/v2/stats/series/month/views?query='+CGI.escape('{developerId: "1"}')
  end

  def set_update_url
    @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + params[:appId] + '/versions/' + params[:version] + '?developerId=' + ENV['DEVELOPER_ID'])
    @base_url = ENV['BASE_URL'] + '/v2/stats/series/month/views?query='+CGI.escape('{developerId: "1", appId: "' + params[:appId].to_s + '"}')
  end

  def set_create_url
    @url = URI.parse(ENV['BASE_URL'] + '/v2/apps')
  end

  def set_detail_url
    if params[:version].present?
      @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/' + params[:app_id] + '/versions/' + params[:version] + '?trackViews=true&userId=' + ENV['USER_ID'])
    else
      @url = URI.parse(ENV['BASE_URL'] + '/v2/apps/bySafeName/' + params[:app_safe_name] + '?trackViews=true&userId=' + ENV['USER_ID'])
    end
  end

  def set_http
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end
end
