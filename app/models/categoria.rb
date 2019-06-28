class Categoria < ApplicationRecord
	has_many :objetos, foreign_key: 'categoria_id'

	validates_uniqueness_of :nome, message: "Já existe uma Categoria com esse nome!"
	validate :validar_campos

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
		if nome.nil?
			errors.add(:base, "Nome não pode ser vazio!")
		end

		errors.empty?
	end

	def desativada?
		desativada_em.present?
	end
end
