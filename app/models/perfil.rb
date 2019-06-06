class Perfil < ApplicationRecord
	validates_presence_of :nome, message: "Nome não pode ser vazio!"
	validates_uniqueness_of :nome, message: "Já existe um perfil com esse nome!"

	has_many :objetos

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
