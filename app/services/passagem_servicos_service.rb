class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index(opts, params)
		passagens_servico = model.all.map(&:to_frontend_obj)
		categorias = Categoria.all.map(&:to_frontend_obj)
		perfis = Perfil.all.map(&:to_frontend_obj)
		pessoas = Pessoa.all.limit(15).map(&:slim_obj)

		resp = { passagem_servicos: passagens_servico, categorias: categorias, perfis: perfis, pessoas: pessoas }

		[:success, resp]
	end

	def self.show(opts, params)
		passagem = model.find_by(id: params[:id]) || {}
		return [:success, passagem.to_frontend_obj] if !passagem.blank?
		[:error, passagem.errors.full_messages]
	end

	def self.micro_update(params)
		passagem = model.find_by(id: params[:id])
		passagem.passada_em = Time.now
		passagem.update_attributes(params)

		return [:success, { passagem_servico: passagem.to_frontend_obj }] if passagem.save
		[:error, passagem.errors.full_messages]
	end

	def self.update(opts, params)
		self.submit(opts, params)
	end

	def self.create(opts, params)
		self.submit(opts, params)
	end

	def self.submit(opts, params)
		pessoa_saiu = params.delete(:pessoa_saiu)
		pessoa_entrou = params.delete(:pessoa_entrou)

		params[:pessoa_saiu_id] = pessoa_saiu[:id]
		params[:pessoa_entrou_id] = pessoa_entrou[:id]

		params.delete(:data_criacao)

		params = set_objetos(params)
		passagem = model.find_by(id: params[:id]) || model.new
		passagem.assign_attributes(params)

		return [:success, { passagem_servico: passagem.to_frontend_obj }] if passagem.save
		[:error, passagem.errors.full_messages]
	end

	def self.destroy(opts, params)
		passagem = model.find_by(id: params[:id])
		passagem.destroy

		return [:success, { message: 'Registro excluído com sucesso!'}] if passagem.destroy
		[:error, passagem.errors]
	end

	def self.set_objetos(params)
		objetos = params.delete(:objetos) || []
		params[:objetos_attributes] = objetos.map do |objeto|
			objeto[:categoria_id] = objeto.delete(:categoria)[:id]
			objeto
		end

		puts params
		params
	end

end