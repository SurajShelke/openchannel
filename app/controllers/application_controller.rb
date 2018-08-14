class ApplicationController < ActionController::Base
  AUTH = ActionController::HttpAuthentication::Basic.encode_credentials(ENV['MARKETPLACE_ID'], ENV['SECRET'])
	protect_from_forgery with: :exception
	before_action :check_api_credentials

	private

	def check_api_credentials
		if !ENV['MARKETPLACE_ID'].present?
			render "layouts/marketplaceid_and_secret_error"
		end
	end
end
