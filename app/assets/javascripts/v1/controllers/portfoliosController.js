Mirrorball.portfoliosController = Ember.ArrayController.create({
	content: [],
	submitting: false,
	shownewform: false,
	
	newPortfolio: function(data) {
		var port;
		this.submitting = true;
		Mirrorball.log('creating portfolio ' + data.name);
		//event.preventDefault();
		port = Mirrorball.Portfolio.create(data)
	    port.saveResource();
	    //  .fail( function(e) {
	   //     //Mirrorball.displayError(e);
	   //   })
	   //   .done(function() {
	   //     this.pushObject(port);
	  //    });
	    this.pushObject(port);
	    this.submitting = false;
	    return true;
	},	
	addPortfolio: function(portfolio) {
		this.pushObject(portfolio);
	},
	loadPortfolios: function() {
		//TODO
	},
	shownew: function() {
    	//TODO : make this a binding
    	//this.set('shownewform', true);
    	var port = Mirrorball.Portfolio.create({});
    	Mirrorball.selectedPortfolioController.set('content', port);
	},
	create: function() {
		alert('boom');
	},
	remove: function(portfolio) {
		if (portfolio.remove());
		{
			this.removeObject(portfolio);
			return true;
		}
		return false;
	},
	cancel: function() {
		this.set('shownewform', false);
	}
});

Mirrorball.selectedPortfolioController = Ember.Object.create({
	content: null,
	hasErrors: false,
	editableContent: null,
	
	isNew: function() {
		var port = this.get('content');
		if (port) {
			if (port.get('uri'))
				return false;
		}
		return true;
	}.observes('content'),
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
		Mirrorball.log('saving edited portfolio');
		try {
			var portfolio = this.get('content');
			portfolio.merge(this.get('editableContent'));
			this.set('content', portfolio);
			this.get('content').saveResource();
			if (this.isNew) {
				Mirrorball.portfoliosController.addPortfolio(portfolio);
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
