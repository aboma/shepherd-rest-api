Luxin.Router = Ember.Router.extend({
	enableLogging: true,
	location: 'hash',
	
	root: Ember.Route.extend({
	    index: Ember.Route.extend({
	      route: '/',
	      redirectsTo: 'portfolios'
	    }),
	    portfolios: Ember.Route.extend({
	    	route: '/portfolios',
	    	showPortfolio: Ember.Route.transitionTo('portfolio'),
	    	connectOutlets: function(router) {
	    		Luxin.log('setting up portfolios route');
	    		var ac = router.get("applicationController"); 
	    		ac.connectOutlet( { name: 'portfolios', outletName: 'master', 
	    							context: Luxin.store.findAll(Luxin.Portfolio) } );
	    	},

		    portfolio: Ember.Route.extend({
		    	route: '/:portfolio_id',
		    	modelType: 'Luxin.Portfolio',
		    	connectOutlets: function(router, portfolio) {
		    		Luxin.log('portfolio selected');
		    		var ac = router.get("applicationController"); 
		    		ac.connectOutlet( { name: 'portfolio', outletName: 'detail', 
		    							context: portfolio } );	    		
		    	} 
		    })
	    })
	})
});

// start app
Luxin.initialize();