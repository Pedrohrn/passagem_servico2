angular.module('scApp').lazy
.controller 'PassagemServico::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'PassagemServico'
	(scModal, scAlert, scToggle, scTopMessages, Templates, PassagemServico)->
		vm = this
		vm.templates = Templates

		vm.init = ->
			vm.filtro.exec()
			for status in vm.logCtrl.statusList
				if status.log == false
					vm.filtro.list.push(status)

		vm.topToolbar =
			is_visible: false

			toggle: ->
				@is_visible = !@is_visible

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

		vm.novaPassagemCtrl =
			newRecord: false

			novaPassagem: ->
				@newRecord = !@newRecord

		vm.filtro =
			filtro_avancado: false
			list: []
			params: {}

			exec: ->
				vm.listCtrl.loadList()

			buscaAvancada: ->
				@filtro_avancado = !@filtro_avancado

		vm.perfilCtrl =
			modal: new scModal()

		vm.logCtrl =
			list: []
			modal: new scModal()
			statusList: [
				{ id: 1, label: 'Criada em', 			key: 'criou', 		filtro: true, color: 'cian' },
				{ id: 2, label: 'Passada em', 		key: 'passou',		filtro: false, color: 'green'  },
				{ id: 3, label: 'Editada em', 		key: 'editou', 		filtro: false, 	color: 'blue' },
				{ id: 4, label: 'Excluída em',		key: 'excluiu', 	filtro: false, 	color: 'red' },
				{ id: 5, label: 'Desativada em',	key: 'desativou', filtro: false, 	color: 'yellow' },
			]

		vm.itemCtrl =
			init: (passagem)->
				passagem.acc = new scToggle()
				passagem.edit = new scToggle()
				passagem.passarServico = new scModal()
				passagem.log = new scModal()

		vm
]