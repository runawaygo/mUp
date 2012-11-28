define (require, exports, module)->
	$(->
		$('body').on('touchmove', (e)-> 
			e.preventDefault()
		)
	)
	module.exports