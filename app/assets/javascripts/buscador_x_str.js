
$(document).bind("ready", function(){
	var input_str 	= $("input#str"),
		buscar 		= $("a#buscar_str"),
		poderes_str	= $("div.buscador ul.filtro li")
		action_index = $("body").hasClass('index');

		poderes_str.bind("click", select_poder_to_search);

		$("input#str").typeahead([
			{
				name: 'bienes',
			 	remote: input_str.data("bienes")+"?q=%QUERY",
			 	header: '<h3 class="league-name">Bienes</h3>'
			},
			{
				name: 'personas',
			 	remote: input_str.data("personas")+"?q=%QUERY",
			 	header: '<h3 class="league-name">Personas</h3>'
			}
		]);


	input_str.focus(function(){	// focus para el buscador x string
		var $el = $(this);
		$el.keyup(function(event){ // enter key!
		    if(event.keyCode == 13){
				// if (action_index){}else{}
				if(!action_index)
					location.href= get_link(buscar, input_str)
				else
					buscar.click();
		    }
		});
	});

	buscar.click(function(){
		buscar.attr("href", get_link(buscar, input_str));
	});
});

function get_link($el, input){
	var pd = $.map($(".buscador ul.filtro li"), function(v, i){
					// p.h2 += i == 0 ? v.getAttribute("data-str") : " / "+ v.getAttribute("data-str");
					return v.getAttribute("data-id");
				}).join("_");

	return	$el.data("action") + "#str=" + input.val() + "&pd=" + pd;
}

function select_poder_to_search(){ // adiciona un poder para buscar x str
	var $this = $(this);
		if($this.is(".selected")){
			$this.removeClass("selected");
		}else{
			$this.addClass("selected");
		}
	return false;
};
