class CategoriasService
	def self.model() ::Categoria; end

	def self.index(opts, params)
		categorias = model.all.map(&:to_frontend_obj)

		resp = { categorias: categorias }

		[:success, resp]
	end

	def self.submit(opts, params)
		categoria, errors = nil, []
		ApplicationRecord.transaction do
			categoria = model.find_by(id: params[:id]) || model.new
			categoria.assign_attributes(params)

			unless categoria.save
				errors = categoria.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { categoria: categoria.to_frontend_obj }]
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
		categoria, errors = nil, []
		ApplicationRecord.transaction do
			categoria = model.find_by(id: params[:id])
			categoria.destroy

			unless categoria.destroy
				errors = categoria.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors ] if errors.any?
		[:success, {} ]
	end

	private

	def self.desativar_reativar(params)
		categoria, errors = nil, []
		ApplicationRecord.transaction do
			categoria = model.find_by(id: params[:id])
			categoria.desativada_em = categoria.desativada? ? nil : Time.now

			unless categoria.save
				errors = categoria.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { categoria: categoria.to_frontend_obj }]
	end
	private_class_method :desativar_reativar
end