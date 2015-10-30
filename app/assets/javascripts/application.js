
//= require jquery.min
//= require jquery_ujs
//= require spin.min
//= require mini_social
//= require_tree .
Number.prototype.format = function(c, d, t){
        var n = this,
        c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
        j = (j = i.length) > 3 ? j % 3 : 0;
        var nn = s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
        return nn;
    };
    
    
String.prototype.toUpperCaseFirst = function(){
  return this.charAt(0).toUpperCase() + this.slice(1);
}
function Loading(content, showOninit){ // loading
	var self= this;
	self.opt= {
	  lines: 13, // The number of lines to draw
	  length: 10, // The length of each line
	  width: 5, // The line thickness
	  radius: 10, // The radius of the inner circle
	  corners: 1, // Corner roundness (0..1)
	  rotate: 0, // The rotation offset
	  direction: 1, // 1: clockwise, -1: counterclockwise
	  color: '#000', // #rgb or #rrggbb
	  speed: 1, // Rounds per second
	  trail: 60, // Afterglow percentage
	  shadow: false, // Whether to render a shadow
	  hwaccel: false, // Whether to use hardware acceleration
	  className: 'spinner', // The CSS class to assign to the spinner
	  zIndex: 2e9, // The z-index (defaults to 2000000000)
	  top: 'auto', // Top position relative to parent in px
	  left: 'auto' // Left position relative to parent in px
	};
	self.el = document.getElementById(content);
	self.$el = $(self.el);
	self.spinner = new Spinner(self.opt);
	
	self.start = function(){
		self.$el.fadeIn();
		self.spinner.spin(self.el);
	};
	self.esconder= function(){
		self.$el.fadeOut();
		self.spinner.stop();
	}
	// if (!showOninit) self.start();
}
function gen_iframe(conf){
	var i = document.createElement("iframe");
	i.src = conf.url; 
	i.style = conf.style; 
	i.width = conf.w ? conf.w : "100%"; 
	i.height = conf.h ? conf.h : "150"; 
	i.scrolling = conf.scroll ? conf.scroll : "no"; 
	return i;
}

jQuery.expr[':'].contains = function(a, i, m) {
        return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
    };

function get_to_obj(params){
    params = params.replace("?", "");
    a= params.split("&");
    var ob = {};
    a.forEach(function(x, i){
        tmp = x.split("=")
        ob[tmp[0]] =tmp[1];     
    
    });
    return ob;
}

// function event_btn_gen_iframes(){
function event_btns(){
	
	var popup = $(".popup"),
		cerrar = popup.find(".cerrar"),
		btn = $("div.footer a.btn");
	btn.click(function(){
		$this = $(this).attr("href");
		popup.fadeIn("fast", function(){
			$($this).slideDown();
		});
		return false;
	});
	
	cerrar.click(function(){
		$('.popup .cont').slideUp('slow', function(){
			popup.fadeOut("fast");
		});
		return false;
	})
	// var style_iframe = "width:100%; height: 150px; overflow:hidden";
	// $("#iframe_header").html(
	// 	gen_iframe({ url: "http://especiales.lanacion.com.ar/varios/declaraciones-juradas/header.html", style: style_iframe})
	// );
	// $("#iframe_footer").html(
	// 	gen_iframe({ url: "http://especiales.lanacion.com.ar/varios/declaraciones-juradas/footer.html", style: style_iframe})			
	// );
}

function urldecode(str) {
   return decodeURIComponent((str+'').replace(/\+/g, '%20'));
}