define (require, exports, module)->
	Container = require('./Container')
	class Toolbar extends Container
		className:'toolbar'
		layout:'hbox'
		template:''
		buttonTemplate:_.template('<a class="btn" id="<% this.id?this.id:"" %>"><%= title %></a>')

		initialize:(@option)->
			super(@option)
			@

		_renderItem:(panel, i)->
			@$el.append(@buttonTemplate(panel))
			@
		render:=>
			super()
			@

	exports = module.exports = Toolbar
	exports