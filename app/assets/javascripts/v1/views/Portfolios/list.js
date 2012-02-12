Mirrorball.portfoliosListView = Ember.View.extend({
  templateName: 'v1/templates/Portfolios/list',
  portfoliosBinding: 'Mirrorball.portfoliosController',
  
  init: function() {
    this._super();
    this.set("portfolio", Mirrorball.portfolio.create());
  },

  didInsertElement: function() {
    //this._super();
    //this.$('input:first').focus();
  },

  cancelForm: function() {
    this.get("parentView").hideNew();
  },

  submit: function(event) {
    var self = this;
    var content = this.get('content');
    
    Mirrorball.portfoliosController.newPortfolio(content);

  }
});