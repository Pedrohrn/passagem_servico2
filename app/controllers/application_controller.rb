class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	skip_before_action :verify_authenticity_token

	before_action :load_paths

	def get_params
		params_to_hash params.to_unsafe_h
	end

	private

	def layout_erp
		render html: "", layout: "layouts/application"
	end

	def load_paths
		Dir["#{Rails.root}/app/services/*"].each{ |file| require_dependency file }
	end
end
