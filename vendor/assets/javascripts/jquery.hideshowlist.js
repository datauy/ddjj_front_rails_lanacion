// @cbertelegni - web developer
// requiere : jquery
// callback es un obj que puede recibir dos metodos (no es obligatorio): 
/*
var callback{
   afterClickLi: function(nodoHtml){ console.log(nodoHtml)}, // se ejecuta al click de los li
	afterShowUl: function(nodoHtml){ console.log(nodoHtml)}, // // se ejecuta después de mostrar un ul escondido
	afterHideUl: function(nodoHtml){ console.log(nodoHtml)} // // se ejecuta después de mostrar un ul escondido
}
*/

jQuery.fn.extend({
	hideshowlist: function(callback){ // navegacion desde lista
		callback ? callback : callback = {};
		var $this = $(this);
		var oNav = $this.find("li:has(ul)");
		var option = $this.find("li:not(:has(ul))");
		option.bind("click", function(){ // evento click sobre los items
				if(callback.afterClickLi) callback.afterClickLi(this);
				return false;
			});
		oNav.click(function(){ // muestra ul
			var el = this;
			var $ul = $(el).find("> ul");
			if($ul.is(":animated")){
				return false;
			}
			if($ul.is(":hidden")){
					
				data_type = el.getAttribute("data-type");
				if (data_type == "p" || data_type == "c" || data_type == "tb" || data_type == "v" || data_type == "a" ) {
					// $open = oNav.filter(".open").find("> ul");
					// oNav.filter(".open").removeClass("open").find("> ul").slideUp(300, function(){});
					oNav.filter(".open").removeClass("open").find("> ul").hide("fast");
				}
				
				$ul.slideDown(300, function(){	
					el.className= el.className + " open";
				});
				if(callback.afterShowUl) callback.afterShowUl(el);
			}else{
				$ul.slideUp(300, function(){
					el.className= el.className.replace(" open", "");
					if(callback.afterHideUl) callback.afterHideUl(el);
				});
			}
		  return false;
		});
	}
});
