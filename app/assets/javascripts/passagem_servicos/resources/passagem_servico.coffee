angular.module('scApp').lazy
.factory 'PassagemServico', [
	'$resource',
	($resource)->

		$resource 'http://localhost:3000/passagem_servico/:id.json', { id: '@id' },
			list:
				method: 'GET'

			show:
				method: 'GET'
]
