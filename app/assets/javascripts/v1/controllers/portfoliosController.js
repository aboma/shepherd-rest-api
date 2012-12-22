Luxin.PortfoliosController = Ember.ArrayController.extend({
	sortProperties: ['name'],
	sortAscending: true, 
	selectedPortfolio: null,
	
	clearSelected : function() {
		console.log('clearing selected portfolio');
		this.set('selectedPortfolio', null);
	},
	
/*	portfolioNameFilter: '',
	
  	filteredPortfolios: function() {
  		var content = this.get('arrangedContent'),
  			x = content,
  			value = this.get('portfolioNameFilter');		
  		if (value && value.length > 3)
  			x =  x.filter(function(item, index, enumerable) {
  				if (item.get('name').toLowerCase().startsWith(value.toLowerCase()))
  					return true;
  				return false;
  			});
  		return x;
  	}.property('arrangedContent.@each.name', 'portfolioNameFilter').cacheable(),
 */
  	contentLoaded: function() {
  		console.log('controller content is loaded');
  		// set default value to null so prompt is shown, not first item
  		//this.set('selectedPortfolio', null);
  	}.observes('content.isLoaded')
});

Luxin.PortfolioController = Ember.ObjectController.extend({});

Luxin.EditPortfolioController = Ember.ObjectController.extend({});