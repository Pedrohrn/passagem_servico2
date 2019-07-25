class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index(opts, params)
		passagens_servico = model.all.map(&:slim_obj)
		pessoas = Pessoa.all.limit(15).map(&:slim_obj)

		resp = { passagem_servicos: passagens_servico, pessoas: pessoas }

		[:success, resp]
	end

	def self.show(opts, params)
		passagem = model.find_by(id: params[:id]) || {}

		return [:success, { passagem_servico: passagem.to_frontend_obj }] if !passagem.blank?
		[:error, { message: 'Registro não encontrado!'} ]
	end

	def self.micro_update(opts, params)
		case params[:micro_update_type].to_s.to_sym
		when :desativar, :reativar
			desativar_reativar(params)
		when :passar_servico
			passar_servico(params)
		else
			[:error, 'Tipo de atualização não permitida']
		end
	end

	def self.submit(opts, params)
		pessoa_saiu = params.delete(:pessoa_saiu) || {}
		pessoa_entrou = params.delete(:pessoa_entrou) || {}

		params[:pessoa_saiu_id] = pessoa_saiu[:id]
		params[:pessoa_entrou_id] = pessoa_entrou[:id]

		params.delete(:data_criacao)

		params = set_objetos(params)

		passagem, errors = nil, []
		ApplicationRecord.transaction do
			passagem = model.find_by(id: params[:id]) || model.new

			passagem.assign_attributes(params)
			unless passagem.save
				errors = passagem.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { passagem_servico: passagem.to_frontend_obj, status: 'success' }]
	end

	def self.destroy(opts, params)
		passagem, errors = nil, []
		ApplicationRecord.transaction do
			passagem = model.find_by(id: params[:id])
			passagem.destroy

			unless passagem.destroy
				errors = passagem.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {status: 'success'}]
	end

	def self.set_objetos(params)
		objetos = params.delete(:objetos) || []
		params[:objetos_attributes] = objetos.map do |objeto|
			objeto[:categoria_id] = objeto.delete(:categoria)[:id]
			objeto
		end

		params
	end

	private

	def self.desativar_reativar(params)
		passagem, errors = nil, []
		ApplicationRecord.transaction do
			passagem = model.find_by(id: params[:id])

			passagem.desativada_em = passagem.desativada? ? nil : Time.now

			unless passagem.save
				errors = passagem.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { passagem_servico: passagem.to_frontend_obj, status: 'success' }]
	end
	private_class_method :desativar_reativar

	def self.passar_servico(params)
		pessoa_saiu = params.delete(:pessoa_saiu) || {}
		pessoa_entrou = params.delete(:pessoa_entrou) || {}
		params.delete(:micro_update_type)

		params[:pessoa_saiu_id] = pessoa_saiu[:id]
		params[:pessoa_entrou_id] = pessoa_entrou[:id]

		passagem, errors = nil, []
		ApplicationRecord.transaction do
			passagem = model.find_by(id: params[:id])
			passagem.passada_em = passagem.realizada? ? nil : Time.now
			passagem.assign_attributes(params)

			unless passagem.save
				errors = passagem.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { passagem_servico: passagem.to_frontend_obj, status: 'success' }]

	end
	private_class_method :passar_servico

end