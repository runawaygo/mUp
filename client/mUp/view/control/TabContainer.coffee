define (require, exports, module)->
	Container = require('./Container')
	CardContainer = require('./CardContainer')
	class TabContainer extends Container
		className:"container tab-container"
		tabTitleContainerTemplate: '<div class="tab-item-title-container"></div>'
		tabPositionBottom: true

		initialize:(@options)->
			super(@options)
			@activeIndex = -1
			@contentContainer = new CardContainer
			@

		addItem:(item)->
			index = @items.length
			@items.push item
			@contentContainer.addItem item.contentView

			item.on('active',=>
				@changeItem(@getItemIndex(item))
			)
			@

		changeItem:(index)=>
			return if index<0 or index>@items.length-1
			for item,i in @items
				if i is index
					item.active()
				else
					item.deactive()
			
			@contentContainer.changeItem(@items[index].contentView)
			@activeIndex = index
			@

		_renderTitle:->
			@$el.append @tabTitleContainerTemplate
			@$titleContainer = @$el.find('.tab-item-title-container')
			@$titleContainer.append(panel.titleView.render().$el) for panel in @items
				
			@

		render:=>
			@changeItem(0) if @activeIndex is -1
			if @tabPositionBottom
				@$el.append @contentContainer.render().$el
				@_renderTitle()
			else
				@_renderTitle()
				@$el.append @contentContainer.render().$el
			@

	exports = module.exports = TabContainer
	exports