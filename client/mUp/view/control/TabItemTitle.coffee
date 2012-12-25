define (require, exports, module)->
	Container = require('./Container')
	class TabItemTitle extends Container
		className:'container tab-item-title'
		template:'<%= title %>'
		events:
			'touchstart': 'addPressingClass'
			'mousedown'	: 'addPressingClass'

			'touchend'	: 'removePressingClass'
			'mouseup'	: 'removePressingClass'

			'tap'		: 'onTap'
			'click'		: 'onTap'
		onTap:=>
			@trigger 'active'
			@
		addPressingClass:=>
			@$el.addClass('pressing')
			@
		removePressingClass:=>
			@$el.removeClass('pressing')
			@
		
		render:->
			super()
			@$el.html(_.template(@template, @model.toJSON()))
			@
	exports = module.exports = TabItemTitle
	exports