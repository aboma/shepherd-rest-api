Luxin.PortfoliosController = Ember.ArrayController.extend({
	sortProperties: ['name'],
	sortAscending: true, 
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
  	replaceContent: function() {
  		Luxin.log('controller content is loaded');
  	}.observes('content.isLoaded')
});

Luxin.PortfolioController = Ember.ObjectController.extend({
	content: null,
	hasErrors: false,

	remove: function() {
		var port = this.get('content');	
		port.deleteRecord();
		Luxin.store.commit();
		if (port.get('isDeleted')) {
			this.set('content', null);	
		}		
	}
	
});

Luxin.NewPortfolioController = Ember.ObjectController.extend({});