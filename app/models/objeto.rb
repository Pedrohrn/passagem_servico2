class Objeto < ApplicationRecord
	belongs_to :categoria

	VALIDATES_PRESENCES = [
		{ key: :categoria, msg: "Selecione uma categoria para o objeto!" },
		{ key: :itens, msg: "É necessário adicionar ao menos 1 item para salvar objetos!" },
	]

	validate :validar_campos
	validate :validar_items

	#before_validation :validar_item_qtd

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
			next if item.deep_symbolize_keys[:item_name].present?
			errors.add(:base, "Item (descrição) não pode ser vazio!")
		}

		itens.each{ |item|
			next if item.deep_symbolize_keys[:item_name].length < 201
			errors.add(:base, "A descrição do item é muito longa (máximo permitido: 200 caracteres)!")
		}

		errors.empty?

		itens.map { |item|
			next if item.deep_symbolize_keys[:item_qtd] >= 1
			item.deep_symbolize_keys[:item_qtd] = 1
			item
		}

		itens
	end

	def validar_item_qtd
		itens.map{ |item|
			next if item.deep_symbolize_keys[:item_qtd] >= 1
			item.deep_symbolize_keys[:item_qtd] = 1
			puts item
			puts item.to_h
			puts item.to_s.to_sym
		}
		puts itens
		puts 'itens -validar_qtd'

	end

end

