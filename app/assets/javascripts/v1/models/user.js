Mirrorball.User = Ember.Object.extend({
	username: null,
	hasAdminRights: false,
	
	init: function() {
		this._super();
		if (!this.get('username')) {
			alert('user not set');
		}
	}	
})
