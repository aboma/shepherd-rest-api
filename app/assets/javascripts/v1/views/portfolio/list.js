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
	
	isDeleted: function() {
		return this.get('content').get('isDeleted');
	},
	deselect: function() {
		var selectedContent = Luxin.selectedPortfolioController.get('content');
		if (this.get('content') !== selectedContent) {
			this.set('isSelected', false);
		}
	}.observes('Luxin.selectedPortfolioController.content'),
	click: function() {
		this.set('isSelected', true);
		var port = this.get('content');
		Luxin.log('portfolio ' + port.get('name') + ' selected');
		Luxin.selectedPortfolioController.set('content', port);
	}
})