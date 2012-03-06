Mirrorball.PortfolioEditView = Ember.View.extend({
	templateName: 'v1/templates/portfolio/edit',
  	controllerBinding: 'Mirrorball.selectedPortfolioController',
    isDisabled: false,
	editableContentBinding: 'Mirrorball.selectedPortfolioController.editableContent',
	
	didInsertElement: function() {
	  	//alert('calling didInsertElement');
		this._super();
	   	this.$('input:first').focus();  	
	},
	save: function() {
		Mirrorball.log('editport.save');
	 	if (!this.validated())
	  		return;
	  	this.set('isDisabled', true);
	  	try {
	  		this.get('controller').save();
	 	} catch (e) {
			Mirrorball.log('error: ' + e);
		}
		this.set('isDisabled', false);
	},
	remove: function() {
		Mirrorball.log('deleting portfolio');
		this.get('controller').remove();
	},
	validated: function() {
	  	var p_name = this.getPath('editableContent.name');
	  	if (!p_name.length) {
	  		this.showmessage( { message: "Please enter all required fields.", messageType: 'error' } );
	  		return false;
	  	}
	  	return true;
	},
	showmessage: function(args) {
	  	var msg = this.getPath('portfolioFormMessage');
	  	msg.set(args);
	  	msg.set('isVisible', true);
	},
	cancel: function() {
		this.get('controller').set('content', null);
	},
	clear: function(){
	  	this.getPath('portfolioFormMessage').set('isVisible', false);
	}
})
