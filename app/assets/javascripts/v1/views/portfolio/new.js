Luxin.NewPortfolioView = Ember.View.extend({
	templateName: 'v1/templates/portfolio/edit',
	
	
	init: function() {
		this._super();
		Luxin.log("showing new portfolio view");
	},
	didInsertElement: function() {
	  	//alert('calling didInsertElement');
		this._super();
	   	this.$('input:first').focus();  	
	}
})