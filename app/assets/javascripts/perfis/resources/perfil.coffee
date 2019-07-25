angular.module('scApp').lazy
.factory 'Perfil', [
	'$resource'
	($resource)->
		encapsulateData = (data)-> JSON.stringify { perfil: data }

		$resource 'http://localhost:3000/perfis/:id.json', { id: @id },
			list:
				method: 'GET'

			show:
				method: 'GET'

			destroy:
				method: 'DELETE'

			submit:
				method: 'POST'
				url: 'http://localhost:3000/perfis/submit'
				transformRequest: encapsulateData

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/perfis/micro_update'
				transformRequest: encapsulateData
]