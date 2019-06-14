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
		perfil = model.find_by(id: params[:id]) || model.new
		perfil.assign_attributes(params)

		return [:success, { perfil: perfil}] if perfil.save
		[:error, perfil.errors.full_messages]
	end

	def self.destroy(opts, params)
		perfil = model.find_by(id: params[:id])
		perfil.destroy

		return [:success, {}] if perfil.destroy
		[:error, perfil.errors.full_messages]
	end

end