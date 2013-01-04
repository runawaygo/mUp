define (require, exports, module)->
	Container = require('./Container')

	class TitleBar extends Container
		className:'title-bar'
		template:'<div class="left-panel"></div><h1><%= title %></h1><div class="right-panel"></div>'
		leftItems:[]
		rightItems:[]
		initialize:(@options)->
			super(@options)
			@title = options.title
			@
		render:=>
			@$el.html(_.template(@template, {title:@title}))
			
			@leftPanel = @$el.find('.left-panel') 
			@leftPanel.append item.render().el for item in @leftItems

			@rightPanel = @$el.find('.right-panel') 
			@rightPanel.append item.render().el for item in @leftItems

			@

	exports = module.exports = TitleBar
	exports