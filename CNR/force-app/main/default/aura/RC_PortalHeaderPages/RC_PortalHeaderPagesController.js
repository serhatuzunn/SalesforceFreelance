({
	init : function(component, event, helper) {
        debugger;
        var url = window.location.search.substring(1);
        url = url.split('&')[0];
        component.set("v.param", url);
	}
})