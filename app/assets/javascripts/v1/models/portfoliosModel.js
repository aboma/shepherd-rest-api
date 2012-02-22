Mirrorball.portfolio = Ember.Object.extend({
	name: null,
	id: null,
	
	changed: function() {
		// update on server
		//TODO	
	}.observes('name')	
});