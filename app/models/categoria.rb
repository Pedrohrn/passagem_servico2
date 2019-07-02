class Categoria < ApplicationRecord
	has_many :objetos

	validates_uniqueness_of :nome, message: "Já existe uma Categoria com esse nome!"
	validate :validar_campos
	validate :validar_tamanho

	def slim_obj
		{
			id: id,
			nome: nome,
			is_disabled: is_disabled,
			desativada_em: desativada_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end

	def validar_campos
		if !nome.present?
			errors.add(:base, "Nome não pode ser vazio!")
		end

		errors.empty?
	end

	def validar_tamanho
		if nome.length > 60
			errors.add(:base, "O nome escolhido é muito longo (máximo permitido: 60 caracteres)!")
		end
	end

	def desativada?
		desativada_em.present?
	end

end