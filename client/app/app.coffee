define (require, exports, module)->
	animate = require('./utility/animate')
	
	class ViewBase extends Backbone.View
		tagName:'div'
		render:=>
			@

	class Panel extends ViewBase
		className:"panel"

	class CardContainer extends ViewBase
		className:"card-container"
		items:[]
		initialize:->
			@activeIndex = -1

			@items.push(new Panel {id:'panel1'})
			@items.push(new Panel {id:'panel2'})
			@ 
		events:
			'click':"changeNextItem"

		changeItem:(name)=>
			if typeof name is 'string'
				return @_changeItemByName(name)
			else if typeof name is 'number'
				return @_changeItemByIndex(name)
			else 
				throw "Invalid args type for page index or page name"
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

		changeNextItem:=>
			to = @activeIndex + 1
			if to is @items.length then to=0
			@changeItem(to)
			@

		render:=>
			@activeIndex = 0 if @items.length > 0
			
			for panel, i in @items
				@$el.append(panel.render().el)
				panel.$el.addClass('active') if i is 0
				
			@


	class TabContainer extends ViewBase

	class CarouselContainer extends ViewBase

	class Page extends ViewBase
		className:'page'
		
	$(->
		$('body').on('touchmove', (e)-> 
			e.preventDefault()
		)

		container = new CardContainer({id:'main-container'})
		container.render()
		$('body').append(container.el)
	)
	module.exports