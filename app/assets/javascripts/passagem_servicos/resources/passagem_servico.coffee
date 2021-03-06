angular.module('scApp').lazy
.factory 'PassagemServico', [
	'$resource'
	($resource)->
		encapsulateDate = (data)-> JSON.stringify { passagem_servico: data }

		$resource 'http://localhost:3000/passagem_servicos/:id.json', { id: '@id' },
			list:
				method: 'GET'

			show:
				method: 'GET'
				transformRequest: encapsulateDate

			submit:
				method: 'POST'
				transformRequest: encapsulateDate
				url: 'http://localhost:3000/passagem_servicos/submit'

			destroy:
				method: 'DELETE'

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/passagem_servicos/micro_update'
				transformRequest: encapsulateDate
]