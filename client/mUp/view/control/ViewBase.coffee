define (require, exports, module)->
	class ViewBase extends Backbone.View
		tagName:'div'
		template:''
		initialize:(@options)->
			@template = @options?.template ? @template
			@
		getWidth:->
			width = @$el.width()
			if width is 0 then width = $('body').width()
			width
		
		render:=>
			@$el.html(@template)
			@
	exports = module.exports = ViewBase
	exports
