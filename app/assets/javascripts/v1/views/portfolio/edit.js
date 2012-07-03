Luxin.PortfolioView = Ember.View.extend({
	templateName: 'v1/templates/portfolio/show',
    isDisabled: false,
	
	didInsertElement: function() {
	  	//alert('calling didInsertElement');
		this._super();
	   	this.$('input:first').focus();  	
	}
})
