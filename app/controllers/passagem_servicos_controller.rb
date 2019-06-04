class PassagemServicosController < ApplicationController
	def service() ::PassagemServicosService; end

	def index
		respond_to do |format|
			format.html { layout_erp }
			format.json{
				st, resp = service.index(get_params)

				case st
				when :success then render json: resp, status: :ok
				when :error then render json: resp, status: :ok
				end
			}
		end
	end

	def show
		st, resp = service.show(get_params)

		case st
		when :success then render json: resp, status: :ok
		when :not_found then render json: resp, status: :not_found
		end
	end

	private

	def passagem_service_params
		attrs = [:id, :status, :data_criacao]

		resp = params.require(:passagem_servico).permit(attrs).to_h
		resp.deep.symbolize.keys
	end
end