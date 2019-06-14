angular.module('scApp').lazy
.factory 'Perfil', [
	'$resource'
	($resource)->

		$resource 'http://localhost:3000/perfis/:id.json', { id: @id },
			list:
				method: 'GET'

			show:
				method: 'GET'

			destroy:
				method: 'DELETE'

			update:
				method: 'PUT'

			create:
				method: 'POST'


]