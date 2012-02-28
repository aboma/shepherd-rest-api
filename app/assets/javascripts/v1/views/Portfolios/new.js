Mirrorball.PortfolioNewView = Ember.View.extend({
  templateName: 'v1/templates/Portfolios/new',
  controller: null,
  tagName: 'form',
  isDisabled: false,
  
  didInsertElement: function() {
  	//alert('calling didInsertElement');
  	this._super();
    this.$('input:first').focus();
    //TODO : make this a binding
  	jQuery('#MbForms').addClass('animated pulse');  	
  },
  create: function() {
  	this.set('isDisabled', true);
  	Mirrorball.log('newport.create');
  	try {
  		var pname = this.getPath('portfolioTextField.value');
  		var controller = this.get('controller');
  		Mirrorball.log('attempting to create portfolio ' + pname);
  		var port = controller.newPortfolio({ name: pname});
  		if (port) {
  			this.destroy();
  		}
  	} catch (e) {
		Mirrorball.log('error: ' + e);
		this.set('isDisabled', false);
	}
  },
  cancel: function() {
	alert('cancelling form');
	
  },
  clear: function( ){
  	 this.setPath('portfolioTextField.value', null);
  }
});