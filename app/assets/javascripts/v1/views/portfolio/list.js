Luxin.PortfoliosListView = Ember.View.extend({
  	templateName: 'v1/templates/portfolio/list',
  	//contentBinding: 'Luxin.portfoliosController',
  	controllerBinding: 'Luxin.portfoliosController',
    isDisabled: false,
    isVisible: true,
    
  	init: function() {
    	this._super();
  	}
});

Luxin.PortfolioView = Ember.View.extend({
	currentSelectedView: null,
	isSelected: false,
	
	clear: function() {
		var selectedContent = Luxin.selectedPortfolioController.get('content');
		if (this.get('content') !== selectedContent) {
			this.set('isSelected', false);
		}
	}.observes('Luxin.selectedPortfolioController.content'),
	click: function() {
		var csv = this.get('currentSelectedView');
		if (csv)
			csv.set('isSelected', false);
		var port = this.get('content');
		this.set('isSelected', true);
		this.set('currentSelectedView', this);
		Luxin.log('portfolio ' + port.name + ' selected');
		Luxin.selectedPortfolioController.set('content', port);
	}
})