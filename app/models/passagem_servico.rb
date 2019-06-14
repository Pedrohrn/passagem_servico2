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
			pessoa_entrou: pessoa_entrou.to_frontend_obj,
			pessoa_saiu: pessoa_saiu.to_frontend_obj,
			data_criacao: created_at,
			status: status,
			observacoes: observacoes,
			passada_em: updated_at,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end

end
