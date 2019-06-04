angular.module('scApp').lazy
.controller 'PassagemServico::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'PassagemServico'
	(scModal, scAlert, scToggle, scTopMessages, Templates, PassagemServico)->
		vm = this

		vm
]