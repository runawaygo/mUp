define (require, exports, module)->
	animate = require('./utility/animate')
	
	class ViewBase extends Backbone.View
		tagName:'div'
		getWidth:->
			@$el.width()
		render:=>
			@

	class Panel extends ViewBase
		className:"panel"
		

	class CardContainer extends ViewBase
		className:"card-container"
		items:[]
		@activeIndex:-1
		initialize:->
			@ 

		addItem:(item)=>
			@items.push(item)
			@
		changeItem:(name)=>
			if typeof name is 'string'
				return @_changeItemByName(name)
			else if typeof name is 'number'
				return @_changeItemByIndex(name)
			else 
				throw "Invalid args type for page index or page name"
			@

		_changeItemByName:(name)->
			#TODO: change item by page name
			@

		_changeItemByIndex:(to)->
			return @ if  to<0 or to>=@items.length or to is @activeIndex or @busy

			@busy = true

			fromItem = @items[@activeIndex]
			toItem = @items[to]

			toItem.$el.addClass('active')

			animate(fromItem, toItem, animate.style.swipeRight, =>
				@busy = false
				fromItem.$el.removeClass('active')
			)

			@activeIndex = to
			@

		_getNextItemIndex:=> (@activeIndex+1) % @items.length

		_getPrevItemIndex:=> (@activeIndex+@items.length-1) % @items.length


		changeNextItem:=>
			return null if @items.length is 1

			@changeItem(@_getNextItemIndex())
			@

		render:=>
			@activeIndex = 0 if @items.length > 0
			
			for panel, i in @items
				@$el.append(panel.render().el)
				panel.$el.addClass('active') if i is 0
				
			@


	class TabContainer extends CardContainer

	class CarouselContainer extends CardContainer
		startX:0
		lastX:0
		dragging:false
		events:
			'mousedown':'startDrag'
			'mousemove':'onDrag'
			'mouseup':'endDrag'
		startDrag:(event)=>
			point = event.touches?[0] ? event
			@startX = @lastX = point.clientX
			@dragging = true

			@currentItem = @items[@activeIndex]
			console.log @_getPrevItemIndex()
			console.log @_getNextItemIndex()		

			@prevItem = @items[@_getPrevItemIndex()]
			@nextItem = @items[@_getNextItemIndex()]

			console.log @prevItem
			console.log @nextItem

			@viewWidth = @getWidth()

			@currentItem.$el.css('-webkit-transform', 'translate3d(-100px,0, 0)')
			@

		onDrag:(event)=>
			return @ if not @dragging 

			
			point = event.touches?[0] ? event
			@lastX = point.clientX
			distanceX = @lastX-@startX

			console.log @startX
			console.log @lastX
			console.log distanceX

			@prevItem.$el.addClass('active')
			@nextItem.$el.addClass('active')

			if @swiping
				@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
				if distanceX>10		
					@prevItem.$el.css('-webkit-transform', 'translate3d('+(distanceX-@viewWidth)+'px,0, 0)')
				else if distanceX<-10
					@nextItem.$el.css('-webkit-transform', 'translate3d('+(distanceX-@viewWidth)+'px,0, 0)')
			@

		endDrag:(event)=>					
			return @ if not @dragging

			distanceX = @lastX-@startX
			percentage = distanceX/@viewWidth

			if percentage>0.4
				@currentItem.$el.removeClass('active').css('-webkit-transform', 'translate3d('+(-@viewWidth)+'px,0, 0)')
				@prevItem?.$el.css('-webkit-transform', 'translate3d(0,0, 0)')
				@nextItem?.$el.removeClass('active').css('-webkit-transform', 'translate3d('+@viewWidth+'px,0, 0)')

			else if percentage<-0.4
				@currentItem.$el.removeClass('active').css('-webkit-transform', 'translate3d('+@viewWidth+'px,0, 0)')
				@prevItem?.$el.removeClass('active').css('-webkit-transform', 'translate3d('+(-@viewWidth)+'px,0, 0)')
				@nextItem?.$el.css('-webkit-transform', 'translate3d(0, 0, 0)')
			else
				@currentItem.$el.css('-webkit-transform', 'translate3d(0 ,0, 0)')
				@prevItem?.$el.removeClass('active').css('-webkit-transform', 'translate3d('+(-@viewWidth)+'px,0, 0)')
				@nextItem?.$el.removeClass('active').css('-webkit-transform', 'translate3d('+@viewWidth+'px,0, 0)')

			@swiping = false

			@

	class Page extends ViewBase
		className:'page'
		
	$(->
		container = new CarouselContainer({id:'main-container'})
			.addItem(new Panel {id:'panel1'})
			.addItem(new Panel {id:'panel2'})
			.render()

		console.log container

		$('body')
			.append(container.el)
			.on('touchmove', (e)->e.preventDefault())
			# .click->container.changeNextItem()
	)
	module.exports