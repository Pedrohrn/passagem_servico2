class Objeto < ApplicationRecord
	validates_presence_of :categoria_id, message: "Selecione uma categoria!"

	belongs_to :categoria

	def slim_obj
		{
			id: id,
			categoria: categoria_obj,
			itens: items_obj,
			perfil_id: perfil_id,
			passagem_servico_id: passagem_servico_id,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end

	def categoria_obj
		categoria.slim_obj
	end

	def items_obj
		itens
	end

end
