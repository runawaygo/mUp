define (require, exports, module)->
	base = '../mUp/view/control'
	Container = require("../mUp/view/control/Container")
	CarouselContainer = require("../mUp/view/control/CarouselContainer")
	CarouselTabContainer = require("../mUp/view/control/CarouselTabContainer")
	CardContainer = require("../mUp/view/control/CardContainer")
	TabItem = require("../mUp/view/control/TabItem")

	TabContainer = require("../mUp/view/control/TabContainer")
	NavigationContainer = require("../mUp/view/control/NavigationContainer")
	Toolbar = require("../mUp/view/control/Toolbar")

	TitleBar = require("../mUp/view/control/TitleBar")
	List = require("../mUp/view/control/List")
	
	animate = require('./utility/animate')
	$(->
		# window.config = new Config

		testList = new List({
			id:'superwolf'
			template:require('./templates/list.tpl')
			scrollable:true
		})

		testList2 = new List({
			id:'superwolf1'
			template:require('./templates/list.tpl')
			scrollable:true
		})
		navigationTest = new NavigationContainer({
			layout:'vbox'
			items:[new Container({
				id:'superwolf'
				title:'superowlf!!!!'
				template:'superwolf wow'
			})]
		})
		quotesDetailCarousel = new CarouselContainer({id:'quotes-detail-carousel'})
			.addItem(new Container({
				id:'quotes-detail-avg-container'
				layout:'vbox'
				items:[
					new Toolbar({
						items:[
							{title:'5分钟'}
							{title:'10分钟'}
							{title:'15分钟'}
							{title:'20分钟'}
						]
					})
					new Container({
						title:'superowlf!!!!'
						template:'superwolf wow'
					})
				]
			}))
			.addItem(navigationTest)
			.addItem(testList2)
			.addItem(new Container({
				id:'quotes-detail-kline-container',
				template:'quotes-detail-kline-container'
			}))
			.addItem(new Container({
				id:'quotes-detail-handicap-container',
				template:'quotes-detail-handicap-container'
			}))
			.addItem(new Container({
				id:'quotes-detail-trade-container',
				template:'quotes-detail-trade-container'
			}))

		quotesCardContainer = new CardContainer({id:'quotes-container'})
			.addItem(quotesDetailCarousel)
			.addItem(new Container({
				id:'quotes-market-container'
				template:'quotes-market-container'
			}))
			.addItem(new Container({
				id:'quotes-list-container',
				template:'quotes-list-container'
			}))

		testCarouselTabContainer = new CarouselTabContainer(id:'carousel-tab-container')
			.addItem(new TabItem({
				id:'carousel-tab-1'
				template:'<h1>carousel-tab-1</h1>'
				# template:require('./templates/test.tpl'),
				model:new Backbone.Model({title:'panel1'})
			}))
			.addItem(new TabItem({
				id:'carousel-tab-2'
				template:'<h1>carousel-tab-2</h1>'
				# template:require('./templates/test.tpl'),
				model:new Backbone.Model({title:'panel1'})
			}))
			.addItem(new TabItem({
				id:'carousel-tab-3'
				template:'<h1>carousel-tab-3</h1>'
				# template:require('./templates/test.tpl'),
				model:new Backbone.Model({title:'panel1'})
			}))

		mainTabContainer = new TabContainer({id:'main-container'})
			.addItem(new TabItem({
				id:'panel2'
				# template:'<h1>panel2</h1>'
				# template:require('./templates/test.tpl'),
				contentView:testCarouselTabContainer
				model:new Backbone.Model({title:'panel2'})
			}))
			.addItem(new TabItem({
				id:'panel1'
				# template:'<h1>panel2</h1>', 
				# template:require('./templates/test.tpl'),
				contentView: quotesCardContainer
				model:new Backbone.Model({title:'panel1'})
			}))
			.addItem(new TabItem({
				id:'panel3'
				# template:'<h1>panel3</h1>', 
				template:require('./templates/listdata.tpl')
				model:new Backbone.Model({title:'panel3'})
			}))
			.addItem(new TabItem({
				id:'panel4'
				# template:'<h1>panel4</h1>', 
				contentView: testList
				model:new Backbone.Model({title:'panel4'})
			}))		
		$('body')
			.append(testCarouselTabContainer.render().$el.css('height', "100%"))
			.on('touchmove', (e)->e.preventDefault())

	)
	module.exports = {}
