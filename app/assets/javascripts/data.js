
$(function(){
	var f= new form_load_data();
	$(".datos").click(function(){ // muestra y esconde la data de las cabeseras en el data/save
		d = $($(this).attr("href"));
		console.log(d.is(":hidden"));
		if (d.is(":hidden")) {
			d.show();
		}else{
			d.hide();			
		};
		return false;
	});
});

function form_load_data(){ // acciones para el formulario
	var self = this;
	self.l = new Loading("loading");
	if(document.excel){
		self.form= document.excel;
		
		self.btn= $(self.form.commit);
		self.l;
		self.btn.click(function(e){
			//console.log("ok");

			e.preventDefault();
			var r =self.form.poder;
			//validacion
			var v= 0;
			var mensaje="";
			$(r).each(function(i){
				if(r[i].checked){ v= 1; mensaje=""; return}
				if (!v) mensaje = "Debe elegir un poder. ";
			});
			
			var file=self.form.file.value;
			
			if(file){
				if(v){ 
					self.l.start(); // loading...
					self.form.submit();
				}else{ 
					self.l ? self.l.esconder() : "";
					alert(mensaje);
				}
			}else{ 
				mensaje += "\n Debe elegir un archivo." 
				alert(mensaje);
			}
			// send data
			return false;
			//
		});
	}
}

function mostrar_datos(div) {

		
		
	}