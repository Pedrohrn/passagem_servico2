class CategoriasService
	def self.model() ::Categoria; end

	def self.index
		list = model.all

		resp = { categorias: list }

		[:success, resp]
	end
end