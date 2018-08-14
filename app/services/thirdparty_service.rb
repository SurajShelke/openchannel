class ThirdpartyService
  require 'net/http'
  require 'rest-client'

  def self.get_app_version(url, auth, http)
    begin
      req = Net::HTTP::Get.new(url.to_s, initheader = {'Content-Type' => 'application/json', 'Authorization' => auth})
      res = Net::HTTP.start(url.host, url.port) { |https|
        http.request(req)
      }
      return ActiveSupport::JSON.decode(res.body)
    rescue Exception => err
      puts "[13] ------ Exception: #{err.message}"
      []
    end
  end

  def self.get_json_version(url, auth, http)
    begin
      # req = Net::HTTP::Get.new(url.to_s, initheader = {'Content-Type' => 'application/json', 'Authorization' => auth})
      # res = Net::HTTP.start(url.host, url.port) { |https|
      #   http.request(req)
      # }
      # return ActiveSupport::JSON.decode(res.body)
      content = File.read("#{Rails.root}/tmp/openchannel.json")
      return ActiveSupport::JSON.decode(content)
    rescue Exception => err
      puts "[13] ------ Exception: #{err.message}"
      []
    end
  end

  def self.get_stats(url, auth, http)
    begin
      url = URI.parse(url);
      req = Net::HTTP::Get.new(url.to_s, initheader = {'Content-Type' => 'application/json', 'Authorization' => auth})
      res = Net::HTTP.start(url.host, url.port) { |https|
        http.request(req)
      }
      ActiveSupport::JSON.decode(res.body)
    rescue Exception => err
      puts "[27] ------ Exception: #{err.message}"
      []
    end
  end


  def self.set_lists(app)
    
    if ( app['customData']['files'] )
      app['customData']['fileList'] = app['customData']['files'].split(',')
    else
      app['customData']['fileList'] = [[]]
    end
    if ( app['customData']['images'] )
      app['customData']['imageList'] = app['customData']['images'].split(',')
    else
      app['customData']['imageList'] = [[]]
    end
    return app
  end

  def self.get_views(stats)
    views = 0
    stats.each do |s|
      views += s[1]
    end
    views
  end

  def self.get_app(url, auth, http, body)
    begin
      @req = Net::HTTP::Post.new(url.to_s, initheader = {'Content-Type' => 'application/json', 'Authorization' => auth})
      @req.body = ActiveSupport::JSON.encode(body)
      @res = Net::HTTP.start(url.host, url.port) { |https|
        http.request(@req)
      }
      return ActiveSupport::JSON.decode(@res.body)
    rescue Exception => err
      puts "[65]------ Exception: #{err.message}"
      []
    end
  end


  def self.publish_app(url, auth, http, app, version)
    body = {
      'developerId' => ENV['DEVELOPER_ID'],
      'version' => version
    }
    # Publish the created app
    begin
      @req = Net::HTTP::Post.new(url.to_s, initheader = {'Content-Type' => 'application/json', 'Authorization' => auth})
      @req.body = ActiveSupport::JSON.encode(body)
      @res = Net::HTTP.start(url.host, url.port) { |https|
        http.request(@req)
      }
      return ActiveSupport::JSON.decode(@res.body)
    rescue Exception => err
      puts "[85]------ Exception: #{err.message}"
      []
    end
  end


  def self.delete_app(url, auth, http)
    begin
      @req = Net::HTTP::Delete.new(url.to_s, initheader = {'Content-Type' => 'application/json', 'Authorization' => auth})
      @res = Net::HTTP.start(url.host, url.port) { |https|
        http.request(@req)
      }
      return ActiveSupport::JSON.decode(@res.body)
    rescue Exception => err
      puts "[99]------ Exception: #{err.message}"
      []
    end
  end

  def self.install_app(app_id, model_id, auth)
    begin
      response = RestClient.post(ENV['BASE_URL'] + '/v2/ownership/install' , { :appId => app_id, :userId => ENV['USER_ID'], :modelId => model_id }, { :Authorization => auth })
      return ActiveSupport::JSON.decode(response.body)
    rescue Exception => err
      puts "[109]------ Exception: #{err.message}"
      []
    end
  end

  def self.uninstall_app(app_id, ownership_id, auth)
    begin
      response = RestClient.post(ENV['BASE_URL'] + '/v2/ownership/uninstall/' + ownership_id ,{:userId => ENV['USER_ID']}, {:Authorization => auth })
      return ActiveSupport::JSON.decode(response.body)
    rescue Exception => err
      puts "[119] ------ Exception: #{err.message}"
      []
    end
  end
end
