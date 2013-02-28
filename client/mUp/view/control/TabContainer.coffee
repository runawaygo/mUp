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
      @initContentContainer()     
      @

    initContentContainer:-> @contentContainer = new CardContainer

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
        if i is index then item.active() else item.deactive()

      @_changeContainerItem(index)

      @activeIndex = index
      @

    _changeContainerItem:(index)-> @contentContainer.changeItem(index)


    _renderTitle:->
      @$el.append @tabTitleContainerTemplate
      @$titleContainer = @$el.children('.tab-item-title-container').first()
      @$titleContainer.append(panel.titleView.render().$el) for panel in @items
      @

    render:=>
      if @tabPositionBottom
        @$el.append @contentContainer.render().$el
        @_renderTitle()
      else
        @_renderTitle()
        @$el.append @contentContainer.render().$el
      @changeItem(0) if @activeIndex is -1
      @

  exports = module.exports = TabContainer
  exports