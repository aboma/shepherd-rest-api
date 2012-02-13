window.Mirrorball = Ember.Application.create();

Mirrorball.init = function() {
	// add portfolios list to left navigation
	Mirrorball.portfoliosListView = Mirrorball.portfoliosListView.create();
	Mirrorball.portfoliosListView.appendTo("#MbLeftNav");
};
