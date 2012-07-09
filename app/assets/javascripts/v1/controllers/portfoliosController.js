Luxin.PortfoliosController = Ember.ArrayController.extend({
	//content: Luxin.store.findAll(Luxin.Portfolio),
	submitting: false,
	shownewform: false,
	portfolioNameFilter: '',
	
  	filteredPortfolios: function() {
  		var content = this.get('content'),
  			x = content,
  			value = this.get('portfolioNameFilter');		
  		if (value && value.length > 3)
  			x =  this.get('content').filter(function(item, index, enumerable) {
  				if (item.get('name').startsWith(value))
  					return true;
  				return false;
  			});
  		return x;
  	}.property('content.@each.name', 'portfolioNameFilter').cacheable()
});

Luxin.PortfolioController = Ember.ObjectController.extend({
	content: null,
	hasErrors: false,

	isEditing: function() {
		var port = this.get('content');
		if (port && port.get('isNew')) {
				return false;
		}
		return true;
	}.observes('content').property('isNew'),
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