Mirrorball.PortfolioNewView = Ember.View.extend({
  tagName: 'form',
  templateName: 'v1/templates/Portfolios/new',
  controllerBinding: 'Mirrorball.portfoliosController',
  
  didInsertElement: function() {
  	//alert('calling didInsertElement');
  	this._super();
    this.$('input:first').focus();
  	jQuery('#MbForms').addClass('animated pulse');  	
  },
  submit: function() {
  	//alert('submitting form');
  	this.get('controller').newPortfolio(this.getPath('name.value'));
	this.clear();
  },
  cancel: function() {
	alert('cancelling form');
	
  },
  clear: function( ){
  	 this.setPath('portfolioName.value', null);
  }
});