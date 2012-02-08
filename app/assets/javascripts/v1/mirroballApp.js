window.Mirrorball = Ember.Application.Create();

/*
 * Models
 */

Mirroball.Portfolio = Ember.Object.Extend({
	name: '',
	id: ''
	
});

/*
 * Controllers
 */

Mirroball.PortfoliosController = Ember.ArrayProxy.Create({
	content: [],
	
	pushObject: function (item, ignoreStorage) {
		if (!ignoreStorage) {
			//TODO			
		}
		return this._super(item);
		
	}
	
});

Mirrorball.Portfolios.Store = (function () {
	
	
});
