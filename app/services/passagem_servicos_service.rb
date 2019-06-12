class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index(opts, params)
		passagens_servico = model.all.map(&:to_frontend_obj)
		categorias = Categoria.all.map(&:slim_obj)
		perfis = Perfil.all.map(&:to_frontend_obj)
		pessoas = Pessoa.all.limit(15).map(&:slim_obj)

		resp = { passagem_servicos: passagens_servico, categorias: categorias, perfis: perfis, pessoas: pessoas }

		[:success, resp]
	end

	def self.show(opts, params)
		passagem = model.find_by(id: params[:id]) || {}
		return [:not_found] if passagem.blank?
		[:success, passagem.to_frontend_obj]
	end

	def self.submit(opts, params)
		pessoa_saiu = params.delete(:pessoa_saiu) || {}
		pessoa_entrou = params.delete(:pessoa_entrou) || {}

		params[:pessoa_saiu_id] = pessoa_saiu[:id]
		params[:pessoa_entrou_id] = pessoa_entrou[:id]

		passagem = model.find_by(id: params[:id]) || model.new(params)
		passagem.assign_attributes(params)

		return [:success, {passagem_servico: passagem}] if passagem.save
		[:error, passagem.errors.full_messages]
	end

	def self.destroy(opts, params)
		passagem = model.find_by(id: params[:id])
		passagem.destroy
	end

end