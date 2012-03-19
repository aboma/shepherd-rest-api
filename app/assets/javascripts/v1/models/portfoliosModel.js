Mirrorball.Portfolio = DS.Model.extend(Ember.Copyable, {
	name: DS.attr('string'),
	description: DS.attr('string'),
	uri: DS.attr('string'),
	createdBy: DS.attr('date'),
	createdOn: DS.attr('date'),
	
	isNew: function() {
		return !this.id;
	},
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
		var nnnname =  source.get('name');
		this.set('name', nnnname);
		this.set('description', source.get('description'));
	}
	
});

Mirrorball.Portfolio.reopenClass({
	collectionUrl: 'portfolios',
	resourceUrl: 'portfolios',
	url: 'portfolio',
	resourceName: 'portfolio'
})
