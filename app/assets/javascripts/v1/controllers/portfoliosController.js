Mirrorball.portfoliosController = Ember.ArrayController.create({
	content: [{name: "Boma's specials"}],
	submitting: false,
	
	newPortfolio: function(data) {
		var port;
		this.submitting = true;
		Mirrorball.log('creating portfolio ' + data);
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
	loadPortfolios: function() {
		//TODO
	}
});