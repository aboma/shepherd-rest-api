Mirrorball.PortfolioNewView = Ember.View.extend({
  templateName: 'v1/templates/Portfolios/new',
  portfoliosBinding: 'Mirrorball.portfoliosController',
  
  submit: function() {
  	alert('submitting form');
  }
});