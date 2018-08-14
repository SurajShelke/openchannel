module HomeHelper
  def get_api_url_by_params(params)
    category, search_text = params[:category_filter], params[:search_val]
    category = CGI.escape(category) if category.present?
    search_text = CGI.escape(search_text) if search_text.present?
    if (category.blank? || category == 'all') && search_text.blank?
      URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=" + ENV['USER_ID'] + "&query="+ CGI.escape("{'status.value':'approved'}")+"&sort="+ CGI.escape("{'randomize':1}"))
    elsif category.present? && category == 'myApps' && search_text.present?
      URI.parse(ENV['BASE_URL'] + "/v2/apps/textSearch?userId=" + ENV['USER_ID'] + "&query="+CGI.escape("{'status.value':'approved'}") + "&isOwner=true&text='" + search_text + "'&fields=" + CGI.escape("['name','customData.summary','customData.description']"))
    elsif category.present? && category == 'popular' && search_text.present?
      URI.parse(ENV['BASE_URL'] + "/v2/apps/textSearch?userId=" + ENV['USER_ID'] + "&query="+ CGI.escape("{'status.value':'approved'}") + "&sort=" + CGI.escape("{'stats.views.30day': -1}") + "&text='" + search_text + "'&fields="+CGI.escape("['name','customData.summary','customData.description']"))
    elsif category.present? && category == 'featured' && search_text.present?
      URI.parse(ENV['BASE_URL'] + "/v2/apps/textSearch?userId=" + ENV['USER_ID'] + "&query=" + CGI.escape("{'status.value':'approved','attributes.featured':'yes'}") + "&sort=" + CGI.escape("{'randomize':1}") + "&text='" + search_text + "'&fields=" + CGI.escape("['name','customData.summary','customData.description']"))
    elsif category.present? && category == 'myApps'
      URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=" + ENV['USER_ID'] + "&query=" + CGI.escape("{'status.value':'approved'}") + "&isOwner=true")
    elsif category.present? && category == 'popular'
      URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=" + ENV['USER_ID'] + "&query="+CGI.escape("{'status.value':'approved'}") + "&sort=" + CGI.escape("{'statistics.views.30day': -1}"))
    elsif category.present? && category == 'featured'
      URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=" + ENV['USER_ID'] + "&query=" + CGI.escape("{'status.value':'approved','attributes.featured':'yes'}") + "&sort=" + CGI.escape("{'randomize':1}"))
    elsif category.present? && search_text.blank?
      URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=" + ENV['USER_ID'] + "&query=" + CGI.escape("{'status.value':'approved','customData.category':'" + category + "'}") + "&sort=" + CGI.escape("{'randomize':1}"))
    elsif (category.blank? || category == 'all') && search_text.present?
      URI.parse(ENV['BASE_URL'] + "/v2/apps/textSearch?userId=" + ENV['USER_ID'] + "&query=" + CGI.escape("{'status.value':'approved'}") + "&text='" + search_text + "'&fields=" + CGI.escape("['name','customData.summary','customData.description']"))
    elsif category.present? && search_text.present?
      URI.parse(ENV['BASE_URL'] + "/v2/apps/textSearch?userId=" + ENV['USER_ID'] + "&query=" + CGI.escape("{'status.value':'approved','customData.category':'" + category + "'}") + "&text='" + search_text + "'&fields=" + CGI.escape("['name','customData.summary','customData.description']"))
    else
      URI.parse(ENV['BASE_URL'] + "/v2/apps?userId=" + ENV['USER_ID'] + "&query=" + CGI.escape("{'status.value':'approved'}&sort={'randomize':1}"))
    end
  end
end
  