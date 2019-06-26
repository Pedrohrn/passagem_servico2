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

	 		update:
	 			method: 'PUT'
	 			transformRequest: encapsulateData

	 		destroy:
	 			method: 'DELETE'

	 		create:
	 			method: 'POST'
	 			transformRequest: encapsulateData

]