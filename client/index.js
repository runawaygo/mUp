seajs
.config({
  base: './',
  preload: ['vendors/seajs/dist/plugin-text'],
  debug: true
  
})
.use('app/app')