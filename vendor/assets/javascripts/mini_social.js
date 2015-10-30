/* Mini social share */
/*
 *  For: @cbertelegni
 * 	
 * 	Posibles Redes Sociales:
 * 		Facebook
 * 		Twitter
 * 		Google Plus
 * 		Enviar URL por mail
 * 
 * # config -->
 * 	win : configuracíon completa de la ventana a abrir;
 * 	size : tamaño de la ventana;
 * 
 *  Ejemplo de uso:
 *  var social = new MiniSocial();
 * 	var boton = document.getElementById("facebook");
 * 	boton.onclick = function(){ 
 * 		social.share("facebook");
 * 		return false;
 *  };
 *
 */
function MiniSocial(config){
	var s = this;
	if (!config) var config = {};
	if (config.win){
		s.configWindow = config.win;		
	}else{
		s.configWindow = "toolbar=no, location=no, resizable=no, scrollbars= no, top=20%,left=50%";
		config.size ? s.configWindow += config.size : s.configWindow += "width=600, height=300";
	}	
	s.title = document.title;
	s.hashTag = "%23DDJJabiertas";
	s.href;
	s.get= {
		face: function(_url){
			var face = {
				u : s.href ,
				t : s.title
			};
			var url = 'http://www.facebook.com/share.php?' + $.param(face);
			return url;
		},
		twitter: function(){
			var url = "http://twitter.com/?status=" + s.hashTag + "%20" + s.href;
			return url;
		},
		plus: function(){
			var url = "https://plus.google.com/share?url=" + s.href;
			return url;
		},
		mail: function mailpage(){
			var url = "mailto:?subject=" + s.title;
			url += "&body=" + s.title + ": ";
			url += ". Enlace: " + s.href; 
			return url;
		}
	};
	s.share = function(social){
		s.href =  encodeURIComponent(window.location.href);
		switch (social){
			case "facebook":
				window.open( s.get.face(), "Facebook", s.configWindow);
				break;
			case "twitter":
				window.open( s.get.twitter(), "Twitter", s.configWindow);
				break;
			case "plus":
				window.open( s.get.plus(), "Google Plus", s.configWindow);
				break;
			case "mail":
				window.open( s.get.mail(), "Mail", s.configWindow);
				break;
		}
	};
}