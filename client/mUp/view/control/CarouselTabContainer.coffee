define (require, exports, module)->
  animate = require('../../utl/animate')
  TabContainer = require('./TabContainer')
  CarouselContainer = require('./CarouselContainer')

  class CarouselTabContainer extends TabContainer
    className:"container tab-container carousel-tab-container"
    tabTitleContainerTemplate: '<div class="tab-item-title-container"></div>'
    tabPositionBottom: false
    disableIndicator: true
    initialize:(@options)->
      super(@options)
      @
    initContentContainer:-> 
      @contentContainer = new CarouselContainer {disableIndicator: @disableIndicator}
      @contentContainer.on('activeIndexChnaged', @_onContainerActiveIndexChanged)

    _onContainerActiveIndexChanged:(index)=>
      @changeItem(index)

    #override '_changeContainerItem' method of TabContainer
    _changeContainerItem:(index)->
      animateStyle = if @activeIndex < index then animate.style.swipeLeft else animate.style.swipeRight
      @contentContainer.off('activeIndexChnaged', @_onContainerActiveIndexChanged)
      @contentContainer.changeItem(index, {animate:animateStyle})
      @contentContainer.on('activeIndexChnaged', @_onContainerActiveIndexChanged)


  exports = module.exports = CarouselTabContainer
  exports