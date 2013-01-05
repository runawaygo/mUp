define (require, exports, module)->
	ViewBase = require('./ViewBase')
	class Container extends ViewBase
		className:'container'
		initialize:(@options)->
			super(@options)
			@items = @options?.items ? []
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
		render:=>
			super()
			@$el.addClass(@options.layout) if @options?.layout
			@$el.append item.render().el for item in @items
			@

	exports = module.exports = Container
	exports