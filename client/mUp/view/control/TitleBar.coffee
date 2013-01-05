define (require, exports, module)->
	Container = require('./Container')

	class TitleBar extends Container
		className:'title-bar'
		template:'<div class="left-panel"></div><h1><%= title %></h1><div class="right-panel"></div>'
		leftPanelTemplate:'<button>superwolf-left</button>'
		rightPanelTemplate:'<button>superwolf-right</button><button>superwolf-right</button>'
		initialize:(@options)->
			super(@options)
			@title = options?.title
			@
		setTitle:(title)->
			@$('h1').html(title)
			@
		setLeftPanel:(view)->
			@leftPanel.html(view)
			@
		setRightPanel:(view)->
			@rightPanel.html(view)
			@			
		render:=>
			super()
			@$el.html(_.template(@template, {title:@title}))

			@leftPanel = @$el.find('.left-panel') 
			# @leftPanel.append item.render().el for item in @leftItems
			@leftPanel.append @leftPanelTemplate

			@rightPanel = @$el.find('.right-panel') 
			# @rightPanel.append item.render().el for item in @leftItems
			@rightPanel.append @rightPanelTemplate

			@

	exports = module.exports = TitleBar
	exports