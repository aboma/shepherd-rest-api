$.ajaxSetup({
	beforeSend : function(xhr) {
		xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr(
				'content'));
		xhr.setRequestHeader('X-API-Version', 'v1');
		xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
		xhr.setRequestHeader('X-AUTH-TOKEN', "<%= params[:auth_token] %>");
		// xhr.setRequestHeader('Content-Type', 'application/json;
		// charset=UTF-8');
		// xhr.setRequestHeader('Data-Type', 'json');
		// xhr.setRequestHeader('Accepts', 'application/json');
		return xhr;
	}
});

// add startWith function to string prototype
if (typeof String.prototype.startsWith != 'function') {
	String.prototype.startsWith = function(str) {
		return this.slice(0, str.length) == str;
	};
}

window.Luxin = Ember.Application.create();

if (!window.console) {
	window.console = {};
	window.console.log = function(object) {}
}

Luxin.displayError = function(e) {
	if (typeof e === 'string') {
		// display error strings
		console.log(e);
	} else if (typeof e === 'object' && e.responseText !== undefined) {
		// TODO - further process json errors
		console.log(e.responseText);
	} else {
		alert("An unexpected error occurred.");
	}
};

Luxin.Message = Ember.View.extend({
	tag : 'div',
	templateName : 'v1/templates/message/message',
	type : 'alert',
	messageType : null,
	message : '',
	isVisible : false
})
