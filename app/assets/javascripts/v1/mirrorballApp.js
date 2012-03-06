window.Mirrorball = Ember.Application.create();

Mirrorball.init = function() {
	Mirrorball.authorizedUser = Mirrorball.User.create();
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
	templateName: 'v1/templates/message/message',
	type: 'alert',
	messageType: null,
	message: '',
	isVisible: false
})


