class Pessoa < ApplicationRecord
	validates_presence_of :nome, message: "Nome não pode ser vazio!"

	def slim_obj
		{
			id: id,
			nome: nome,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end
end
