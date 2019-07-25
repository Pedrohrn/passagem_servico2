class PerfisService
	def self.model() ::Perfil; end

	def self.index(opts, params)
		perfis = model.all.map(&:to_frontend_obj)

		resp = { perfis: perfis }

		[ :success, resp ]
	end

	def self.submit(opts, params)
		params = set_objetos(params)

		perfil, errors = nil, []
		ApplicationRecord.transaction do
			perfil = model.find_by(id: params[:id]) || model.new
			perfil.assign_attributes(params)

			unless perfil.save
				errors = perfil.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { perfil: perfil.to_frontend_obj, status: 'success' }]

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
		perfil, errors = nil, []
		AplicationRecord.transaction do
			perfil = model.find_by(id: params[:id])
			perfil.destroy

			unless perfil.destroy
				errors = perfil.errors.full_messages
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
		perfil, errors = nil, []
		AplicationRecord.transaction do
			perfil = model.find_by(id: params[:id])
			perfil.desativado_em = perfil.desativado? ? nil : Time.now

			unless perfil.save
				errors = perfil.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { perfil: perfil.to_frontend_obj, status: 'success' }]

	end
	private_class_method :desativar_reativar

end