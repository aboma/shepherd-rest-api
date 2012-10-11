Luxin.User = DS.Model.extend({
	email: DS.attr('string'),
	last_name: DS.attr('string'),
	first_name: DS.attr('string'),
	hasAdminRights: DS.attr('string'),
		
})
