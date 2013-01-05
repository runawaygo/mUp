define (require, exports, module)->
	ViewBase = require('./ViewBase')
	class Container extends ViewBase
		className:'container'
		layout:'vbox'
		initialize:(@options)->
			super(@options)
			@items = @options?.items ? []
			@$el.addClass(@options.layout) if @options?.layout
			@ 
		getItemIndex:(actionItem)->
			for item,i in @items
				return i if actionItem is item
		active:->
			@trigger('show')
			@$el.addClass('active')
			@
		deactive:->
			@trigger('hide')
			setTimeout(=>
				@$el.removeClass('active')
			,100)
			
			@
		_renderItem:(panel, i)->
			@$el.append(panel.render().el)
			@

		render:=>
			super()
			return @ if @items.length is 0
			@_renderItem panel,i for panel, i in @items
			@

	exports = module.exports = Container
	exports