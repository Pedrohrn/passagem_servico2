angular.module('scApp').lazy
.controller 'PassagemServico::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'PassagemServico', 'Categoria', 'Perfil'
	(scModal, scAlert, scToggle, scTopMessages, Templates, PassagemServico, Categoria, Perfil)->
		vm = this
		vm.templates = Templates

		vm.init = ->
			vm.filtro.exec()
			for status in vm.logCtrl.logKeys
				if status.filtro == true
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
						vm.categoriasCtrl.list.addOrExtend item for item in data.categorias
						vm.perfisCtrl.list.addOrExtend item for item in data.perfis

		vm.novaPassagemCtrl =
			newRecord: false

			novaPassagem: ->
				@newRecord = !@newRecord

		vm.filtro =
			filtro_avancado: false
			list: []
			params: {}
			filtroKeys: [
				{ id: 1, key: 'pendente',   color: 'yellow'},
				{ id: 2, key: 'realizada',  color: 'green'},
				{ id: 3, key: 'desativada', color: 'red'},
			]

			exec: ->
				vm.listCtrl.loadList()

			buscaAvancada: ->
				@filtro_avancado = !@filtro_avancado

		vm.modalPerfilCtrl =
			modal: new scModal()
			list: [
				{ id: 1, key: 'perfil', 		active: true,		ctrl: {}, empty_message: "Nenhum perfil cadastrado!" },
				{ id: 2, key: 'categoria',  active: false,	ctrl: {}, empty_message: "Nenhuma categoria cadastrada!" },
				{ id: 3, key: 'permissões', active: false,	ctrl: {}, empty_message: '' },
			]
			current_list: {}

			init: (item)->
				if @current_list.key == 'perfil'
					console.log('perfil')
					vm.perfisCtrl.init(item)
				else if @current_list.key == 'categoria'
					console.log('categoria')
					vm.categoriasCtrl.init(item)

			listInit: (tipo) ->
				tipo = @list[0]
				@current_list = tipo
				return @loadList(tipo)

			loadList: (tipo) ->
				for i in [0..@list.length-1]
					@list[i].active = false

				tipo.active = true
				@current_list = tipo
				@current_list.ctrl = if @current_list.key == 'perfil' then vm.perfisCtrl else if @current_list.key == 'categoria' then vm.categoriasCtrl else vm.permissoesCtrl
				@init()

		vm.perfisCtrl =
			newRecord: false
			list: []
			params: {}
			##toggle do new não está funcionando

			new: ->
				@newRecord = !@newRecord

			init: (item) ->
				item.toolbar = new scToggle();
				item.perfil_form = new scModal();

			formInit: (item) ->
				if @newRecord == true
					@params = {}
					@params.objetos = []
				else if item.perfil_form.active
					@params = angular.copy(item) || {}
					@params.objetos = [] #TIRAR ISSO AQUI quando estiver estruturado e funcionando

			toggleMenu: (item)->
				item.toolbar.opened = !item.toolbar.opened

			rmv: (item)->
				Perfil.destroy(params)

			edit: (item)->
				item.perfil_form.open()

			disable: (item)->
				Perfil.update(params)

			addObjeto: ->
				@params.objetos.unshift({ categoria: undefined, itens: [] })

			rvm: (objeto)->
				@params.objetos.remove(objeto)

			limparFormulario: ->
				scAlert.open
					title: 'Tem certeza que deseja excluir todos os dados do formulário abaixo?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.perfisCtrl.params.objetos = [] },
						{ label: 'Não', color: 'gray' }
					]

			addItem: (objeto)->
				objeto.itens.push({ item_name: '', item_qtd: undefined })

			rmvItem: (objeto, item)->
				objeto.itens.remove(item)

			cancelar: (item)->
				if @newRecord
					scAlert.open
						title: 'Deseja mesmo cancelar a edição?',
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> @newRecord = false}
						]
				else if item.perfil_form && item.perfil_form.active
					scAlert.open
						title: 'Deseja mesmo cancelar a edição?'
						messages: [ { msg: 'Dados não salvos serão perdidos.' } ]
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> item.perfil_form.toggle() },
							{ label: 'Não', color: 'gray'}
						]

			submit: (params) ->
				Perfil.create(params)

		vm.categoriasCtrl =
			newRecord: false
			list: []
			newCategoria: ''

			init: (item) ->
				console.log(item)
				item.toolbar = new scToggle();
				item.edit = new scToggle();

			rmv: (item) ->

			edit: (item) ->
				item.edit.toggle()
				@newCategoria = angular.copy item.nome

			toggleMenu: (item)->
				item.toolbar.opened = !item.toolbar.opened

			disable: (item) ->

			new: ->
				if @newRecord
					scAlert.open
						title: 'Termine o cadastro atual para poder cadastrar um novo!'
						buttons: [ { label: 'OK', color: 'gray' } ]
				else
					@newRecord = true

			submit: ->
				Categoria.create(params)

			cancelar: (item)->
				if @newRecord
					scAlert.open
						title: 'Deseja mesmo cancelar a edição?'
						messages: [ { msg: 'Dados não salvos serão perdidos.' } ]
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.categoriasCtrl.newRecord = false },
							{ label: 'Não', color: 'gray' }
						]
				else if item.edit && item.edit.opened
					scAlert.open
						title: 'Deseja mesmo cancelar a edição?'
						messages: [ {msg: 'Dados não salvos serão perdidos.' } ]
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> item.edit.toggle() }
						]

		vm.permissoesCtrl =
			list: [
				{ id: 1, nome: 'Editar itens',  value: false },
				{ id: 2, nome: 'Excluir itens', value: true },
			]

		vm.logCtrl =
			list: []
			modal: new scModal()
			logKeys: [
				{ id: 1, label: 'Criada em', 			key: 'criou', 		filtro: true, 	color: 'cian' },
				{ id: 2, label: 'Passada em', 		key: 'passou',		filtro: true,		color: 'green'  },
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