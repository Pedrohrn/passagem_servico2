class PerfisController < ApplicationController
	def service() ::PerfisService; end

	def show
		st, resp = service.show({}, params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :error
		end
	end

	def create
		st, resp = service.create({}, perfis_params)

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

	def update
		st, resp = service.update({}, perfis_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :error
		end
	end

	def perfis_params
		attrs = [:id, :nome, :is_disabled]

		resp = params.require(:perfil).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

end