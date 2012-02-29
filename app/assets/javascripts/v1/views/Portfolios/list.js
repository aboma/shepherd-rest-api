Mirrorball.PortfoliosListView = Ember.View.extend({
  	templateName: 'v1/templates/Portfolios/list',
  	contentBinding: 'Mirrorball.portfoliosController',
  	controllerBinding: 'Mirrorball.portfoliosController',
    isDisabled: false,
    
  	init: function() {
    	this._super();
  	},
  	shownew: function() {
  		alert('showing new form');
  		//Mirrorball.PortNewForm = Mirrorball.PortfolioNewView.create({
  		//	  controllerBinding: "Mirrorball.portfoliosController"  			
  		//});
  		//Mirrorball.PortNewForm.appendTo("#MbForms");
  	}
});