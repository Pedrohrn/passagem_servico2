class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index(opts, params)
		list = model.all
		categorias = Categoria.all
		perfis = Perfil.all

		resp = { passagem_servicos: list, categorias: categorias, perfis: perfis }

		[:success, resp]
	end

	def self.show(opts, params)
		passagem = model.find_by(id: params[:id]) || {}
		return [:not_found] if passagem.blank?
		[:success, passagem.to_frontend_obj]
	end
end