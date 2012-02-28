Mirrorball.Portfolio = Ember.Object.extend({
	name: null,
	id: null,
	
	saveResource: function() {
		Mirrorball.log('saving portfolio resource');
	},	
	
	changed: function() {
		// update on server
		//TODO	
		Mirrorball.log('portfolio.changed');
	}.observes('name')
	
});