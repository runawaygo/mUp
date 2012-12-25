define (require, exports, module)->
	Container = require('./Container')
	TabItemTitle = require('./TabItemTitle')

	class TabItem extends Container
		initialize:(@options)->
			super(@options)
			@title = options.title
			@titleView = new TabItemTitle({model:@model})
			@titleView.on('active',=>@trigger('active', @))
			# console.log @options
			@contentView = @options.contentView ? new Container(@options)
			@
		active:=>
			@titleView.active()
			@contentView.active()
			@

		deactive:=>
			@titleView.deactive()
			@contentView.deactive()
			@
	exports = module.exports = TabItem
	exports