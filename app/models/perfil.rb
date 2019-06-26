class Perfil < ApplicationRecord
	validates_presence_of :nome, message: "Nome não pode ser vazio!"
	validates_uniqueness_of :nome, message: "Já existe um perfil com esse nome!"
	validates_presence_of :objetos, message: "Cadastre ao menos um objeto no perfil!"
	#validate :nome_presente
	#validate :nome_unico
	#validate :has_objetos

	has_many :objetos, dependent: :destroy

	accepts_nested_attributes_for :objetos, allow_destroy: true

	def slim_obj
		{
			id: id,
			nome: nome,
			is_disabled: is_disabled
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

	def nome_presente
		errors.add(:nome, "Nome não pode ser vazio") if :nome.blank?
	end

end
