define (require, exports, module)->
	animate = require('../../utl/animate')
	Container = require('./Container')
	TitleBar = require('./TitleBar')
	
	class NavigationContainer extends Container
		className:"container navigation-container"
		contentContainerTemplate:"<div class='content-container'></div>"
		initialize:(@options)->
			super(@options)
			@titleBar = new TitleBar
			@currentItem = @items.pop()
			@

		push:(item, options)->
			return @ if @busy
			
			@busy = true
			oldItem = @currentItem
			@currentItem = item
			@renderCurrentItem()

			console.log animate
			if options?.animate?
				@titleBar.$('h1').animate(animate.style.swipeLeft.in, {duration: 200})
				animate(oldItem, @currentItem, animate.style.swipeLeft, =>
					@busy = false
					oldItem.$el.remove()
					@items.push(oldItem)
				)
			else
				@busy = false
				oldItem.$el.remove()
				@items.push(oldItem)
			@

		pop:(options)->
			return @ if @busy

			@busy = true
			oldItem = @currentItem
			@currentItem = @items.pop()
			@currentItem.$el.remove()
			@renderCurrentItem()

			if options?.animate?
				@titleBar.$('h1').animate(animate.style.swipeRight.in, {duration: 200})
				animate(oldItem, @currentItem, animate.style.swipeRight, =>
					@busy = false
					oldItem.$el.remove()
					@items.push(oldItem)
					console.log 'animate'
				)
			else
				@busy = false
				oldItem.$el.remove()
				@items.push(oldItem)
				console.log 'sb'

			oldItem
		
		renderCurrentItem:->
			@currentItem.render() if @currentItem.el.innerHTML is ''	
			@$('.content-container').append(@currentItem.el)
			@titleBar.setTitle(@currentItem.options.title)
			@titleBar.setLeftPanel('<button>back</button>')
			@titleBar.setRightPanel('<button>detail</button>')
			@

		render:=>
			@$el.append(@titleBar.render().el)
			@$el.append(@contentContainerTemplate)
			@renderCurrentItem()
			@

	exports = module.exports = NavigationContainer
	exports
