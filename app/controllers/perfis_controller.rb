class PerfisController < ApplicationController
	def service() ::PerfisService; end

	def index
		respond_to do |format|
			format.json{
				st, resp = service.index({}, get_params)

				case st
				when :success then render json: resp, status: :ok
				when :error then render json: { errors: resp }, status: :error
				end
			}
		end
	end

	def show
		st, resp = service.show({}, params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def create
		st, resp = service.create({}, perfis_params)

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

	def micro_update
		st, resp = service.micro_update({}, micro_update_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def update
		st, resp = service.update({}, perfis_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def perfis_params
		attrs = [:id, :nome, :is_disabled]
		attrs << {
			objetos: [
				:id,
				:_destroy,
				categoria: [:id],
				itens: [ :item_name, :item_qtd ]
			],
		}

		resp = params.require(:perfil).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

	def micro_update_params
		attrs = [:id, :desativado_em, :micro_update_type]

		resp = params.require(:perfil).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

end