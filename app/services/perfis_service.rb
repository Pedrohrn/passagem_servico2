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

		return [:success, { perfil: perfil.to_frontend_obj, message: 'Registro salvo com sucesso!' }] if perfil.save
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

		params[:objetos_attributes] = objetos.map do |objeto|
			objeto[:categoria_id] = objeto.delete(:categoria)[:id]
			objeto
		end

		params
	end

end