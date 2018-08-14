module AppHelper
  def get_related_apps(app, auth)
    categories = CGI.escape(app['customData']['category'].to_s)
    related_apps_url = URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=1&query={'status.value':'approved','customData.category': {'$in':" + categories + "}, 'appId':{'$ne':'"+app['appId']+"'}}&limit=3&sort={'randomize':1}")
    related_http = Net::HTTP.new(related_apps_url.host, related_apps_url.port)
    related_http.use_ssl = true
    ThirdpartyService.get_app_version(related_apps_url, auth, related_http)['list']
  end
end
