angular.module('scApp').lazy
.factory 'Categoria', [
 	'$resource'
 	($resource)->
 		encapsulateData = (data)-> JSON.stringify { categoria: data }

 		$resource 'http://localhost:3000/categorias/:id.json', { id: @id },
	 		list:
	 			method: 'GET'

	 		show:
	 			method: 'GET'

	 		destroy:
	 			method: 'DELETE'

	 		update:
	 			method: 'PUT'
	 			transformRequest: encapsulateData

	 		create:
	 			method: 'POST'
	 			transformRequest: encapsulateData

]