angular.module('scApp').lazy
.controller 'PassagemServicos::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'PassagemServico'
	(scModal, scAlert, scToggle, PassagemServico)->
		vm = this
		vm.params = {}
		vm.passagem = null
		vm.new = false

		vm.init = (passagem)->
			vm.passagem = passagem || {}
			vm.params = angular.copy vm.passagem
			vm.params.objetos = angular.copy vm.passagem.objetos || []
			vm.params.status = 'pendente'

		vm.formCtrl =
			loading: false
			current_perfil: {}
			lixeira_objetos: []
			lixeira_itens: []

			set_perfil: ->
				scAlert.open
					title: 'Atenção!'
					messages: [
						{ msg: 'O perfil foi alterado. O que deseja fazer com os objetos?' }
					]
					buttons: [
						{ label: 'Mesclar', color: 'blue', tooltip: 'Mescla, por categoria, os objetos abaixo com os objetos do perfil', action: -> vm.formCtrl.mesclarObjetos() },
						{ label: 'Sobreescrever', color: 'yellow', tooltip: 'Sobreescreve os objetos abaixo pelos objetos do perfil', action: -> vm.formCtrl.sobreescreverObjetos() },
						{ label: 'Cancelar', color: 'gray', action: -> vm.params.current_perfil = undefined },
					]

			mesclarObjetos: ->
				aux = []
				for objeto in vm.params.objetos
					if Object.blank(objeto.categoria)
						aux.push(objeto)

				vm.params.objetos.remove(item) for item in aux

				vm.params.perfil = angular.copy vm.formCtrl.current_perfil
				for objetoPerfil in vm.params.perfil.objetos
					paramsObjetos = vm.params.objetos.find (obj)-> obj.categoria.id == objetoPerfil.categoria.id
					if paramsObjetos
						paramsObjetos.itens = paramsObjetos.itens.concat(objetoPerfil.itens)
					else
						vm.params.objetos.push(objetoPerfil)

			sobreescreverObjetos: ->
				vm.params.objetos = angular.copy vm.formCtrl.current_perfil.objetos

			addObjeto: ->
				vm.params.objetos.unshift({ categoria: undefined, itens: [] })

			rmvObjeto: (objeto) ->
				vm.params.objetos.remove(objeto)

			addItem: (objeto)->
				objeto.itens.push({ item_name: '', item_qtd: undefined })

			rmvItem: (objeto, item)->
				objeto.itens.remove(item)

			set_categoria: (objeto) ->
				count = 0
				for item in vm.params.objetos
					if objeto.categoria.id == item.categoria.id
						objeto.error = true
						count++;
					else if objeto.categoria == undefined
						return
				if count > 1
					scAlert.open
						title: 'Essa categoria já existe na lista! Escolha outra!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
					objeto.categoria = {}

			limparFormulario: ->
				scAlert.open
					title: 'Tem certeza que deseja limpar os objetos abaixo?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.params.objetos = [] },
						{ label: 'Não', color: 'gray' }
					]

			salvar: (passagem)->
				return unless !@loading
				vm.params.status = if vm.params.status.label == 'Realizada' then 'realizada' else 'pendente'
				return @verifica_objetos(passagem)

			salvar_e_passar: (passagem)->
				return unless !@loading
				vm.params.status = "realizada"
				return @verifica_objetos(passagem)

			verifica_objetos: (passagem) ->
				console.log 'oiv'

				for objeto in vm.params.objetos
					if objeto.itens.length == 0
						@lixeira_objetos.push(objeto)

				for objeto in vm.params.objetos
					for item in objeto.itens
						if item.item_name == ''
							@lixeira_itens.push(item)

				for objeto in vm.params.objetos
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

				console.log 'passou do return'

				for objeto in @lixeira_objetos
					vm.params.objetos.remove(objeto)

				for objeto in vm.params.objetos
					for item in @lixeira_itens
						objeto.itens.remove(item)

				@lixeira_itens.length = 0

				if @lixeira_itens.length == 0
					console.log 'submit'
					vm.submit(passagem)
				else
					console.log 'return'


		vm.submit = (passagem) ->
			if vm.passagem.edit && vm.passagem.edit.opened
				PassagemServico.update(vm.params)
			else
				PassagemServico.create(vm.params)
			#PassagemServico.list()
			vm.passagem.edit.opened = false
			vm.passagem.acc.opened = true

		vm
]