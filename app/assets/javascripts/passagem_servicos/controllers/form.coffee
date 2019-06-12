console.log('formCtrl')
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

		vm.formCtrl =

			set_perfil: ->
				scAlert.open
					title: 'Atenção!'
					messages: [
						{ msg: 'O perfil foi alterado. O que deseja fazer com os objetos?' }
					]
					buttons: [
						{ label: 'Mesclar', color: 'blue', tooltip: 'Mescla, por categoria, os objetos abaixo com os objetos do perfil', action: -> vm.formCtrl.mesclarObjetos() },
						{ label: 'Sobreescrever', color: 'yellow', tooltip: 'Sobreescreve os objetos abaixo pelos objetos do perfil', action: -> vm.formCtrl.sobreescreverObjetos() },
						{ label: 'Cancelar', color: 'gray' },
					]

			mesclarObjetos:  ->

			sobreescreverObjetos: ->

			addObjeto: ->
				vm.params.objetos.unshift({ categoria: undefined, itens: [] })

			rmvObjeto: (objeto) ->
				vm.params.objetos.remove(objeto)

			addItem: (objeto)->
				objeto.itens.push({ item_name: '', item_qtd: undefined })

			rvmitem: (objeto, item)->
				objeto.itens.remove(item)

			set_categoria: (objeto) ->
				count = 0
				for item in vm.params.objetos
					if objeto.categoria.nome == item.categoria.nome
						count++;
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

			salvar: ->
				vm.params.status = "pendente"
				return vm.submit

			salvar_e_passar: ->
				vm.params.status = "realizada"
				return vm.submit

		vm.submit = ->
			PassagemServico.create(vm.params)

		vm
]