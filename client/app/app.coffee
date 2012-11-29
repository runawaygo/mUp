define (require, exports, module)->

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

		changeItem:(to)=>
			if  to<0 or to>=@items.length or to is @activeIndex then return @
			fromItem = @items[@activeIndex]
			toItem = @items[to]

			fromItem.$el.removeClass('active')
			toItem.$el.addClass('active')

			@activeIndex = to
			@

		changeNextItem:=>
			to = @activeIndex + 1
			if to is @items.length then to =0
			@changeItem(to)
			@

		render:=>
			@activeIndex = 0 if @items.length > 0
			
			for panel, i in @items
				@$el.append(panel.render().el)
				panel.$el.addClass('active') if i is 0
				
			@

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