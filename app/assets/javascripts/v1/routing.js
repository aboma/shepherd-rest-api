

App.stateManager = Ember.StateManager.create({
  start: Ember.State.extend({
    index: Ember.State.extend({
      route: "/",

      setupContext: function(manager) {
        //manager.transitionTo('posts.index')
      }
    }),
    
    admin: Ember.State.extend({
    	route: "/admin",
    })
  })
})