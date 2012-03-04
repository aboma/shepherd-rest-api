window.Mirrorball = Ember.Application.create();

Mirrorball.init = function() {
	// add portfolios list to left navigation
	Mirrorball.portView = Mirrorball.PortfoliosListView.create();
	Mirrorball.portView.appendTo("#MbLeftNav");
};

Mirrorball.log = function(object) {
	debug.log(object);
}

Mirrorball.Button = JQUI.Button.extend({
	//propagateEvents: true,
	//click: function() {
    //	this.set('disabled', true);
    //}
})

Mirrorball.Message = Ember.View.extend({
	tag: 'div',
	templateName: 'v1/templates/General/message',
	type: 'alert',
	messageType: null,
	message: '',
	isVisible: false
})


