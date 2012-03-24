Luxin.portfoliosController = Ember.ArrayController.create({
	content: Luxin.store.findAll(Luxin.Portfolio),
	submitting: false,
	shownewform: false,
	
	newPortfolio: function(data) {
		Luxin.log('creating portfolio ' + data.name);
		//port = Luxin.Portfolio.create(data)
	    var port = Luxin.store.createRecord(Luxin.Portfolio, { name: data.get('name'), 
	    													   description: data.get('description') });
	    Luxin.store.commit();
	    if (port && port.get('isLoaded')) {
	    	this.pushObject(port);
	    	return true;
	    } else {
	    	Luxin.displayError('portfolio not saved');
	    }
	},	
	addPortfolio: function(portfolio) {
		this.pushObject(portfolio);
	},
	loadAll: function(data) {
		Luxin.log('data >> loading portfolios');
		this.set('content', Luxin.store.loadAll(Luxin.Portfolio, data));
	},
	findAll: function() {
		Luxin.log('data >> finding portfolios')
		this.set('content', Luxin.store.findAll(Luxin.Portfolio));
	},
	shownew: function() {
    	var port = Luxin.Portfolio.create({});
    	Luxin.selectedPortfolioController.set('content', port);
	}
});

Luxin.selectedPortfolioController = Ember.Object.create({
	content: null,
	hasErrors: false,
	editableContent: null,
	
	isEditing: function() {
		var port = this.get('content');
		if (port && !port.get('isLoaded')) {
				return false;
		}
		return true;
	}.observes('content').property('isNew'),
	setEditContent: function() {
		// copy content so that it can be edited without immediately updating
		// selected content
		if (this.get('content')) {
			Luxin.log('>>> content changed');
			var port = this.get('content').copy();
			this.set('editableContent', port);
		} else {
			this.set('editableContent', null);
		}
	}.observes('content'),	
	save: function() {
		Luxin.log('saving edited portfolio');
		try {
			var portfolio = this.get('content');
			if (!portfolio.get('isLoaded')) {
				//portfolio.merge(this.get('editableContent'));
				//this.set('content', portfolio);
				var newPortfolio = this.get('editableContent');
				Luxin.portfoliosController.newPortfolio(newPortfolio);
			} else {
				portfolio.merge(this.get('editableContent'));
				portfolio.store.commit();
			}
			this.set('content', null);
		} catch (e) {
			Luxin.log('error: ' + e);
		}
	},
	validate: function() {
		//TODO
	},
	destroy: function() {
		var port = this.get('content');	
		//TODO fix
		if (Luxin.portfoliosController.remove(port)) {
			this.set('content', null);	
		}		
	}
	
});
