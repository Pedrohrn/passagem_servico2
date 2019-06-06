class Pessoa < ApplicationRecord
	validates_presence_of :nome, message: "Nome não pode ser vazio!"

	has_many :passagem_servicos, foreing_key: 'pessoa_entrou'
	has_many :passagem_servicos, foreing_key: 'pessoa_saiu'

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
