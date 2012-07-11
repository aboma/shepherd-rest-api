Luxin.PortfoliosController = Ember.ArrayController.extend({
	sortProperties: ['name'],
	sortAscending: true,
	portfolioNameFilter: '',
	
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
  	}.property('arrangedContent.@each.name', 'portfolioNameFilter').cacheable()
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

Luxin.NewPortfolioController = Ember.ObjectController.extend({
	transaction: null,
	
	init: function() {
		this._super();
		this.setup();
	}, 
	// create new transaction and blank portfolio record for input from user
	setup: function () {
		this.transaction = Luxin.store.transaction();	
		var newPortfolio = this.transaction.createRecord(Luxin.Portfolio, {} );
		this.set('content', newPortfolio);		
	},
	save: function() {
		Luxin.log('saving new portfolio');
		this.transaction.commit();
		this.setup();
	},
	cancel: function() {
		this.transaction.rollback();
		this.transaction.destroy();
		this.setup();
	},
	destroy: function() {
		this._super();
		if (this.transaction)
			this.transaction.destroy();
	}
});