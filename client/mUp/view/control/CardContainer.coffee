define (require, exports, module)->
  animate = require('../../utl/animate')
  Container = require('./Container')
  
  class CardContainer extends Container
    className:"container card-container"
    activeIndex:-1
    isInfinite:false
    initialize:(@options)->
      super(@options)
      @ 

    _setActiveItem:(toActiveItem)->
      return @ if @items[@activeIndex] is toActiveItem
      toActiveItem = @items[toActiveItem] if typeof toActiveItem is 'number'

      for item,i in @items
        if item is toActiveItem
          item.active()
          @activeIndex = i
        else
          item.deactive()
      @
    _changeItem:(toItem, options)->
      if options?.animate? and not @busy
        @busy = true
        fromItem = @items[@activeIndex]
        fromItem.$el.addClass('fake-active')
        animate(fromItem, toItem, options.animate, =>
          @busy = false
          fromItem.$el.removeClass('fake-active')
        )

      @_setActiveItem(toItem)

    _changeItemByName:(name, options)->
      #TODO: change item by page name
      @

    _changeItemByIndex:(to, options)->
      return @ if  to<0 or to>=@items.length or to is @activeIndex or @busy
      @_changeItem(@items[to], options)

    _getNextItemIndex:=> 
      nextItemIndex = @activeIndex+1
      count = @items.length
      if @isInfinite
        nextItemIndex%count
      else
        if nextItemIndex is count then null else nextItemIndex

    _getPrevItemIndex:=> 
      nextItemIndex = @activeIndex-1
      count = @items.length
      if @isInfinite
        (nextItemIndex+count)%count
      else
        if nextItemIndex is -1 then null else nextItemIndex

    addItem:(item)->
      @items.push(item)
      item.on('active',@changeItem)
      @
    changeItem:(name, options)=>
      switch typeof name
        when 'string' then @_changeItemByName(name, options)
        when 'number' then @_changeItemByIndex(name, options)
        when 'object' then @_changeItem(name, options)
        else throw "Invalid args type for page index or page name"
      @

    changeNextItem:=>
      return null if @items.length is 1
      @changeItem(@_getNextItemIndex())
      @

    _renderItem:(panel, i)->
      @$el.append(panel.render().el)
      @

    render:=>
      return @ if @items.length is 0

      @_renderItem panel,i for panel, i in @items
      @changeItem(0) if @activeIndex is -1
      @

  exports = module.exports = CardContainer
  exports
