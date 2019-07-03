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

		vm.relatoriosCtrl =
			modal: new scModal()
			params: {}
			passagens_list: []
			colunas_menu_IsOn: false
			agrupamentos_menu_IsOn: false

			columns_list: [
				{ key: 'pessoa_saiu', 	label: 'Pessoa saiu', 			checked: true },
				{ key: 'pessoa_entrou', label: 'Pessoa entrou',			checked: true },
				{ key: 'status', 				label: 'Status',						checked: true },
				{ key: 'data_cadastro', label: 'Data de cadastro', 	checked: false },
				{ key: 'data_passagem', label: 'Data de passagem', 	checked: true },
			]
			agrupamento_list: [
				{ key: 'status', label: 'Status', checked: true },
				{ key: 'data', label: 'Data', checked: false }
			]
			status_list: [
				{ key: 'pendente', 		label: 'Pendentes' },
				{ key: 'realizada', 	label: 'Realizadas' },
				{ key: 'desativadas', label: 'Desativadas'},
				{ key: 'todas', 			label: 'Todas'},
			]

			init: ->
				@passagens_list = angular.copy vm.selections.list
				@params = { record_list: @passagens_list, titulo: 'Relatório de Passagens de Serviço' }

			toggleModal: ->
				@passagens_list = angular.copy vm.selections.list
				if @passagens_list.length <= 0
					scAlert.open
						title: 'Selecione ao menos uma passagem para compor o relatório!'
						buttons: [
							{ label: 'Ok', color: 'gray' },
						]
				else
					@modal.open()

			colunas_menu_toggle: ->
				@colunas_menu_IsOn = !@colunas_menu_IsOn

			agrupamento_menu_toggle: ->
				@agrupamentos_menu_IsOn = !@agrupamentos_menu_IsOn

			set_column: (option)->
				option.checked = !option.checked

			set_group: (option)->
				for item in @agrupamento_list
					item.checked = false
				option.checked = true

		vm.topToolbar =
			is_visible: false

			toggle: ->
				@is_visible = !@is_visible

		vm.listCtrl =
			list: []
			loadingRecords: false

			init: ->
				@exec()

			loadList: ->
				# @pagination.clear()
				@list = []
				@exec()

			find: (params)->
				@list.find (el)-> el.id == params.id

			exec: (obj={})->
				return if @loadingRecords
				@loadingRecords = true

				params = angular.copy obj
				params.filtro = vm.filtro.params
				#params.pagination = @pagination.new()

				PassagemServico.list params,
					(data)=>
						@loadingRecords = false
						@list.addOrExtend item for item in data.passagem_servicos
						vm.porteirosCtrl.list.addOrExtend item for item in data.pessoas

				Categoria.list params,
					(data)=>
						vm.categoriasCtrl.list.addOrExtend item for item in data.categorias

				Perfil.list params,
					(data)=>
						vm.perfisCtrl.list.addOrExtend item for item in data.perfis

		vm.porteirosCtrl =
			list: []

		vm.selections =
			list: []
			allSelected: false

			toggleSelectAll: ->
				if @allSelected
					for passagem in vm.listCtrl.list
						passagem.checked = false
					@allSelected = false
					@list.clear()
				else
					@allSelected = true
					for passagem in vm.listCtrl.list
						if !passagem.checked
							passagem.checked = true
							@list.push(passagem)

			selectPassagem: (passagem, $event)->
				if passagem.checked && @allSelected
					passagem.checked = false
					@list.remove(passagem)
					@allSelected = false
				else if passagem.checked
					@list.remove(passagem)
					passagem.checked = false
				else
					@list.push(passagem)
					passagem.checked = true


		vm.novaPassagemCtrl =
			params: {}
			newRecord: false

			novaPassagem: (params={})->
				@params = params

				return unless !@newRecord
				@newRecord = !@newRecord

			cancelar: ->
				@params = {}

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
			duplicata: false

			new: ->
				@newRecord = !@newRecord
				@form_modal.open()
				@formInit(item = { objetos: [] })

			init: ->
				for item in @list
					item.toolbar = new scToggle()
					item.perfil_form = new scToggle()
					if item.desativado_em != null
						item.is_disabled = true

			formInit: (item) ->
				if @newRecord && @duplicata
					console.log '2'
					@params.objetos = angular.copy item.objetos
					@params.nome = ''
					for obj in @params.objetos
						delete obj.id
				else if !@duplicata && @newRecord
					console.log '1'
					@params = { nome: '', objetos: [] }
				else if item.perfil_form.opened
					console.log '3'
					@params = angular.copy(item) || {}

			rmv: (item)->
				scAlert.open
					title: 'Deseja mesmo excluir o perfil selecionado?'
					messages: [
						{ msg: 'O registro não poderá ser recuperado!' }
					],
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.perfisCtrl.destroy(item) },
						{ label: 'Cancelar', color: 'gray' }
					]
			destroy: (item)->
				return if @loading
				Perfil.destroy item,
					(data)=>
						@loading = false

						perfil = vm.perfisCtrl.list.find (perf)-> item.id == perf.id
						vm.perfisCtrl.list.remove(perfil)

						msg = data.message
						scTopMessages.openSuccess msg
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			edit: (item)->
				item.perfil_form.opened = true
				@form_modal.open()
				@formInit(item)
				console.log item

			duplicar: (item) ->
				@newRecord = true
				@duplicata = true
				@formInit(item)
				@form_modal.open()

			disable: (item)->
				@params = angular.copy item
				label = if @params.is_disabled then 'reativar' else 'desativar'
				scAlert.open
					title: 'Deseja mesmo ' + label + ' o perfil?'
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.perfisCtrl.desativar() },
						{ label: 'Cancelar', color: 'gray' }
					]

			desativar: ->
				return if @loading
				@params.micro_update_type = 'desativar'
				Perfil.micro_update @params,
					(data)=>
						@loading = false

						perfil = vm.perfisCtrl.list.find (perf)-> data.perfil.id == perf.id
						angular.extend perfil, data.perfil

						msg = data.message
						scTopMessages.openSuccess msg
						@init()
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			addObjeto: ->
				@params.objetos.unshift({ categoria: undefined, itens: [ { item_name: '', item_qtd: 1 } ] })

			rmvObjeto: (objeto)->
				if objeto.id
					objeto._destroy = !objeto._destroy
				else
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
					if objeto.categoria.id == item.categoria.id
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
				objeto.itens.push({ item_name: '', item_qtd: 1 })

			rmvItem: (objeto, item)->
				objeto.itens.remove(item)

			cancelar: (item) ->
				item = angular.copy item || @params
				scAlert.open
					title: 'Deseja mesmo cancelar a edição?'
					messages: [ { msg: 'Dados não salvos serão perdidos.' } ]
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.perfisCtrl.resetForm(item) },
						{ label: 'Não', color: 'gray'}
					]

			resetForm: (item) ->
				if @newRecord
					@newRecord = false
				else
					item.perfil_form.opened = false
				@form_modal.close()
				@duplicata = false

			salvar: (item)->
				item = angular.copy @params
				@submit(item)

			submit: (item)->
				@params = angular.copy item
				return if @loading
				Perfil.create @params,
					(data)=>
						@loading = false
						if @params.id
							perfil = vm.perfisCtrl.list.find (obj)-> data.perfil.id == obj.id
							angular.extend perfil, data.perfil
						else if @newRecord
							vm.perfisCtrl.list.push(data.perfil)
						msg = data.message
						scTopMessages.openSuccess msg
						@resetForm(item)
						@init()

					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

		vm.categoriasCtrl =
			newRecord: false
			list: []
			params: {}
			loading: false

			init: ->
				for item in @list
					item.toolbar = new scToggle();
					item.edit = new scToggle();
					if item.desativada_em == null
						item.is_disabled = false
					else
						item.is_disabled = true

			formInit: (item)->
				@params = if @newRecord then { nome: '' } else if item.edit.opened then angular.copy item

			rmv: (item) ->
				scAlert.open
					title: 'Tem certeza que deseja excluir a categoria?'
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.categoriasCtrl.destroy(item) },
						{ label: 'Cancelar', color: 'gray' }
					]

			destroy: (item)->
				return if @loading
				Categoria.destroy item,
					(data)=>
						@loading = false
						msg = data.message

						categoria = vm.categoriasCtrl.list.find (cat)-> item.id == cat.id
						vm.categoriasCtrl.list.remove(categoria)
						scTopMessages.openSuccess msg
					(response)=>
						@loading = false
						errors = response.data?.errors
						scTopMessages.openDanger errors

			edit: (item) ->
				item.edit.toggle()

			toggleMenu: (item)->
				item.toolbar.opened = !item.toolbar.opened

			disable: (item) ->
				label = if item.is_disabled then 'reativar' else 'desativar'
				scAlert.open
					title: "Deseja mesmo " + label + " a categoria?"
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.categoriasCtrl.desativar(item) },
						{ label: 'Cancelar',  color: 'gray'}
					]

			desativar: (item)->
				params = angular.copy item
				params.micro_update_type = 'desativar'

				return if @loading
				Categoria.micro_update params,
					(data)=>
						@loading = false
						categoria = vm.categoriasCtrl.list.find (cat)-> data.categoria.id == cat.id
						angular.extend categoria, data.categoria

						msg = data.message
						scTopMessages.openSuccess msg
					(response)=>
						@loading = false
						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			new: ->
				if @newRecord
					scAlert.open
						title: 'Termine o cadastro atual para poder cadastrar um novo!'
						buttons: [ { label: 'OK', color: 'gray' } ]
				else
					@newRecord = true

			submit: (item) ->
				return if @loading
				Categoria.create @params,
					(data)=>
						@loading = false

						categoria = vm.categoriasCtrl.list.find (cat)-> data.categoria.id == cat.id
						if !@newRecord
							angular.extend categoria, data.categoria
						else
							vm.categoriasCtrl.list.push(data.categoria)
						msg = data.message
						scTopMessages.openSuccess msg
						if @newRecord
							@newRecord = false
						else if item.edit.opened && item.edit.opened
							item.edit.opened = false
						@init()
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)


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
			params: {}

			logKeys: [
				{ id: 1, label: 'Criada em', 			key: 'criou', 		filtro: true, 	color: 'cian' },
				{ id: 2, label: 'Passada em', 		key: 'passou',		filtro: true,		color: 'green'  },
				{ id: 3, label: 'Editada em', 		key: 'editou', 		filtro: false, 	color: 'blue' },
				{ id: 4, label: 'Excluída em',		key: 'excluiu', 	filtro: false, 	color: 'red' },
				{ id: 5, label: 'Desativada em',	key: 'desativou', filtro: false, 	color: 'yellow' },
			]

		vm.microUpdateCtrl =
			submit: (params)->
				return if @loading
				@loading = true

				PassagemServico.micro_update params,
					(data)=>
						@loading = false

						passagem = vm.listCtrl.list.find (obj)-> obj.id == data.passagem_servico.id
						angular.extend passagem, data.passagem_servico

						msg = data.message
						scTopMessages.openSuccess msg
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

		vm.log_passagens =
			list: []
			loading: false

			init: (passagem)->
				return if @loading
				@list = angular.copy passagem.logs || []
				console.log @list

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
					return if passagem.carregando
					PassagemServico.show passagem,
						(data)=>
							passagem.carregando = false

							passagem = vm.listCtrl.list.find (obj)-> obj.id == data.passagem_servico.id
							angular.extend passagem, data.passagem_servico

						(response)=>
							passagem.carregando = false

							errors = response.data?.errors
							scTopMessages.openDanger errors unless Object.blank(errors)

			passarServico: (passagem)->
				passagem.passar_servico_modal.active = !passagem.passar_servico_modal.active

			rmv: (passagem)->
				scAlert.open
					title: 'Deseja mesmo excluir a passagem? Os dados não poderão ser recuperados.'
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.itemCtrl.deletePassagem(passagem); vm.listCtrl.init() },
						{ label: 'Cancelar', color: 'gray' },
					]

			deletePassagem: (passagem) ->
				return if passagem.deleting
				PassagemServico.destroy passagem,
					(data)=>
						passagem.deleting = false

						msg = data.message
						scTopMessages.openSuccess msg
					(response)=>
						passagem.deleting = false

						msg = response.data?.errors
						scTopMessages.openDanger msg unless Object.blank(errors)


			duplicar: (passagem)->
				delete passagem.id
				for objeto in passagem.objetos
					delete objeto.id

				vm.novaPassagemCtrl.novaPassagem(passagem)

			disable: (passagem)->
				if passagem.status.key == 'desativada'
					button = 'Reativar'
					label = 'reativar'
				else
					button = 'Desativar'
					label = 'desativar'

				scAlert.open
					title: "Deseja mesmo " + label + " essa passagem?"
					buttons: [
						{ label: button, color: 'yellow', action: -> vm.itemCtrl.desativar_reativar(passagem) },
						{ label: 'Cancelar', color: 'gray' }
					]

			desativar_reativar: (passagem) ->
				params =
					id: passagem.id

				params.micro_update_type = if passagem.status.key == 'desativada' then 'reativar' else 'desativar'

				vm.microUpdateCtrl.submit(params)

			open_log: (passagem)->
				passagem.log.active = !passagem.log.active

			accToggle: (passagem)->
				if passagem.edit.opened
					@cancelar(passagem)
				else if !passagem.acc.opened
					passagem.acc.opened = true
					passagem.edit.opened = false
					carregarPassagem(passagem)
				else
					passagem.acc.opened = false
					passagem.edit.opened = false

			cancelar: (passagem)->
				scAlert.open
					title: 'Deseja mesmo fechar o formulário? Dados não salvos serão perdidos.'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.itemCtrl.fecharForm(passagem) },
						{ label: 'Não', color: 'gray' },
					]

			fecharForm: (passagem)->
				if vm.novaPassagemCtrl.newRecord then vm.novaPassagemCtrl.newRecord = false
				else if passagem.edit && passagem.edit.opened then passagem.edit.opened = false
				passagem.acc.opened = true


		carregarPassagem = (passagem)->
			return if passagem.carregada || passagem.carregando
			passagem.carregando = true

			PassagemServico.show passagem,
				(data)=>
					passagem.carregada  = true
					passagem.carregando = false

					angular.extend passagem, data.passagem_servico

		vm.passarServicoModal =
			params: {}
			loading: false

			init: (passagem)->
				PassagemServico.show passagem,
					(data)=>
						@loading = false

						passagem = vm.listCtrl.list.find (obj)-> obj.id == data.passagem_servico.id
						angular.extend passagem, data.passagem_servico
						@params = angular.copy passagem
				  (response)=>
				  	@loading = false

				  	errors = response.data?.errors
				  	scTopMessages.openDanger errors unless Object.blank(errors)

			passarServico: (passagem) ->
				params =
					id: @params.id
					observacoes: @params.observacoes
					pessoa_entrou: @params.pessoa_entrou
					pessoa_saiu: @params.pessoa_saiu
					micro_update_type: 'passar_servico'

				vm.microUpdateCtrl.submit(params)
				passagem.passar_servico_modal.close()
		vm
]