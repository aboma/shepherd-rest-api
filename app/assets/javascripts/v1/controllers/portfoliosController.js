Mirrorball.portfoliosController = Ember.ArrayController.create({
	content: [],
	
	newPortfolio: function(data) {
		alert('saving new portfolio');
		Mirrorball.log(data);
		//event.preventDefault();
	    portfolio.saveResource()
	      .fail( function(e) {
	        //Mirrorball.displayError(e);
	      })
	      .done(function() {
	        this.pushObject(Mirrorball.Portfolio.Create(data));
	        self.get("parentView").hideNew();
	      });
	},	
	loadPortfolios: function() {
		//TODO
	}	
});