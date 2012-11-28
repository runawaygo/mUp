seajs.config({
	base: './',
	debug:true
});

define(function(require) {
	console.log('seajs start');
	require('app/app.js');
});
