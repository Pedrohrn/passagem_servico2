class CategoriasController < ApplicationController
	def service() ::CategoriasService; end

	def index
		respond_to do |format|
			format.json{
				st, resp = service.index({}, get_params)

				case st
				when :success then render json: resp, status: :ok
				when :not_found then render json: { errors: resp }, status: :not_found
				end
			}
		end
	end

	def submit
		st, resp = service.submit({}, categorias_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def micro_update
		st, resp = service.micro_update({}, micro_update_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def destroy
		st, resp = service.destroy({}, params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def categorias_params
		attrs = [:id, :nome, :is_disabled]

		resp = params.require(:categoria).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

	def micro_update_params
		attrs = [:id, :is_disabled, :desativada_em, :micro_update_type]

		resp = params.require(:categoria).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

end