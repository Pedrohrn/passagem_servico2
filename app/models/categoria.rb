class Categoria < ApplicationRecord
	validates_presence_of :nome, message: "Nome não pode ser vazio!"
	validates_uniqueness_of :nome, message: "Já existe uma Categoria com esse nome!"

	has_many :objetos, foreign_key: 'categoria_id'

	def slim_obj
		{
			id: id,
			nome: nome,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:is_disabled] = is_disabled
		attrs
	end
end
