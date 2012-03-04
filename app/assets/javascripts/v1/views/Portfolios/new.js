Mirrorball.PortfolioNewView = Ember.View.extend({
  templateName: 'v1/templates/Portfolios/new',
  tagName: 'form',
  isDisabled: false,
  isVisibleBinding: 'controller.shownewform',
  
  didInsertElement: function() {
  	//alert('calling didInsertElement');
  	this._super();
    this.$('input:first').focus();  	
  },
  create: function() {
  	if (!this.validated())
  		return;
  	this.set('isDisabled', true);
  	Mirrorball.log('newport.create');
  	try {
	  	var pname = this.getPath('pNameTextField.value');
	  	var desc = this.getPath('pDescriptionTextArea.value');
	  	var controller = this.get('controller');
	  	Mirrorball.log('attempting to create portfolio ' + pname);
	  	var port = controller.newPortfolio( { name: pname, description: desc } );
  		if (port) {
  			this.clear();
  			controller.set('shownewform', false);
  		}
  	} catch (e) {
		Mirrorball.log('error: ' + e);
		this.set('isDisabled', false);
	}
  },
  validated: function() {
  	var p_name = this.getPath('pNameTextField.value');
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
	this.clear();
	this.get('controller').set('shownewform', false);
  },
  clear: function(){
  	this.getPath('portfolioFormMessage').set('isVisible', false);
  	this.setPath('pNameTextField.value', null);
  	this.setPath('pDescriptionTextArea.value', null);
  }
});