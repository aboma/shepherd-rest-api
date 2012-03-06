Mirrorball.Portfolio = Ember.Object.extend(Ember.Copyable, {
	name: null,
	description: null,
	id: null,
	uri: null,
	createdBy: null,
	createdOn: null,
	
	saveResource: function() {
		Mirrorball.log('saving portfolio resource ' + this.name);
	},
	remove: function() {
		return true;
	},
	copy: function(deep) {
		return Mirrorball.Portfolio.create({
			name: this.get('name'),
			description: this.get('description')
		})
	},
	merge: function(source) {
		this.set('name', source.get('name'));
		this.set('description', source.get('description'));
	}
	
});