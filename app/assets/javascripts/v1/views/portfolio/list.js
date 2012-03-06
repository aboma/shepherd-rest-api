Mirrorball.PortfoliosListView = Ember.View.extend({
  	templateName: 'v1/templates/portfolio/list',
  	//contentBinding: 'Mirrorball.portfoliosController',
  	controllerBinding: 'Mirrorball.portfoliosController',
    isDisabled: false,
    isVisible: true,
    
  	init: function() {
    	this._super();
  	}
});

Mirrorball.PortfolioView = Ember.View.extend({
	currentSelectedView: null,
	isSelected: false,
	
	clear: function() {
		var selectedContent = Mirrorball.selectedPortfolioController.get('content');
		if (this.get('content') !== selectedContent) {
			this.set('isSelected', false);
		}
	}.observes('Mirrorball.selectedPortfolioController.content'),
	click: function() {
		var csv = this.get('currentSelectedView');
		if (csv)
			csv.set('isSelected', false);
		var port = this.get('content');
		this.set('isSelected', true);
		this.set('currentSelectedView', this);
		Mirrorball.log('portfolio ' + port.name + ' selected');
		Mirrorball.selectedPortfolioController.set('content', port);
	}
})