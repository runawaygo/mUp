define (require, exports, module)->
	TabContainer = require('./TabContainer')
	CarouselContainer = require('./CarouselContainer')

	class CarouselTabContainer extends TabContainer
		className:"container tab-container carousel-tab-container"
		tabTitleContainerTemplate: '<div class="tab-item-title-container"></div>'
		tabPositionBottom: false
		disableIndicator: true
		initialize:(@options)->
			super(@options)
			@contentContainer = new CarouselContainer {disableIndicator: @disableIndicator}
			@

	exports = module.exports = CarouselTabContainer
	exports