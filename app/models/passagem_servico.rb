class PassagemServico < ApplicationRecord
	validates_presence_of :status, message: "Status não definido!"
	validates_presence_of :pessoa_entrou, message: "Selecione a pessoa que está entrando!"
	validates_presence_of :pessoa_saiu, message: "Selecione a pessoa que está saindo!"

	has_many 		:objetos, dependent: :destroy
	belongs_to 	:pessoa_entrou, class_name: 'Pessoa'
	belongs_to 	:pessoa_saiu, class_name: 'Pessoa'

	accepts_nested_attributes_for :objetos, allow_destroy: true

	# callbacks
	before_validation :update_status

	STATUS = [
		{ key: 'pendente',   label: 'Pendente',   color: 'yellow' },
		{ key: 'realizada',  label: 'Realizada',  color: 'green' },
		{ key: 'desativada', label: 'Desativada', color: 'red' },
	]

	def slim_obj
		{
			id: id,
			pessoa_entrou: pessoa_entrou.to_frontend_obj,
			pessoa_saiu: pessoa_saiu.to_frontend_obj,
			data_criacao: created_at,
			status: status_obj,
			passada_em: passada_em,
			desativada_em: desativada_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:objetos] = set_objetos
		attrs[:observacoes] = observacoes
		attrs
	end

	def status_obj
		STATUS.find{ |st| st[:key] == status } || {}
	end

	def set_objetos
		objetos.map(&:to_frontend_obj)
	end

	# status
	def pendente?
		passada_em.blank? && !desativada?
	end

	def realizada?
		passada_em.present? && !desativada?
	end

	def desativada?
		desativada_em.present?
	end

	def update_status
		self.status = STATUS.find{ |st| send("#{st[:key]}?") }[:key]

		nil
	end
	# status
end
