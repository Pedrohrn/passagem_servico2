class Objeto < ApplicationRecord
	validates_presence_of :categoria, message: "Selecione uma categoria!"

	belongs_to :categoria

	def to_frontend_obj
		{
			id: id,
			_destroy: _destroy,
			categoria: categoria_obj,
			itens: items_obj,
			perfil_id: perfil_id,
			passagem_servico_id: passagem_servico_id,
		}
	end

	def categoria_obj
		categoria.slim_obj
	end

	def items_obj
		itens
	end

end
