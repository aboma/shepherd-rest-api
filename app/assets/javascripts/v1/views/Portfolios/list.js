Mirrorball.portfoliosListView = Ember.View.extend({
  templateName: 'v1/templates/Portfolios/list',
  portfoliosBinding: 'Mirrorball.portfoliosController',
  
  init: function() {
    this._super();
    this.set("portfolio", Mirrorball.portfolio.create());
  },

  show: function() {
  	//alert('showing form');
  	Mirrorball.PortNewForm = Mirrorball.PortfolioNewView.create();
  	Mirrorball.PortNewForm.appendTo("#MbForms");
  },
  
  submit: function(event) {
    var self = this;
    var content = this.get('content');
    
    Mirrorball.portfoliosController.newPortfolio(content);

  }
});