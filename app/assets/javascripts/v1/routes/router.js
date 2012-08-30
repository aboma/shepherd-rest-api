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
		    	edit: Ember.Route.transitionTo('edit_portfolio'),
		    	add:  Ember.Route.transitionTo('add_asset'),
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
		   			var ac = router.get("applicationController");	
			   		ac.disconnectOutlet("detail");
			   		router.transitionTo('root.portfolios.show_portfolio', event.context);
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
			   	connectOutlets: function(router, portfolio) {
			   		Luxin.log('showing edit portfolio form');
			   		if (this.transaction) {
			   			this.transaction.rollback();
			   			this.transaction.destroy();
			   		}
			   		this.transaction = Luxin.store.transaction();
		   			this.transaction.add(portfolio);
			   		var ac = router.get("applicationController");	
			   		ac.connectOutlet( { name: 'editPortfolio', outletName: 'detail', context: portfolio } );
			   	}
		    }),
		    new_portfolio: Ember.Route.extend({
		    	route: '/new',		
		    	transaction: null,
		    	connectOutlets: function(router) {
		    		Luxin.log('showing new portfolio form');
		    		this.transaction = Luxin.store.transaction();	
		    		var newPortfolio = this.transaction.createRecord(Luxin.Portfolio, {} );
		    		// remove any header details, if they exist
		    		var pc = router.get("editPortfolioController");
		    		pc.set('content', null);
		    		var ac = router.get("applicationController"); 
		    		ac.connectOutlet({ name: 'editPortfolio', outletName: 'detail', context: newPortfolio });
		    	},
		    	save: function(router, event) {
		    		this.transaction.commit();
		    		router.transitionTo('show_portfolio', event.context);
		    	},
		    	cancel: function(router, event) {
		    		this.transaction.rollback();
		    		this.transaction.destroy();
		    		var ac = router.get("applicationController"); 
			   		ac.disconnectOutlet("detail");
		    		router.transitionTo('root.portfolios');
		    	}
		    }),
		    add_asset: Ember.Route.extend({
		    	route: '/:portfolio_id/add',
		    	transaction: null,
		    	connectOutlets: function(router) {
		    		Luxin.log('showing add asset form');
		    	}
		    })
	    })
	})
});

// start app
Luxin.initialize();