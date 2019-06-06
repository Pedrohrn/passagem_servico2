class CategoriasController < ApplicationController
	def service() ::CategoriasService; end

	def index
		respond_to do |format|
			format.html { layout.html }
			format.json{
				st, resp = service.index(get_params)

				case st
				when :success then render json: resp, status: :ok
				when :not_found then render json: resp, status: :not_found
				end
			}
		end
	end

	def show
		st, resp = service.show(get_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
	end
end