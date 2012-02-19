Mirrorball.PortfolioNewView = Ember.View.extend({
  templateName: 'v1/templates/Portfolios/new',
  portfoliosBinding: 'Mirrorball.portfoliosController',
  didInsertElement: function() {
  	//alert('calling didInsertElement');
  	jQuery('#MbForms').addClass('animated pulse');  	
  },
  submit: function() {
  	alert('submitting form');
  },
  cancel: function() {
	alert('cancelling form');

  }
});