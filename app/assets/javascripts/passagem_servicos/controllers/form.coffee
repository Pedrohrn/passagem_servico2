angular.module('scApp').lazy
.controller 'PassagemServico::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'PassagemServico'
	(scModal, scAlert, scToggle, scTopMessages, Templates, PassagemServico)->
		vm = this

		vm
]