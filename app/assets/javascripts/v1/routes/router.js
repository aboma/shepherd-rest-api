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
	    	showPortfolio: Ember.Route.transitionTo('show_portfolio'),
	    	create: Ember.Route.transitionTo('new_portfolio'),
	    	connectOutlets: function(router) {
	    		Luxin.log('setting up portfolios route');
	    		var ac = router.get("applicationController"); 
	    		ac.connectOutlet( { name: 'portfolios', outletName: 'master', 
	    							context: Luxin.store.findAll(Luxin.Portfolio) } );
	    	},

		    show_portfolio: Ember.Route.extend({
		    	route: '/:portfolio_id',
		    	modelType: 'Luxin.Portfolio',
		    	connectOutlets: function(router, portfolio) {
		    		Luxin.log('portfolio selected');
		    		var ac = router.get("applicationController"); 
		    		ac.connectOutlet( { name: 'portfolio', outletName: 'detail', 
		    							context: portfolio } );	    		
		    	},
		    	
			    edit_portfolio: Ember.Route.extend({
			    	route: '/edit',
			    	connectOutlets: function(router, portfolio) {
			    		Luxin.log('showing edit portfolio form');
			    		var ac = router.get("applicationController");	
			    		ac.connectOutlet( { name: 'newPortfolio', outletName: 'detail', context: portfolio } );
			    	}
			    })
		    }),
		    
		    new_portfolio: Ember.Route.extend({
		    	route: '/new',		    	
		    	save: function(router, event) {
		    		router.get('newPortfolioController').save();
		    		router.transitionTo('show_portfolio', event.context);
		    	},
		    	cancel: function(router, event) {
		    		router.get('newPortfolioController').cancel();
		    	},
		    	connectOutlets: function(router) {
		    		Luxin.log('showing new portfolio form');
		    		var ac = router.get("applicationController"); 
		    		ac.connectOutlet( { name: 'newPortfolio', outletName: 'detail' } )
		    	}
		    })
	    })
	})
});

// start app
Luxin.initialize();