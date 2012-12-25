define (require, exports, module)->
	ViewBase = require('./ViewBase')
	class Container extends ViewBase
		className:'container'
		initialize:(@options)->
			super(@options)
			@items = []
			@ 
		getItemIndex:(actionItem)->
			for item,i in @items
				return i if actionItem is item
	exports = module.exports = Container
	exports