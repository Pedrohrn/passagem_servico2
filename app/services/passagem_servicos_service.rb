class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index
		list = PassagemServico.map(&:to_frontend_obj)

		resp = { list: list }

		[:success, resp]
	end

	def self.show(params)
		passagem = model.find_by(id: params[:id]) || {}
		return [:not_found] if passagem.blank?
		[:success, passagem.to_frontend_obj]
	end
end