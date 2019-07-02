class Perfil < ApplicationRecord
	has_many :objetos, dependent: :destroy

	accepts_nested_attributes_for :objetos, allow_destroy: true

	VALIDATES_PRESENCES = [
		{ key: :nome, 		msg: "Título não pode ser vazio!" },
		{ key: :objetos, 	msg: "É necessário adicionar ao menos um objeto para salvar o perfil!" },
	]

	validates :nome, uniqueness: { message: 'Já existe um perfil com esse nome! Escolha outro.' }
	validate 	:validar_campos
	validate :validar_nome

	def slim_obj
		{
			id: id,
			nome: nome,
			is_disabled: is_disabled,
			desativado_em: desativado_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:objetos] = set_objetos
		attrs
	end

	def set_objetos
		objetos.map(&:to_frontend_obj)
	end

	def desativado?
		desativado_em.present?
	end

	def validar_campos
		VALIDATES_PRESENCES.each{ |obj|
			next if send(obj[:key]).present?
			errors.add(:base, "#{obj[:msg]}")
		}

		errors.empty?
	end

	def validar_nome
		if nome.length >= 45
			errors.add(:base, 'O nome do perfil é muito longo (máximo: 45 caracteres)!')
		end

		errors.empty?
	end

end
