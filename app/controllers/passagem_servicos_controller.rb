class PassagemServicosController < ApplicationController
	def service() ::PassagemServicosService; end

	def index
		respond_to do |format|
			format.html { layout_erp }
			format.json{
				st, resp = service.index({}, get_params)

				case st
				when :success then render json: resp, status: :ok
				when :error then render json: resp, status: :error
				end
			}
		end
	end

	def show
		st, resp = service.show({}, get_params)

		case st
		when :success then render json: resp, status: :ok
		when :not_found then render json: resp, status: :not_found
		end
	end

	def create
		st, resp = service.submit({}, passagem_service_params)

		case st
		when :success then render json: resp, status: :ok
		end
	end

	def update
		st, resp = service.update({}, passagem_service_params)

		case st
		when :success then render json: resp, status: :ok
		end
	end

	def destroy
		st, resp = service.destroy({}, passagem_service_params)

		case st
		when :success then render json: resp
		end
	end

	private

	def passagem_service_params
		attrs = [:id, :status, :data_criacao, :observacoes]
		attrs << {pessoa_saiu: [:id]}
		attrs << {pessoa_entrou: [:id]}

		resp = params.require(:passagem_servico).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

end