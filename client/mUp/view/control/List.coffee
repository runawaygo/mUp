define (require, exports, module)->
	Container = require('./Container')
	class List extends Container
		className:'container list'
		template:'<div class="wrapper"><div class="content-container"></div></div>'
		@startPoint:{x:0, y:0}
		initialize:(@option)->
			super(@option)
			@initEvent()
			@on('show', @initList)
			@
		initEvent:=>
			# @$el.on({
			# 	'mousedown':@startDrag
			# 	'mousemove':@onDrag
			# 	'mouseup':@endDrag

			# 	'touchstart':@startDrag
			# 	'touchmove':@onDrag
			# 	'touchend':@endDrag
			# })
			@
			
		initList:=>
			return @ if @scrollVierw
			setTimeout(=>
				@scrollVierw = new iScroll(@$el.find('.wrapper')[0])
			,50)
		startDrag:(event)=>
			point = event.touches?[0] ? event
			@startPoint = {x:point.clientX, y:point.clientY}
			@dragging = true
			@

		onDrag:(event)=>
			return @ if not @dragging 
			
			point = event.touches?[0] ? event
			if Math.abs(point.clientX-@startPoint.x)<Math.abs(point.clientY-@startPoint.y)
				console.log 'stop'
				
				event.stopPropagation()
			@

		endDrag:(event)=>
			@dragging = false
			@
		addItem:(item)=>
			@items.push(item)
			@$('.content-container').append(item.el)
			@

		render:=>
			super()
