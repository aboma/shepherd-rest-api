// IMPORTANT - set default content type for ajax requests since
// ember-data rest adapter does not seem to do this
$.ajaxSetup({
    beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token',
                             $('meta[name="csrf-token"]').attr('content'));
        xhr.setRequestHeader('X-API-Version', 'v1');
 //       xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
 //       xhr.setRequestHeader('Data-Type', 'json');
 //       xhr.setRequestHeader('Accepts', 'application/json');
    }
});

window.Mirrorball = Ember.Application.create();

Mirrorball.init = function() {
	//Mirrorball.authorizedUser = Mirrorball.User.create();
};

Mirrorball.log = function(object) {
	debug.log(object);
}

Mirrorball.displayError = function(e) {
  if (typeof e === 'string') {
    // display error strings
    debug.log(e);
  }
  else if (typeof e === 'object' && e.responseText !== undefined) {
    // TODO - further process json errors
    debug.log(e.responseText);
  }
  else {
    alert("An unexpected error occurred.");
  }
};

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


