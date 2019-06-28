class Pessoa < ApplicationRecord
	validates :nome, presence: { message: "Nome não pode ser vazio!" }

	has_many :passagem_servicos, foreign_key: 'pessoa_entrou_id'
	has_many :passagem_servicos, foreign_key: 'pessoa_saiu_id'

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
