class PerfisService
	def self.model() ::Perfil; end

	def self.show(opts, params)
		perfil = model.find_by(id: params[:id])

		return [:success, { perfil: perfil}] if perfil?
		[:error, perfil.errors.full_messages]
	end

	def self.create(opts, params)
		self.submit(opts, params)
	end

	def self.update(opts, params)
		self.submit(opts, params)
	end

	def self.submit(opts, params)
		params = set_objetos(params)

		perfil = model.find_by(id: params[:id]) || model.new
		perfil.assign_attributes(params)

		return [:success, { perfil: perfil.to_frontend_obj }] if perfil.save
		[:error, perfil.errors.full_messages]
	end

	def self.destroy(opts, params)
		perfil = model.find_by(id: params[:id])
		perfil.destroy

		return [:success, { message: 'Registro excluído com sucesso!'}] if perfil.destroy
		[:error, perfil.errors.full_messages]
	end

	def self.set_objetos(params)
		objetos = params.delete(:objetos) || []
		#aux = params

		#aux[:objetos_attributes] = objetos.map do |objeto|
		#	objeto[:categoria_id] = objeto.delete(:categoria)[:id]
		#	objeto
		#end

		#new_objetos = aux.delete(:objetos_attributes) || []

		#puts new_objetos
		#puts 'new_objetos'

		params[:objetos_attributes] = objetos.map do |objeto|
			objeto[:categoria_id] = objeto.delete(:categoria)[:id]
			objeto
		end

		params
	end

	#def self.update_objetos(params)
		#objetos = params.delete(:objetos) || []

		#objetos.map do |objeto|
			##o = Objeto.find_by(id: objeto[:id]) || Objeto.new
			##o.assign_attributes(objeto)
		#end

		#params
	#end

end