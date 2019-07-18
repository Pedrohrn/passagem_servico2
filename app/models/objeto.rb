class Objeto < ApplicationRecord
	belongs_to :categoria

	VALIDATES_PRESENCES = [
		{ key: :categoria, msg: "Selecione uma categoria para o objeto!" },
		{ key: :itens, msg: "É necessário adicionar ao menos 1 item para salvar objetos!" },
	]

	validate :validar_campos
	validate :validar_items

	def to_frontend_obj
		{
			id: id,
			_destroy: _destroy,
			categoria: categoria_obj,
			itens: items_obj,
			perfil_id: perfil_id,
			passagem_servico_id: passagem_servico_id,
		}
	end

	def categoria_obj
		categoria.slim_obj
	end

	def items_obj
		itens
	end

	def itens
		(super || []).deep_symbolize_keys
	end

	private

	def validar_campos
		VALIDATES_PRESENCES.each{ |obj|
			next if send(obj[:key]).present?
			errors.add(:base, "#{msg}")
		}

		errors.empty?
	end

	def validar_items
		itens.each{ |item|
			if item[:item_name].blank?
				errors.add(:base, "Item (descrição) não pode ser vazio!")
			end

			if item[:item_name].length > 200
				errors.add(:base, "A descrição do item é muito longa (máximo permitido: 200 caracteres)!")
			end
		}

		errors.empty?
	end
end
