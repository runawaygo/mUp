define (require, exports, module)->
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
	exports = module.exports = ViewBase
	exports
