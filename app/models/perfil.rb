class Perfil < ApplicationRecord
	has_many :objetos, dependent: :destroy

	accepts_nested_attributes_for :objetos, allow_destroy: true

	validate 	:validar_campos
	validate 	:validar_objetos
	validates :nome, uniqueness: { message: 'Já existe um perfil com esse nome! Escolha outro.' }

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

	def validar_campos
		errors.add(:base, "Nome não pode ser vazio") if :nome.nil?

		errors.empty?
	end

	def validar_objetos
		errors.add(:base, "É necessário adicionar ao menos um objeto para salvar!") if :objetos.nil?

		errors.empty?
	end

	def desativado?
		desativado_em.present?
	end

end
