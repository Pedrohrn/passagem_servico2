class CategoriasController < ApplicationController
	def service() ::CategoriasService; end

	def index
		respond_to do |format|
			format.html { layout.html }
			format.json{
				st, resp = service.index({}, get_params)

				case st
				when :success then render json: resp, status: :ok
				when :not_found then render json: resp, status: :not_found
				end
			}
		end
	end

	def create
		st, resp = service.create({}, categorias_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :error
		end
	end

	def update
		st, resp = service.update({}, categorias_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :error
		end
	end

	def destroy
		st, resp = service.destroy({}, params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :error
		end
	end

	def categorias_params
		attrs = [:id, :nome, :is_disabled]

		resp = params.require(:categoria).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

end