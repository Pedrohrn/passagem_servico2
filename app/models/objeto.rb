class Objeto < ApplicationRecord
	validates_presence_of :categoria_id, message: "Selecione uma categoria!"

	def slim_obj
		{
			id: id,
			categoria_id: categoria_id,
			itens: itens,
			perfil_id: perfil_id,
			passagem_servico_id: passagem_servico_id,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end
end
