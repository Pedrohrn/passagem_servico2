angular.module('scApp').lazy
.controller 'PassagemServicos::IndexCtrl', [
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

			init: ->
				@exec()

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
						vm.porteirosCtrl.list.addOrExtend item for item in data.pessoas

		vm.porteirosCtrl =
			list: []

		vm.novaPassagemCtrl =
			newRecord: false

			novaPassagem: ->
				return unless !@newRecord
				@newRecord = !@newRecord

			cancelar: ->
				scAlert.open
					title: 'Deseja mesmo cancelar a edição? Dados não salvos serão perdidos.'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.novaPassagemCtrl.newRecord = false },
						{ label: 'Não', color: 'gray' }
					]

		vm.filtro =
			filtro_avancado: false
			list: []
			params: { lista_de_periodos: []}
			filtroKeys: [ #listagem de status
				{ id: 1, key: 'pendente',   color: 'yellow'},
				{ id: 2, key: 'realizada',  color: 'green'},
				{ id: 3, key: 'desativada', color: 'red'},
			]

			exec: ->
				vm.listCtrl.loadList()

			buscaAvancada: ->
				@filtro_avancado = !@filtro_avancado

			addPeriodo: ->
				@params.lista_de_periodos.push({ tipoData: undefined, data_inicio: undefined, data_fim: undefined })

			limparBusca: ->
				@params = {}

			rmvPeriodo: (data)->
				@params.lista_de_periodos.remove(data)

		vm.modalPerfilCtrl =
			modal: new scModal()

			tipoList: [
				{ key: 'perfil', 			active: true,		ctrl: {}, empty_message: "Nenhum perfil cadastrado!" },
				{ key: 'categoria',  	active: false,	ctrl: {}, empty_message: "Nenhuma categoria cadastrada!" },
				{ key: 'permissões', 	active: false,	ctrl: {}, empty_message: '' },
			]
			current_list: {}

			listInit: (tipo) ->
				tipo = @tipoList[0]
				@current_list = tipo
				return @loadList(tipo)

			loadList: (tipo) ->
				for item in @tipoList
					item.active = false

				tipo.active = true
				@current_list = tipo
				@current_list.ctrl = if @current_list.key == 'perfil' then vm.perfisCtrl else if @current_list.key == 'categoria' then vm.categoriasCtrl else vm.permissoesCtrl
				return unless @current_list.key != 'permissões'
				@current_list.ctrl.init()

		vm.perfisCtrl =
			newRecord: false
			form_modal: new scModal()
			list: []
			params: {}
			lixeira_itens: []
			lixeira_objetos: []
			duplicata: false

			new: ->
				@newRecord = !@newRecord
				@form_modal.open()

			init: ->
				for item in @list
					item.toolbar = new scToggle();
					item.perfil_form = new scToggle();

			formInit: (item) ->
				if @newRecord && !@duplicata
					@params = {}
					@params.objetos = []
				else if @newRecord && @duplicata
					@params = angular.copy item
				else if item.perfil_form.opened
					@params = angular.copy(item) || {}
					@params.objetos = angular.copy(item.objetos) || []

			toggleMenu: (item)->
				item.toolbar.opened = !item.toolbar.opened

			rmv: (item)->
				scAlert.open
					title: 'Deseja mesmo excluir o perfil selecionado?'
					messages: [
						{ msg: 'O registro não poderá ser recuperado!' }
					],
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> Perfil.destroy(item); vm.listCtrl.init() },
						{ label: 'Cancelar', color: 'gray' }
					]

			edit: (item)->
				item.perfil_form.toggle()
				@form_modal.open()

			duplicar: (item) ->
				@params = angular.copy(item)
				@params.id = null
				duplicata = true
				@form_modal.open()

			disable: (item)->
				@params = angular.copy item
				@params.is_disabled = if @params.is_disabled  then false else true
				Perfil.update(@params)

			addObjeto: ->
				@params.objetos.unshift({ categoria: undefined, itens: [] })

			rmvObjeto: (objeto)->
				@params.objetos.remove(objeto)

			limparFormulario: ->
				scAlert.open
					title: 'Tem certeza que deseja excluir todos os dados do formulário abaixo?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.perfisCtrl.params.objetos = [] },
						{ label: 'Não', color: 'gray' }
					]

			set_categoria: (objeto) ->
				count = 0
				for item in @params.objetos
					if item.categoria.id == objeto.categoria.id
						count++
						objeto.error = false
					else if objeto.categoria == undefined
						return
				if count > 1
					scAlert.open
						title: 'Essa categoria já existe na lista! Escolha outra!'
						buttons: [
							{ label: 'Ok', color: 'gray'}
						]
					objeto.error = true
					objeto.categoria = {}

			addItem: (objeto)->
				objeto.itens.push({ item_name: '', item_qtd: undefined })

			rmvItem: (objeto, item)->
				objeto.itens.remove(item)

			toggleForm: (item)->
				item.perfil_form.opened = !item.perfil_form.opened

			cancelar: (item)->
				if @newRecord
					scAlert.open
						title: 'Deseja mesmo cancelar a edição?',
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.perfisCtrl.newRecord = false; vm.perfisCtrl.form_modal.close() }
						]
				else
					scAlert.open
						title: 'Deseja mesmo cancelar a edição?'
						messages: [ { msg: 'Dados não salvos serão perdidos.' } ]
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.perfisCtrl.toggleForm(item); vm.perfisCtrl.form_modal.close() },
							{ label: 'Não', color: 'gray'}
						]

			salvar: (item) ->
				vm.perfisCtrl.verifica_objetos(item)

			verifica_objetos: ->
				for objeto in @params.objetos
					if objeto.itens.length == 0
						@lixeira_objetos.push(objeto)

				for objeto in @params.objetos
					for item in objeto.itens
						if item.item_name == ''
							@lixeira_itens.push(item)

				for objeto in @params.objetos
					if objeto.categoria == undefined
						objeto.error = true
						scAlert.open
							title: 'Atenção!'
							messages: [
								{ msg: 'Existem objetos sem categoria definida!' },
								{	msg: 'É necessário selecionar uma categoria para salvar o objeto!' },
							]
							buttons: [
								{ label: 'Ok', color: 'gray' },
							]
						return

				for objeto in @lixeira_objetos
					@params.objetos.remove(objeto)

				for objeto in @params.objetos
					for item in @lixeira_itens
						objeto.itens.remove(item)

				@lixeira_itens.length = 0

				if @lixeira_itens.length == 0
					vm.perfisCtrl.submit(item)
				else
					vm.perfisCtrl.limpar_objetos()

			limpar_objetos: ->
				console.log 'deu ruim'

			submit: (item) ->
				@params.status = 'ativo'
				Perfil.create(@params)
				console.log @params
				@params.perfil_form.opened = false
				vm.listCtrl.init()

		vm.categoriasCtrl =
			newRecord: false
			list: []
			newCategoria: {}

			init: ->
				for item in @list
					item.toolbar = new scToggle();
					item.edit = new scToggle();

			rmv: (item) ->
				scAlert.open
					title: 'Tem certeza que deseja excluir a categoria?'
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> Categoria.destroy(item); vm.listCtrl.init() },
						{ label: 'Cancelar', color: 'gray' }
					]

			edit: (item) ->
				item.edit.toggle()
				@newCategoria = angular.copy item

			toggleMenu: (item)->
				item.toolbar.opened = !item.toolbar.opened

			disable: (item) ->
				item.is_disabled = !item.is_disabled
				@newCategoria = angular.copy item
				Categoria.update(@newCategoria)

			new: ->
				if @newRecord
					scAlert.open
						title: 'Termine o cadastro atual para poder cadastrar um novo!'
						buttons: [ { label: 'OK', color: 'gray' } ]
				else
					@newRecord = true
					@newCategoria = { nome: '' }

			submit: (item) ->
				Categoria.create(@newCategoria)
				if @newRecord
					@newRecord = false
				else if item.edit.opened && item.edit.opened
					item.edit.opened = false
				vm.listCtrl.init()

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
			loading: false

			logKeys: [
				{ id: 1, label: 'Criada em', 			key: 'criou', 		filtro: true, 	color: 'cian' },
				{ id: 2, label: 'Passada em', 		key: 'passou',		filtro: true,		color: 'green'  },
				{ id: 3, label: 'Editada em', 		key: 'editou', 		filtro: false, 	color: 'blue' },
				{ id: 4, label: 'Excluída em',		key: 'excluiu', 	filtro: false, 	color: 'red' },
				{ id: 5, label: 'Desativada em',	key: 'desativou', filtro: false, 	color: 'yellow' },
			]

		vm.itemCtrl =
			duplicata: false
			dupParams: {}

			init: (passagem)->
					passagem.acc = new scToggle()
					passagem.edit = new scToggle()
					passagem.menu = new scToggle()
					passagem.passar_servico_modal = new scModal()
					passagem.log = new scModal()

			edit: (passagem)->
				if passagem.edit.opened
					passagem.acc.opened = false
					return
				else
					passagem.edit.opened = !passagem.edit.opened
					passagem.acc.opened = false

			passarServico: (passagem)->
				passagem.passar_servico_modal.active = !passagem.passar_servico_modal.active

			rmv: (passagem)->
				scAlert.open
					title: 'Deseja mesmo excluir a passagem? Os dados não poderão ser recuperados.'
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> PassagemServico.destroy(passagem); vm.listCtrl.init() },
						{ label: 'Cancelar', color: 'gray' },
					]

			duplicar: (passagem)->
				vm.novaPassagemCtrl.novaPassagem()
				@duplicata = true
				@dupParams = angular.copy(passagem)
				passagem = angular.copy @dupParams

			disable: (passagem)->
				if passagem.status.label == 'Desativada'
					button = 'Reativar'
					label = 'reativar'
				else
					button = 'Desativar'
					label = 'desativar'
				scAlert.open
					title: "Deseja mesmo " + label + " essa passagem?"
					buttons: [
						{ label: button, color: 'yellow', action: -> vm.itemCtrl.desativar(passagem) },
						{ label: 'Cancelar', color: 'gray' }
					]

			desativar: (passagem) ->
				if passagem.status.label == 'Desativada'
					passagem.passada_em = null
					passagem.desativada_em = null
				else
					passagem.passada_em = null
					passagem.desativada_em = new Date()
				PassagemServico.micro_update(passagem)

			open_log: (passagem)->
				passagem.log.active = !passagem.log.active

			accToggle: (passagem)->
				if passagem.edit.opened
					@cancelar(passagem)
				else
					passagem.acc.opened = !passagem.acc.opened
					PassagemServico.show(passagem)

			cancelar: (passagem)->
				scAlert.open
					title: 'Deseja mesmo fechar o formulário? Dados não salvos serão perdidos.'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> if vm.novaPassagemCtrl.newRecord then vm.novaPassagemCtrl.newRecord = false else if passagem.edit && passagem.edit.opened then passagem.edit.opened = false; passagem.acc.opened = true },
						{ label: 'Não', color: 'gray' }
					]

		vm.passarServicoModal =
			params: {}
			loading: false

			init: (passagem)->
				@params = angular.copy passagem

			passarServico: (passagem)->
				@params.status = 'realizada'
				@params.passada_em = new Date()
				PassagemServico.micro_update(@params)
				#passagem.passar_servico_modal.close()

		vm
]