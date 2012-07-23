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
	    	createPortfolio: Ember.Route.transitionTo('new_portfolio'),
	    	connectOutlets: function(router) {
	    		Luxin.log('setting up portfolios route');
	    		var ac = router.get("applicationController"); 
	    		ac.connectOutlet( { name: 'portfolios', outletName: 'master', 
	    							context: Luxin.store.findQuery(Luxin.Portfolio, '') } );
	    	},

		    show_portfolio: Ember.Route.extend({
		    	route: '/:portfolio_id',
		    	//modelType: 'Luxin.Portfolio',
		    	edit: function(router, event) {
		    		router.transitionTo('edit_portfolio', event.context);
		    	},
		    	connectOutlets: function(router, portfolio) {
		    		Luxin.log('portfolio selected');
		    		var psc = router.get('portfoliosController');
		    		psc.set('selectedPortfolio', portfolio);
		    		var ac = router.get("applicationController"); 
		    		ac.connectOutlet( { name: 'portfolio', outletName: 'detail', 
		    							context: portfolio } );	    		
		    	}
		    }),
			    
	    	edit_portfolio: Ember.Route.extend({
			   	route: '/:portfolio_id/edit',
			   	transaction: null,
			   	cancel: function(router, event) {
		   			this.transaction.rollback();
		   			this.transaction.destroy();
			   		router.transitionTo('root.portfolios');
			   	},
			   	save: function(router, event) {
			   		portfolio = event.context;
			   		if (portfolio.get('isDirty')){
			   			this.transaction.commit();
			   		} else {
			   			this.transaction.rollback();
			   			this.transaction.destroy();
			   		}
		    		router.transitionTo('show_portfolio', portfolio);
			   	},
			   	connectOutlets: function(router, context) {
			   		Luxin.log('showing edit portfolio form');
			   		this.transaction = Luxin.store.transaction();
		   			this.transaction.add(context);
			   		var ac = router.get("applicationController");	
			   		ac.connectOutlet( { name: 'newPortfolio', outletName: 'detail', context: context } );
			   	}
		    }),
		    new_portfolio: Ember.Route.extend({
		    	route: '/new',		
		    	transaction: null,
		    	connectOutlets: function(router) {
		    		Luxin.log('showing new portfolio form');
		    		this.transaction = Luxin.store.transaction();	
		    		var newPortfolio = this.transaction.createRecord(Luxin.Portfolio, {} );
		    		var ac = router.get("applicationController"); 
		    		ac.connectOutlet({ name: 'newPortfolio', outletName: 'detail', context: newPortfolio });
		    	},
		    	save: function(router, event) {
		    		this.transaction.commit();
		    		router.transitionTo('show_portfolio', event.context);
		    	},
		    	cancel: function(router, event) {
		    		this.transaction.rollback();
		    		this.transaction.destroy();
		    		router.transitionTo('root.portfolios');
		    	}
		    })
	    })
	})
});

// start app
Luxin.initialize();