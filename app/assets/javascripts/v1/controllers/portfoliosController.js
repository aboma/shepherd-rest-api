Luxin.PortfoliosController = Ember.ArrayController.extend({
	//content: Luxin.store.findAll(Luxin.Portfolio),
	submitting: false,
	shownewform: false,
	
	newPortfolio: function(data) {
		Luxin.log('creating portfolio ' + data.get('name'));
		//port = Luxin.Portfolio.create(data)
		newdata = new Object();
		newdata.name = data.get('name');
		if (data.get('description') != null)
			newdata.description = data.get('description');
		var transaction = Luxin.store.transaction();		
	    var port = transaction.createRecord(Luxin.Portfolio, newdata);
	    transaction.commit();
	    if (port && port.get('isLoaded')) {
	    	this.pushObject(port);
	    	return true;
	    } else {
	    	alert('error');
	    	Luxin.displayError('portfolio not saved');
	    }
	}
});

Luxin.PortfolioController = Ember.ObjectController.extend({
	content: null,
	hasErrors: false,

	isEditing: function() {
		var port = this.get('content');
		if (port && !port.get('isLoaded')) {
				return false;
		}
		return true;
	}.observes('content').property('isNew'),
/*	setEditContent: function() {
		// copy content so that it can be edited without immediately updating
		// selected content
		if (this.get('content')) {
			Luxin.log('>>> content changed');
			var port = this.get('content').copy();
			this.set('editableContent', port);
		} else {
			this.set('editableContent', null);
		}
	}.observes('content'),	*/
	save: function() {
		Luxin.log('saving edited portfolio');
		try {
			var portfolio = this.get('content');
			if (!portfolio.get('isLoaded')) {
				//portfolio.merge(this.get('editableContent'));
				//this.set('content', portfolio);
				var newPortfolio = this.get('editableContent');
				Luxin.portfoliosAdminController.newPortfolio(newPortfolio);
			} else {
				portfolio.merge(this.get('editableContent'));
				portfolio.store.commit();
			}
			this.set('content', null);
		} catch (e) {
			Luxin.log('error: ' + e);
		}
	},
	remove: function() {
		var port = this.get('content');	
		port.deleteRecord();
		Luxin.store.commit();
		if (port.get('isDeleted')) {
			this.set('content', null);	
		}		
	}
	
});