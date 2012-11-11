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
		    	edit: Ember.Route.transitionTo('edit_portfolio'),
		    	add:  Ember.Route.transitionTo('add_asset'),
		    	connectOutlets: function(router, portfolio) {
		    		Luxin.log('portfolio selected');
		    		var psc = router.get('portfoliosController');
		    		psc.set('selected', portfolio);
		    		var ac = router.get("applicationController"); 
		    		ac.connectOutlet( { name: 'portfolio', outletName: 'detail', 
		    							context: portfolio } );	    		
		    	}
		    }),
			    
	    	edit_portfolio: Ember.Route.extend({
			   	route: '/:portfolio_id/edit',
			   	transaction: null,
			   	cancel: function(router, event) {
			   		// clean up unused transaction
			   		if (this.transaction) {
			   			this.transaction.rollback();
			   			this.transaction.destroy();
			   		}
			   		router.transitionTo('root.portfolios.show_portfolio', event.context);
			   	},
			   	remove : function(router, event) {
			   		event.context.deleteRecord();
			   		this.transaction.commit();
		    		router.transitionTo('root.portfolios');
			   	},
			   	save: function(router, event) {
			   		portfolio = event.context;
			   		// commit record if it has changed; exit function will 
			   		// clean up unused transaction
			   		if (portfolio.get('isDirty')){
			   			this.transaction.commit();
			   		}
		    		router.transitionTo('show_portfolio', portfolio);
			   	},
			   	connectOutlets: function(router, portfolio) {
			   		Luxin.log('showing edit portfolio form for ' + portfolio.get('name'));
			   		this.transaction = Luxin.store.transaction();
		   			this.transaction.add(portfolio);
			   		var ac = router.get("applicationController");	
			   		ac.connectOutlet( { name: 'editPortfolio', outletName: 'detail', context: portfolio } );
			   	},
			   	exit : function(router) {
			   		Luxin.log('exiting portfolio edit');
		    		var pc = router.get("editPortfolioController");
		    		pc.set('content', null);
		   			var ac = router.get("applicationController");	
			   		ac.disconnectOutlet("detail");
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
		    		ac.connectOutlet({ name: 'editPortfolio', outletName: 'detail', context: newPortfolio });
		    	},
		    	save: function(router, event) {
		    		var portfolio = event.context;
		    		// show portfolio, but only after it has been created
		    		// and has an id (for routing)
		    		portfolio.didCreate = function() {
		    			router.transitionTo('show_portfolio', portfolio);	
		    		};
		    		this.transaction.commit();
		    	},
		    	cancel: function(router, event) {
		    		router.transitionTo('root.portfolios');
		    		if (this.transaction) {
			    		this.transaction.rollback();
			    		this.transaction.destroy();
		    		}
		    	},
		    	exit : function(router) {
		    		var ac = router.get("applicationController"); 
			   		ac.disconnectOutlet("detail");
		    	}
		    }),
		    add_asset: Ember.Route.extend({
		    	route: '/:portfolio_id/new',
		    	transaction: null,
		    	connectOutlets: function(router, portfolio) {
		    		Luxin.log('showing new asset form');
		    		var ac = router.get("applicationController");
		    		ac.connectOutlet({ name: 'newAsset', outletName: 'detail', context: portfolio});
		    	},
		    	upload: function(router, event) {
		    		var form = event.target.form;
		    		var view = event.view;
		    		var form_data = new FormData(form);
		    		// append portfolio_id
		    		form_data.append('portfolio_id', event.context.get('id'));
		    		var uploadModel = new Luxin.Asset();
		    		var success_callback = function(){
		    			Luxin.log('uploaded!');
		    		}
		    		var error_callback = function() {
		    			Luxin.log('error uploading');
		    		}
		    		uploadModel.upload(form_data, success_callback, error_callback);
		    		console.log('upload event triggered');
		    		event.preventDefault();
		    	}
		    })
	    }),
	    assets: Ember.Route.extend({
	    	route: '/assets',
	    	connectOutlets: function(router) {
	    		Luxin.log('showing add asset form');
	    		var ac = router.get("applicationController");
	    		ac.connectOutlet({ name: 'assets'});
	    	}
	    })
	})
});

// start app
Luxin.initialize();