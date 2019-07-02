class CategoriasService
	def self.model() ::Categoria; end

	def self.index(opts, params)
		categorias = model.all.map(&:to_frontend_obj)

		resp = { categorias: categorias }

		[:success, resp]
	end

	def self.create(opts, params)
		self.submit(opts, params)
	end

	def self.update(opts, params)
		self.submit(opts, params)
	end

	def self.submit(opts, params)
		categoria = model.find_by(id: params[:id]) || model.new
		categoria.assign_attributes(params)
		message =
		if categoria.new_record?
			'Registro cadastrado com sucesso!'
		else
			'Registro atualizado com sucesso!'
		end

		return [:success, { categoria: categoria.to_frontend_obj, message: message }] if categoria.save
		[:error, categoria.errors.full_messages]
	end

	def self.micro_update(opts, params)
		case params[:micro_update_type].to_s.to_sym
		when :desativar, :reativar
			desativar_reativar(params)
		else
			[:error, 'Tipo de operação não permitida']
		end
	end

	def self.destroy(opts, params)
		categoria = model.find_by(id: params[:id])
		categoria.destroy

		return [:success, { message: 'Registro excluído com sucesso!'}] if categoria.destroy
		[:error, { message: 'Registro não encontrado!' } ]
	end

	private

	def self.desativar_reativar(params)
		categoria = model.find_by(id: params[:id])
		categoria.desativada_em = categoria.desativada? ? nil : Time.now

		return [:success, { categoria: categoria.to_frontend_obj, message: 'Registro atualizado com sucesso!' }] if categoria.save
		[:error, categoria.errors.full_messages]
	end
	private_class_method :desativar_reativar
end