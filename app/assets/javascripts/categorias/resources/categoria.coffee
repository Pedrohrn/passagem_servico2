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

	 		submit:
	 			method: 'POST'
	 			url: 'http://localhost:3000/categorias/submit'
	 			transformRequest: encapsulateData

	 		destroy:
	 			method: 'DELETE'

	 		micro_update:
	 			method: 'PUT'
	 			url: 'http://localhost:3000/categorias/micro_update'
	 			transformRequest: encapsulateData

]