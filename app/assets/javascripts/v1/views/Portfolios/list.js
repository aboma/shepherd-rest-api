Mirrorball.PortfoliosListView = Ember.View.extend({
  	templateName: 'v1/templates/Portfolios/list',
  	//contentBinding: 'Mirrorball.portfoliosController',
  	controllerBinding: 'Mirrorball.portfoliosController',
    isDisabled: false,
    isVisible: true,
    
  	init: function() {
    	this._super();
  	}
});

Mirrorball.PortfolioView = Ember.View.extend({
	click: function() {
		var port = this.get('content');
		Mirrorball.log('portfolio ' + port.name + ' selected');
		Mirrorball.selectedPortfolioController.set('content', port);
	}
})