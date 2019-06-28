class Objeto < ApplicationRecord
	belongs_to :categoria

	# 'validar_campos' ->
		# categoria_id
	validate :validar_campos
	# 'validar_items' ->
		## se não tiver nenhum item, avisar que deve ter ao menos 1
		# qtd (se quiser liberar, criar um before_validate para preencher)
		# item
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

	def validar_campos
		if !categoria.present?
			errors.add(:base, "Categoria não pode ser vazia!")
		end

		errors.empty?
	end

	def validar_items
		if itens.nil?
			errors.add(:base, "É necessário adicionar pelo menos 1 item ao objeto!")
		end

		itens.each{ |item|
			next if item.item_name.empty?
			errors.add(:base, "Item (descrição) não pode ser vazio!")
		}

		errors.empty?
	end

end
