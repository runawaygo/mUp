define (require, exports, module)->
	# animate = (fromItem,toItem, callback)->
	# 	fromItem.$el.addClass("animated rollOut");
	# 	setTimeout(=> 
	# 		fromItem.$el.removeClass('active animated rollOut');
	# 		toItem.$el.removeClass('animated rollIn');
	# 		callback()
	# 	,1000)
		
	# 	toItem.$el.addClass('active animated rollIn')

	animate = (fromItem, toItem, style, callback)->
		fromItem.$el.animate(style.out, {duration: 200})
		toItem.$el.animate(style.in, {duration: 200,complete:->callback()})

	animate.style = 
		swipeLeft:
			in:"swipe-left-in"
			out:"swipe-left-out"
		swipeRight:
			in:"swipe-right-in"
			out:"swipe-right-out"
		
	exports = animate
	exports