angular.module('scApp').lazy
.factory 'PassagemServicos::FormFactory',
	(scAlert)->
		->
			baseObj =
				opened: false

				init: (passagem)->
					@passagem = passagem
					@opened = true

				close: ->
					@passagem = {}
					@opened = false

				cancelar: ->
					scAlert.open
						title: 'Deseja mesmo fechar o formulário? Dados não salvos serão perdidos.'
						buttons: [
							{ label: 'Sim', color: 'yellow', action: => @close() },
							{ label: 'Não', color: 'gray' },
						]

			baseObj
