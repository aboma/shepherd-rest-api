Mirrorball.portfoliosController = Ember.ArrayController.create({
	content: Mirrorball.store.findAll(Mirrorball.Portfolio),
	submitting: false,
	shownewform: false,
	
	newPortfolio: function(data) {
		var port;
		this.submitting = true;
		Mirrorball.log('creating portfolio ' + data.name);
		//port = Mirrorball.Portfolio.create(data)
	    var port = Mirrorball.store.createRecord(Mirrorball.Portfolio, { name: data.name, description: data.description });
	    Mirrorball.store.commit();
	    if (port && port.isLoaded) {
	    	this.pushObject(port);
	    	this.submitting = false;
	    	return true;
	    } else {
	    	Mirrorball.displayError('portfolio not saved');
	    }
	},	
	addPortfolio: function(portfolio) {
		this.pushObject(portfolio);
	},
	loadAll: function(data) {
		Mirrorball.log('data >> loading portfolios');
		this.set('content', Mirrorball.store.loadAll(Mirrorball.Portfolio, data));
	},
	findAll: function() {
		Mirrorball.log('data >> finding portfolios')
		this.set('content', Mirrorball.store.findAll(Mirrorball.Portfolio));
	},
	shownew: function() {
    	var port = Mirrorball.Portfolio.create({});
    	Mirrorball.selectedPortfolioController.set('content', port);
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

Mirrorball.selectedPortfolioController = Ember.Object.create({
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
			Mirrorball.log('>>> content changed');
			var port = this.get('content').copy();
			this.set('editableContent', port);
		} else {
			this.set('editableContent', null);
		}
	}.observes('content'),	
	save: function() {
		// 
		Mirrorball.log('saving edited portfolio');
		try {
			var portfolio = this.get('content');
			if (portfolio.isNew()) {
				//portfolio.merge(this.get('editableContent'));
				//this.set('content', portfolio);
				var newPortfolio = this.get('editableContent');
				Mirrorball.portfoliosController.newPortfolio(newPortfolio);
			} else {
				portfolio.merge(this.get('editableContent'));
				this.set('content', portfolio);		
				//TODO update RESTful resource	
			}
			this.set('content', null);
		} catch (e) {
			Mirrorball.log('error: ' + e);
		}
	},
	remove: function() {
		var port = this.get('content');	
		if (Mirrorball.portfoliosController.remove(port)) {
			this.set('content', null);	
		}		
	}
	
});
