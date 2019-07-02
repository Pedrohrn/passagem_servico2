class PerfisService
	def self.model() ::Perfil; end

	def self.index(opts, params)
		perfis = model.all.map(&:to_frontend_obj)

		resp = { perfis: perfis }

		[ :success, resp ]
	end

	def self.create(opts, params)
		self.submit(opts, params)
	end

	def self.update(opts, params)
		self.submit(opts, params)
	end

	def self.submit(opts, params)
		params = set_objetos(params)

		perfil = model.find_by(id: params[:id]) || model.new
		perfil.assign_attributes(params)

		message =
		if perfil.new_record?
			'Registro cadastrado com sucesso!'
		else
			'Registro atualizado com sucesso!'
		end

		return [:success, { perfil: perfil.to_frontend_obj, message: message }] if perfil.save
		[:error, perfil.errors.full_messages]
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
		perfil = model.find_by(id: params[:id])
		perfil.destroy

		return [:success, { message: 'Registro excluído com sucesso!'}] if perfil.destroy
		[:error, perfil.errors.full_messages]
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
		perfil = model.find_by(id: params[:id])
		perfil.desativado_em = perfil.desativado? ? nil : Time.now

		return [:success, { perfil: perfil.to_frontend_obj, message: 'Registro atualizado com sucesso!' }] if perfil.save

		[:error, perfil.errors.full_messages]
	end
	private_class_method :desativar_reativar

end