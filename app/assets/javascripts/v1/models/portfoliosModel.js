Luxin.Portfolio = DS.Model.extend(Ember.Copyable, {
	name: DS.attr('string'),
	description: DS.attr('string'),
	url: DS.attr('string'),
	createdBy: DS.attr('date'),
	createdAt: DS.attr('date'),
	updatedAt: DS.attr('date'),
	deletedAt: DS.attr('date'),
	
	isNew: function() {
		return !this.url;
	},
	copy: function(deep) {
		return Luxin.Portfolio.create({
			name: this.get('name'),
			description: this.get('description'),
			url: this.get('url'),
			createdAt: this.get('createdAt'),
			updatedAt: this.get('updatedAt')
		})
	},
	merge: function(source) {
		this.set('name', source.get('name'));
		this.set('description', source.get('description'));
		this.set('url', source.get('url'));
	}
});

Luxin.Portfolio.reopenClass({
	collectionUrl: 'portfolios',
	resourceUrl: 'portfolios',
	url: 'portfolio',
	resourceName: 'portfolio'
})
