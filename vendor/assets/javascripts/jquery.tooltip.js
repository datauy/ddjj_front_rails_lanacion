
(function($){
// tooltip
	$.tooltip = function (objetoOver, tooltip, callBack){
// 		objetoOver
// 		tooltip
//		callBack

		var postion={ left:0, top:0, parentW: objetoOver.parent().width(), parentH: objetoOver.parent().height() };
		objetoOver.hover(function(e){


			if(callBack)
				callBack(this); // CALLBACK recibe el objeto over

			tooltip.show(); // muestra el tooltip
			tooltip.w = tooltip.width(); // capturamos el width
		 	tooltip.h = tooltip.height(); // capturamos el height

		},
		function(){
			tooltip.hide();
		});
		objetoOver.mousemove(function(e){
			postion.top= e.pageY - (tooltip.h / 2);
			postion.left= e.pageX  + 20;
			tooltip.css({
				top: postion.top,
				left:postion.left
			});
		});
	};
})(jQuery);
