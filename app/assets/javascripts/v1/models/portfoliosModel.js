Luxin.Portfolio = DS.Model.extend({
	name: DS.attr('string'),
	description: DS.attr('string'),
	url: DS.attr('string'),
	createdAt: DS.attr('string'),
	updatedAt: DS.attr('string'),
	deletedAt: DS.attr('string')
});

Luxin.Portfolio.reopenClass({
	collectionUrl: 'portfolios',
	resourceUrl: 'portfolios',
	url: 'portfolio',
	resourceName: 'portfolio'
})
