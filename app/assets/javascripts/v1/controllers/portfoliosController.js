Mirrorball.portfoliosController = Ember.ArrayController.create({
	content: [],
	
	newPortfolio: function(title) {
		event.preventDefault();
	    portfolio.saveResource()
	      .fail( function(e) {
	        //Mirrorball.displayError(e);
	      })
	      .done(function() {
	        this.pushObject(Mirrorball.Portfolio.Create({ name: title }));
	        self.get("parentView").hideNew();
	      });
	},	
	loadPortfolios: function() {
		//TODO
	}	
});