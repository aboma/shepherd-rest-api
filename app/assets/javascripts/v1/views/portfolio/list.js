Luxin.PortfoliosView = Ember.View.extend({
  	templateName: 'v1/templates/portfolio/list',
  	portfolios: null,
    isDisabled: false,
    isVisible: true,
    
  	init: function() {
  		Luxin.log('initializing portfolios list view');
    	this._super();
  	}
});