define (require, exports, module)->
	animate = require('./utility/animate')
	
	class ViewBase extends Backbone.View
		tagName:'div'
		getWidth:->
			@$el.width()
		render:=>
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

		_setActiveItem:(index)->
			@activeIndex = index
			@items[index].$el.addClass('active')
			item.$el.removeClass('active') if i is not index for item,i in @items
			@
		_changeItemByName:(name, options)->
			#TODO: change item by page name
			@

		_changeItemByIndex:(to, options)->
			return @ if  to<0 or to>=@items.length or to is @activeIndex or @busy

			toItem = @items[to]
			
			if options.animate? and not @busy
				@busy = true
				fromItem = @items[@activeIndex]
				fromItem.$el.addClass('fake-active')
				animate(fromItem, toItem, animate.style.swipeRight, =>
					@busy = false
					fromItem.$el.removeClass('fake-active')
				)

			@_setActiveItem(to)
			@

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
			@
		changeItem:(name, options)=>
			if typeof name is 'string'
				return @_changeItemByName(name, options)
			else if typeof name is 'number'
				return @_changeItemByIndex(name, options)
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
		render:->
			@$el.html(_.template(@template, @model.toJSON()))
			@

	class TabItem extends Container
		className:'container tab-item'
		initialize:(options)->
			@title = options.title
			@titleView = new TabItemTitle({model:@model})
		contentRender:->
			@
		render:=>
			@titleView.render()
			@contentRender()
			@

	class TabContainer extends Container
		className:"container tab-container"
		tabTitleContainerTemplate:'<div class="tab-item-title-container"></div>'
		initialize:->
			@contentContainer = new CardContainer
			@items = []
			@
		addItem:(item)->
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
			@$el.html('')
			@$el.append @contentContainer.render().$el
			@_renderTitle()
			

			@


	class CarouselContainer extends CardContainer
		startX:0
		lastX:0
		dragging:false
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
			point = event.touches?[0] ? event
			@startX = @lastX = point.clientX
			@dragging = true
			@startDate = new Date

			@currentItem = @items[@activeIndex]

			@prevItem = @items[@_getPrevItemIndex()]
			@nextItem = @items[@_getNextItemIndex()]


			@viewWidth = @getWidth()

			# @currentItem.$el.css('-webkit-transform', 'translate3d(-100px,0, 0)')
			@

		onDrag:(event)=>
			return @ if not @dragging 
			
			point = event.touches?[0] ? event
			@lastX = point.clientX
			distanceX = @lastX-@startX

			if @dragging
				if distanceX>0
					@nextItem?.$el.removeClass('active')
					@prevItem?.$el
						.addClass('active')
						.css('-webkit-transform', 'translate3d('+(distanceX-@viewWidth)+'px,0, 0)')
						

					@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
						


				else if distanceX<0
					@prevItem?.$el.removeClass('active')

					@nextItem?.$el
						.addClass('active')
						.css('-webkit-transform', 'translate3d('+(@viewWidth + distanceX)+'px,0, 0)')
						

					@currentItem.$el.css('-webkit-transform', 'translate3d('+distanceX+'px,0, 0)')
			@

		endDrag:(event)=>
			return @ if not @dragging

			distanceX = @lastX-@startX
			percentage = distanceX/@viewWidth
			endDate = new Date
			speed =  distanceX/(endDate-@startDate)

			if (percentage>0.35 or speed>0.5) and @prevItem
				@currentItem.$el.removeClass('active')
				@prevItem.$el.css('-webkit-transform', 'translate3d(0,0, 0)')
				@nextItem?.$el.removeClass('active')

				@_setActiveItem(@_getPrevItemIndex())

			else if (percentage<-0.35 or speed<-0.5) and @nextItem
				@currentItem.$el.removeClass('active')
				@prevItem?.$el.removeClass('active')
				@nextItem.$el.css('-webkit-transform', 'translate3d(0, 0, 0)')

				@_setActiveItem(@_getNextItemIndex())
			else
				@currentItem.$el.css('-webkit-transform', 'translate3d(0 ,0, 0)')
				@prevItem?.$el.removeClass('active')
				@nextItem?.$el.removeClass('active')

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
		# container = new CarouselContainer({id:'main-container'})
		# 	.addItem(new Panel {id:'panel1'})
		# 	.addItem(new Panel {id:'panel2'})
		# 	.addItem(new Panel {id:'panel3'})
		# 	.addItem(new Panel {id:'panel4'})
		# 	.render()

		console.log container

		container = new TabContainer({id:'main-container'})
			.addItem(new TabItem({id:'panel1', model:new Backbone.Model({title:'superowlf'})}))
			.addItem(new TabItem({id:'panel2', model:new Backbone.Model({title:'superowlf'})}))
			.addItem(new TabItem({id:'panel3', model:new Backbone.Model({title:'superowlf'})}))
			.addItem(new TabItem({id:'panel4', model:new Backbone.Model({title:'superowlf'})}))
			.render()


		$('body')
			.append(container.el)
			.on('touchmove', (e)->e.preventDefault())
			# .click->container.changeNextItem()
	)
	module.exports