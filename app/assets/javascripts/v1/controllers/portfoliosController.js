Luxin.portfoliosController = Ember.ArrayController.create({
	content: Luxin.store.findAll(Luxin.Portfolio),
	submitting: false,
	shownewform: false,
	
	newPortfolio: function(data) {
		var port;
		this.submitting = true;
		Luxin.log('creating portfolio ' + data.name);
		//port = Luxin.Portfolio.create(data)
	    var port = Luxin.store.createRecord(Luxin.Portfolio, { name: data.name, description: data.description });
	    Luxin.store.commit();
	    if (port && port.isLoaded) {
	    	this.pushObject(port);
	    	this.submitting = false;
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
	},
	remove: function(portfolio) {
		if ((portfolio) && (portfolio.remove()));
		{
			this.removeObject(portfolio);
			return true;
		}
		return false;
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
		// 
		Luxin.log('saving edited portfolio');
		try {
			var portfolio = this.get('content');
			if (portfolio.isNew()) {
				//portfolio.merge(this.get('editableContent'));
				//this.set('content', portfolio);
				var newPortfolio = this.get('editableContent');
				Luxin.portfoliosController.newPortfolio(newPortfolio);
			} else {
				portfolio.merge(this.get('editableContent'));
				this.set('content', portfolio);		
				//TODO update RESTful resource	
			}
			this.set('content', null);
		} catch (e) {
			Luxin.log('error: ' + e);
		}
	},
	remove: function() {
		var port = this.get('content');	
		if (Luxin.portfoliosController.remove(port)) {
			this.set('content', null);	
		}		
	}
	
});
