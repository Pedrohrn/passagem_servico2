angular.module('scApp').lazy
.controller 'PassagemServico::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'PassagemServico'
	(scModal, scAlert, scToggle, scTopMessages, Templates, PassagemServico)->
		vm = this
		vm.templates = Templates

		vm.init = ->
			vm.filtro.exec()

		vm.listCtrl =
			list: []

			loadList: ->
				# @pagination.clear()
				@list = []
				@exec()

			exec: (obj={})->

				params = angular.copy obj
				params.filtro = vm.filtro.params
				# params.pagination = @pagination.new()

				PassagemServico.list params,
					(data)=>
						@list.addOrExtend item for item in data.passagem_servicos

		vm.filtro =
			params: {}

			exec: ->
				vm.listCtrl.loadList()

		vm.itemCtrl =
			init: (passagem)->
				passagem.acc = new scToggle()
				passagem.edit = new scToggle()
				passagem.passarServico = new scModal()
				passagem.log = new scModal()

		vm
]