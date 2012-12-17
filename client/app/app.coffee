define (require, exports, module)->
	animate = require('./utility/animate')

	class Plugin

	class Activable extends Plugin

	# class PressingStyle extends Plugin
	# 	events:

	# 	init:(@view)->
	# 	destory:->

	class ViewBase extends Backbone.View
		tagName:'div'
		template:''
		initialize:(@options)->
			@template = @options?.template ? @template

			@
		getWidth:->
			@$el.width()
		active:->
			@$el.addClass('active')
			@
		deactive:->
			@$el.removeClass('active')
			@
		render:=>
			@$el.html(@template)
			@

	class Model extends Backbone.Model
	class Container extends ViewBase
		className:'container'

	class Panel extends Container
		className:"panel"

	class CardContainer extends Container
		className:"container card-container"
		items:[]
		activeIndex:-1
		isInfinite:false
		initialize:->
			@ 

		_setActiveItem:(toActiveItem)->
			return @ if @items[@activeIndex] is toActiveItem

			toActiveItem = @items[toActiveItem] if typeof toActiveItem is 'number'

			for item,i in @items
				if item is toActiveItem
					item.active()
					@activeIndex = i
				else
					item.deactive()
			@
		_changeItem:(toItem, options)->
			if options?.animate? and not @busy
				@busy = true
				fromItem = @items[@activeIndex]
				fromItem.$el.addClass('fake-active')
				animate(fromItem, toItem, animate.style.swipeRight, =>
					@busy = false
					fromItem.$el.removeClass('fake-active')
				)

			@_setActiveItem(toItem)

		_changeItemByName:(name, options)->
			#TODO: change item by page name
			@

		_changeItemByIndex:(to, options)->
			return @ if  to<0 or to>=@items.length or to is @activeIndex or @busy
			@_changeItem(@items[to])

		_getNextItemIndex:=> 
			nextItemIndex = @activeIndex+1
			count = @items.length
			if @isInfinite
				nextItemIndex%count
			else
				if nextItemIndex is count then null else nextItemIndex

		_getPrevItemIndex:=> 
			nextItemIndex = @activeIndex-1
			count = @items.length
			if @isInfinite
				(nextItemIndex+count)%count
			else
				if nextItemIndex is -1 then null else nextItemIndex

		addItem:(item)->
			@items.push(item)
			item.on('active',@changeItem)
			@
		changeItem:(name, options)=>
			if typeof name is 'string'
				return @_changeItemByName(name, options)
			else if typeof name is 'number'
				return @_changeItemByIndex(name, options)
			else if typeof name is 'object'
				return @_changeItem(name, options)
			else
				throw "Invalid args type for page index or page name"
			@

		changeNextItem:=>
			return null if @items.length is 1
			@changeItem(@_getNextItemIndex())
			@

		_renderItem:(panel, i)->
			@$el.append(panel.render().el)
			@

		render:=>
			return @ if @items.length is 0
			
			@_renderItem panel,i for panel, i in @items
			@_setActiveItem(0)
			@

	class TabItemTitle extends Container
		className:'container tab-item-title'
		template:'<%= title %>'
		events:
			'touchstart': 'addPressingClass'
			'mousedown'	: 'addPressingClass'
			'touchend'	: 'removePressingClass'
			'mouseup'	: 'removePressingClass'
			'tap'		: 'onTap'
			'click'		: 'onTap'
		onTap:=>
			@trigger 'active'
			@
		addPressingClass:=>
			@$el.addClass('pressing')
			@
		removePressingClass:=>
			@$el.removeClass('pressing')
			@
		
		render:->
			super()
			@$el.html(_.template(@template, @model.toJSON()))
			@

	class TabItem extends Container
		className:'container tab-item'
		initialize:(@options)->
			super(@options)
			console.log @template			
			@title = options.title
			@titleView = new TabItemTitle({model:@model})
			@titleView.on('active',=>@trigger('active', @))
			@
		active:=>
			@titleView.active()
			super()

		deactive:=>
			@titleView.deactive()
			super()

		render:=>
			super()
			@titleView.render()
			@

	class TabContainer extends Container
		className:"container tab-container"
		tabTitleContainerTemplate: '<div class="tab-item-title-container"></div>'
		tabPositionBottom: true

		initialize:->
			@contentContainer = new CardContainer
			@items = []
			@
		addItem:(item)->
			index = @items.length
			@items.push item
			@contentContainer.addItem item
			@

		_renderTitle:->
			@$el.append @tabTitleContainerTemplate
			@$titleContainer = @$el.find('.tab-item-title-container')
			for panel in @items
				@$titleContainer.append(panel.titleView.$el)
			@

		render:=>
			super()
			if @tabPositionBottom
				@$el.append @contentContainer.render().$el
				@_renderTitle()
			else
				@_renderTitle()
				@$el.append @contentContainer.render().$el
			@


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

		startDrag:(event)=>
			return @ if @isAnimating

			point = event.touches?[0] ? event
			@startX = @lastX = point.clientX
			@dragging = true
			@startDate = new Date

			@currentItem = @items[@activeIndex]

			@prevItem = @items[@_getPrevItemIndex()]
			@prevItem?.$el.addClass('active')

			@nextItem = @items[@_getNextItemIndex()]
			@nextItem?.$el.addClass('active')

			@viewWidth = @getWidth()

			# @currentItem.$el.css('-webkit-transform', 'translate3d(-100px,0, 0)')
			@

		onDrag:(event)=>
			return @ if not @dragging 
			
			point = event.touches?[0] ? event
			@lastX = point.clientX
			distanceX = @lastX-@startX

			if @dragging
				if distanceX>1 or distanceX<-1
					@prevItem?.$el.css('-webkit-transform', 'translate3d('+(distanceX-@viewWidth)+'px,0, 0)')
					@nextItem?.$el.css('-webkit-transform', 'translate3d('+(@viewWidth + distanceX)+'px,0, 0)')
					@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
			@

		_swipeAnimate:(mainItem, subItem, uselessItem, direction, callback)->
			@isAnimating = true
			subItem?.$el
				.addClass('animating')
				.css('-webkit-transform', 'translate3d('+(@viewWidth*direction)+'px,0,0)')

			mainItem.$el
				.addClass('animating')
				.css('-webkit-transform', 'translate3d(0,0,0)')

			setTimeout((=>
				mainItem.$el.removeClass('animating')
				subItem?.$el.removeClass('active animating')
				uselessItem?.$el.removeClass('active')
				callback?()
				@isAnimating =false
			),250)
			
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

		_setActiveItem:(i)->
			indicatorItems = @$el.find('.carousel-indicator-item')
			$(indicatorItems[@activeIndex]).removeClass('active')
			$(indicatorItems[i]).addClass('active')

			super(i)

		_renderItem:(panel, i)->
			indicatorContainer = @$el.find('.carousel-indicator-container')
			indicatorContainer.append(@indicatorItem)
			super(panel, i)
		render:=>
			@$el.html('')
			@$el.append(@indicatorTemplate)
			super()
			
			



	class Page extends Container
		className:'page container'
		
	$(->
		container = new CarouselContainer({id:'main-container'})
			# .addItem(new Panel {id:'panel1'})
			# .addItem(new Panel {id:'panel2'})
			# .addItem(new Panel {id:'panel3'})
			# .addItem(new Panel {id:'panel4'})
		
		# container = new TabContainer({id:'main-container'})
			.addItem(new TabItem({
				id:'panel1', 
				template:require('./templates/test.html'), 
				model:new Backbone.Model({title:'superwolf'})
			}))
			.addItem(new TabItem({id:'panel2', model:new Backbone.Model({title:'superwolf'})}))
			.addItem(new TabItem({id:'panel3', model:new Backbone.Model({title:'superwolf'})}))
			.addItem(new TabItem({id:'panel4', model:new Backbone.Model({title:'superwolf'})}))
		
		container.render()


		$('body')
			.append(container.el)
			.on('touchmove', (e)->e.preventDefault())
			# .click->container.changeNextItem()
	)
	module.exports