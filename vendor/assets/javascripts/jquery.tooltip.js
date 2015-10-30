
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
			
			$(this).mousemove(function(e){
				postion.top= e.pageY - (tooltip.h / 2); 
				postion.left= e.pageX  + 20;
				
				// postion.top= e.pageY  + 30;
				// if((postion.top + tooltip.h) > (postion.parentH + 40)){ // valida position left
				// 	postion.top -= tooltip.h + 50; //exedente
				// }
				
				var validaLeft=(postion.left + tooltip.w) > postion.parentW;
				if(validaLeft){ // valida position left	
					var margin_cursor = 40;
					if( (e.pageX  - margin_cursor) - tooltip.w < 0){
						postion.left= margin_cursor;
					}else{
						postion.left= (e.pageX  - margin_cursor) - tooltip.w;
					}
				}
				tooltip.css({
					top: postion.top,
					left:postion.left
				});
			});
		},
		function(){
			tooltip.hide();
		});
	};
})(jQuery);
