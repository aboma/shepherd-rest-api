Luxin.Router = Ember.Router.extend({
	enableLogging : true,
	location : 'hash',

	root : Ember.Route.extend({
		index : Ember.Route.extend({
			route : '/',
			redirectsTo : 'portfolios'
		}),
		portfolios : Ember.Route.extend({
			route : '/portfolios',
			showPortfolio : Ember.Route.transitionTo('show_portfolio'),
			createPortfolio : Ember.Route.transitionTo('new_portfolio'),
			edit : Ember.Route.transitionTo('edit_portfolio'),
			add : Ember.Route.transitionTo('add_asset'),
			connectOutlets : function(router) {
				Luxin.log('setting up portfolios route');
				var ac = router.get('applicationController');
				var pc = router.get('portfoliosController');
				ac.connectOutlet({
					name : 'portfolios',
					outletName : 'master',
					context : Luxin.store.findQuery(Luxin.Portfolio, '')
				});					
				// bind change in selected portfolio to trigger routing 
				// to show portfolio
				if (!pc.hasObserverFor('selectedPortfolio')) {
					Luxin.log('selected portfolio changed to ' + this.get('selectedPortfolio.name'));
					pc.addObserver('selectedPortfolio', function() {
						var portfolio = this.get('selectedPortfolio');
						if (portfolio)
							router.transitionTo('root.portfolios.show_portfolio', portfolio);
					});
				}
			},

			show_portfolio : Ember.Route.extend({
				route : '/:id',
		        deserialize:  function(router, context){
		            return Luxin.Portfolio.find( context.id );
		        },
		        serialize:  function(router, context){
		            return {
		               id: context.id
		            }
		        },
				edit : Ember.Route.transitionTo('edit_portfolio'),
				add : Ember.Route.transitionTo('add_asset'),
				connectOutlets : function(router, portfolio) {
					Luxin.log('showing portfolio');
					var ac = router.get("applicationController");
					ac.connectOutlet({
						name : 'portfolio',
						outletName : 'detail',
						context : portfolio
					});
				}
			}),

			edit_portfolio : Ember.Route.extend({
				route : '/:id/edit',
				transaction : null,
				deserialize : function(router, context) {
					return Luxin.Portfolio.find(context.id);
				},
				serialize : function(router, context) {
					return {
						id : context.id
					}
				},
				cancel : function(router, event) {
					// clean up unused transaction
					if (this.transaction) {
						this.transaction.rollback();
						this.transaction.destroy();
					}
					router.transitionTo('root.portfolios.show_portfolio', event.context);
				},
				remove : function(router, event) {
					var portfolio = event.context;
					var portfoliosController = router.get('portfoliosController');
					// delete portfolio and return to portfolios list
					portfolio.one('didDelete', function() {
						portfoliosController.set('selectedPortfolio', null);
						router.transitionTo('root.portfolios');
					});
					portfolio.deleteRecord();
					this.transaction.commit();
				},
				save : function(router, event) {
					portfolio = event.context;
					// commit record if it has changed; exit function will
					// clean up unused transaction
					if (portfolio.get('isDirty')) {
						// callback will show portfolio once the id is available
						portfolio.one('didLoad', function() {
							router.transitionTo('root.portfolios.show_portfolio', portfolio);
						});
						this.transaction.commit();
					} else {
						router.transitionTo('root.portfolios.show_portfolio', portfolio);
					}
				},
				connectOutlets : function(router, portfolio) {
					Luxin.log('showing edit portfolio form for '
							+ portfolio.get('name'));
					this.transaction = Luxin.store.transaction();
					this.transaction.add(portfolio);
					var ac = router.get("applicationController");
					ac.connectOutlet({
						name : 'editPortfolio',
						outletName : 'detail',
						context : portfolio
					});
				},
				exit : function(router) {
					Luxin.log('exiting portfolio edit');
					var pc = router.get("editPortfolioController");
					pc.set('content', null);
					var ac = router.get("applicationController");
					ac.disconnectOutlet("detail");
				}
			}),
			new_portfolio : Ember.Route.extend({
				route : '/new',
				transaction : null,
				connectOutlets : function(router) {
					Luxin.log('showing new portfolio form');
					this.transaction = Luxin.store.transaction();
					var newPortfolio = this.transaction.createRecord(Luxin.Portfolio, {});
					var ac = router.get("applicationController");
					ac.connectOutlet({
						name : 'editPortfolio',
						outletName : 'detail',
						context : newPortfolio
					});
				},
				save : function(router, event) {
					var portfolio = event.context;
					// create callback so that portfolio is shown once it is
					// created and has an id (for URL serialization)
					if (portfolio.get('isDirty')) {
						// callback will show portfolio once the id is available
						portfolio.one('didCreate', function() {
							router.transitionTo('root.portfolios', portfolio);
						});
						this.transaction.commit();
					}
				},
				cancel : function(router, event) {
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
			add_asset : Ember.Route.extend({
				route : '/:portfolio_id/add',
				transaction : null,
				connectOutlets : function(router) {
					Luxin.log('showing add asset form');
				}
			})
		})
	})
});

// start app
Luxin.initialize();