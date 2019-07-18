angular.module('scApp').lazy
.controller 'PassagemServicos::ShowCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'PassagemServico', 'PassagemServicos::FormFactory'
	(scModal, scAlert, scToggle, scTopMessages, Templates, PassagemServico, FormFactory)->
		vm = this
		vm.templates = Templates

		vm.formFact = new FormFactory

		vm.passagem = null

		vm.init = (passagem)->
			vm.passagem = passagem

			vm.passagem.acc = new scToggle
			vm.passagem.menu = new scToggle()
			vm.passagem.passar_servico_modal = new scModal()
			vm.passagem.log = new scModal()

		vm.accToggle = ->
			unless vm.passagem.acc.opened
				vm.passagem.acc.open()
				carregarPassagem()
				return

			return vm.formFact.cancelar() if vm.formFact.opened
			vm.passagem.acc.toggle()

		vm.formCtrl =
			open: ->
				return vm.formFact.cancelar() if vm.formFact.opened
				vm.passagem.acc.open()

				carregarPassagem ->
					vm.formFact.init(vm.passagem)

		carregarPassagem = (callback)->
			return callback?() if vm.passagem.carregada || vm.passagem.carregando
			vm.passagem.carregando = true

			PassagemServico.show vm.passagem,
				(data)=>
					vm.passagem.carregada  = true
					vm.passagem.carregando = false

					angular.extend vm.passagem, data.passagem_servico

					callback?()

		vm
]