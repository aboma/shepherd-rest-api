Mirrorball.PortfoliosListView = Ember.View.extend({
  	templateName: 'v1/templates/Portfolios/list',
  	contentBinding: 'Mirrorball.portfoliosController',
  	controllerBinding: 'Mirrorball.portfoliosController',
    
  	init: function() {
    	this._super();
  	},
  	show: function() {
  		//alert('showing form');
  		Mirrorball.PortNewForm = Mirrorball.PortfolioNewView.create({
  			  controllerBinding: "Mirrorball.portfoliosController"  			
  		});
  		Mirrorball.PortNewForm.appendTo("#MbForms");
  	}
});