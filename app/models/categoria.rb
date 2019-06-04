class Categoria < ApplicationRecord
	validates_presence_of :nome, message: "Nome não pode ser vazio!"
	validates_presence_of :nome, message: "Já existe uma Categoria com esse nome!"

	def slim_obj
		{
			id: id,
			nome: nome,
			is_disabled: is_disabled
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end
end
