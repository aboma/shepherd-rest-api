window.Mirrorball = Ember.Application.create();

Mirrorball.init = function() {
	// add portfolios list to left navigation
	Mirrorball.portView = Mirrorball.portfoliosListView.create();
	Mirrorball.portView.appendTo("#MbLeftNav");
};
