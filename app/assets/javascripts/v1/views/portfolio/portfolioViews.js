Luxin.PortfoliosView = Ember.View.extend({
  	templateName: 'v1/templates/portfolio/list',
  	filteredPortfolios: null,
    isDisabled: false,
    isVisible: true,
    
  	init: function() {
  		Luxin.log('initializing portfolios list view');
    	this._super();
  	},
  	updateFilter: function() {
  		var value = this.getPath('portfolioFilter.value');
  		this.get('controller').set('portfolioNameFilter', value);
  	}.observes('portfolioFilter.value')
});

Luxin.PortfolioView = Ember.View.extend({
	templateName: 'v1/templates/portfolio/show'
});

Luxin.EditPortfolioView = Ember.View.extend({
	templateName: 'v1/templates/portfolio/edit',
	
	init: function() {
		this._super();
		Luxin.log("showing new portfolio view");
	},
	didInsertElement: function() {
	  	//alert('calling didInsertElement');
		this._super();
	   	this.$('input:first').focus();  	
	}
});