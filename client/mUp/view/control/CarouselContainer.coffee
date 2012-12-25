define (require, exports, module)->
	CardContainer = require('./CardContainer')
	class CarouselContainer extends CardContainer
		startX:0
		lastX:0
		dragging:false
		className:"container card-container carousel-container"
		indicatorTemplate:'<div class="carousel-indicator-container"></div>'
		indicatorItem:'<div class="carousel-indicator-item"></div>'
		events:
			'mousedown':'startDrag'
			'mousemove':'onDrag'
			'mouseup':'endDrag'

			'touchstart':'startDrag'
			'touchmove':'onDrag'
			'touchend':'endDrag'
		initialize:(@options)->
			super(@options)
			@viewWidth=null
			@

		startDrag:(event)=>
			return @ if @isAnimating

			point = event.touches?[0] ? event
			@startX = @lastX = point.clientX
			@dragging = true
			@startDate = new Date

			@viewWidth ?= @getWidth()

			@currentItem = @items[@activeIndex]

			@prevItem = @items[@_getPrevItemIndex()]
			@prevItem?.$el.addClass('active')

			@nextItem = @items[@_getNextItemIndex()]
			@nextItem?.$el.addClass('active')

			# @currentItem.$el.css('-webkit-transform', 'translate3d(-100px,0, 0)')
			@

		onDrag:(event)=>
			return @ if not @dragging 
			
			point = event.touches?[0] ? event
			@lastX = point.clientX
			distanceX = @lastX-@startX

			if @dragging
				if Math.abs(distanceX) >1
					@prevItem?.$el.css('-webkit-transform', 'translate3d('+(distanceX-@viewWidth)+'px,0, 0)')
					@nextItem?.$el.css('-webkit-transform', 'translate3d('+(@viewWidth + distanceX)+'px,0, 0)')
					@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
				else return

				if 20>Math.abs(distanceX)>1
					@prevItem?.$el.css('-webkit-transform', 'translate3d('+(distanceX-@viewWidth)+'px,0, 0)')
					@nextItem?.$el.css('-webkit-transform', 'translate3d('+(@viewWidth + distanceX)+'px,0, 0)')
					@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
				else if distanceX>20
					@prevItem?.$el.css('-webkit-transform', 'translate3d('+(distanceX-@viewWidth)+'px,0, 0)')
					@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
				else if distanceX<-20
					@nextItem?.$el.css('-webkit-transform', 'translate3d('+(@viewWidth + distanceX)+'px,0, 0)')
					@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
					
			@

		_swipeAnimate:(mainItem, subItem, uselessItem, direction, callback)->
			@isAnimating = true
			animateClass = 'animating-100'
			subItem?.$el
				.addClass(animateClass)
				.css('-webkit-transform', 'translate3d('+(@viewWidth*direction)+'px,0,0)')

			mainItem.$el
				.addClass(animateClass)
				.css('-webkit-transform', 'translate3d(0,0,0)')

			setTimeout((=>
				mainItem.$el.removeClass(animateClass)
				subItem?.$el.removeClass('active '+animateClass)
				uselessItem?.$el.removeClass('active')
				callback?()
				@isAnimating =false
			),100)
			
			@

		endDrag:(event)=>
			return @ if not @dragging

			distanceX = @lastX-@startX
			percentage = distanceX/@viewWidth
			endDate = new Date
			speed =  distanceX/(endDate-@startDate)

			if (percentage>0.35 or speed>0.5) and @prevItem
				@_swipeAnimate @prevItem,@currentItem,@nextItem,1,=>@_setActiveItem(@_getPrevItemIndex())
			else if (0<percentage)
				@_swipeAnimate @currentItem,@prevItem,@nextItem,-1
			else if (percentage<-0.35 or speed<-0.5) and @nextItem
				@_swipeAnimate @nextItem,@currentItem,@prevItem,-1,=>@_setActiveItem(@_getNextItemIndex())
				
			else if (percentage<0)
				@_swipeAnimate @currentItem,@nextItem,@prevItem,1

			@dragging = false

			@

		_setActiveItem:(item)->
			super(item)

			indicatorItems = @$el.find('.carousel-indicator-item')
			indicatorItems.removeClass('active')
			$(indicatorItems[@activeIndex]).addClass('active')

			item.$el.removeClass('fake-active') for item in @items
			@items[@_getPrevItemIndex()]?.$el
				.addClass('fake-active')
				.css('-webkit-transform', 'translate3d('+(-@viewWidth)+'px,0, 0)')

			@items[@_getNextItemIndex()]?.$el
				.addClass('fake-active')
				.css('-webkit-transform', 'translate3d('+@viewWidth+'px,0, 0)')


		_renderItem:(panel, i)->
			indicatorContainer = @$el.find('.carousel-indicator-container')
			indicatorContainer.append(@indicatorItem)
			super(panel, i)
		render:=>
			@viewWidth ?= @getWidth()
			console.log @viewWidth
			@$el.html('')
			@$el.append(@indicatorTemplate)
			super()

			# @_renderItem panel,i for panel, i in @items
	exports = module.exports = CarouselContainer
	exports