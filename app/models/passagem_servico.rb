class PassagemServico < ApplicationRecord
	validates_presence_of :status, message: "Status não definido!"
	validates_presence_of :pessoa_entrou_id, message: "Selecione a pessoa que está entrando!"
	validates_presence_of :pessoa_saiu_id, message: "Selecione a pessoa que está saindo!"

	has_many :objetos
	belongs_to :pessoa_entrou, class_name: 'Pessoa'
	belongs_to :pessoa_saiu, class_name: 'Pessoa'

	def slim_obj
		{
			id: id,
			pessoa_entrou_id: pessoa_obj(pessoa_entrou),
			pessoa_saiu_id: pessoa_obj(pessoa_saiu),
			data_criacao: created_at,
			status: status,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end

	def pessoa_obj
		{
			id: id,
			nome: nome,
		}
	end
end
