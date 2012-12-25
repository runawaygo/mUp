define (require, exports, module)->
	Container = require('./Container')
	class Page extends Container
		className:'page container'
	exports = module.exports = Page
	exports