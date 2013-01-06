exports = module.exports = (app)->
	app.use('/data', (req,res)->
		res.end(JSON.stringify([{name:'superowlf'},{name:'bluewing'}]))
	)