class CategoriasService
	def self.model() ::Categoria; end

	def self.index(opts, params)
		list = model.all

		resp = { categorias: list }

		[:success, resp]
	end

	def self.create(opts, params)
		self.submit(opts, params)
	end

	def self.update(opts, params)
		self.submit(opts, params)
	end

	def self.submit(opts, params)
		puts 'oioioi'
		categoria = model.find_by(id: params[:id]) || model.new
		categoria.assign_attributes(params)

		return [:success, { categoria: categoria.to_frontend_obj }] if categoria.save
		[:error, categoria.errors.full_messages]
	end

	def self.destroy(opts, params)
		categoria = model.find_by(id: params[:id])
		categoria.destroy

		return [:success, { message: 'Registro excluído com sucesso!'}] if categoria.destroy
		[:error, { message: 'Registro não encontrado!' } ]
	end
end