# genera_indice_buscador.rb
# encoding: utf-8
module GeneraIndiceBuscador
	def generar_str_buscador # agrupa el contenido de las ddjj en una tabla para optimizar busquedas x texto 
	    ContenidoDdjj.destroy_all
	    Persona.with_ddjjs.each do |p|
	      $stderr.puts "\t#{p.nom_comp}"
	      p.persona_cargos.each do |pc|
	        $stderr.puts "\t\t#{pc.cargo.cargo}"
	        pc.ddjjs.each do |dj|
	          $stderr.write "DDJJ#{dj.ano} "
	          cont_dj = ContenidoDdjj.new(
	            # :cargo_id,
	            # :cargo_str,
	            :contenido => [
	              p.nom_comp.downcase,
	              pc.cargo ? pc.cargo.cargo.downcase : "",
	              dj.biens.map { |b| (b.tipo_bien_s || '').downcase }.flatten.uniq.join(" "),
	              dj.biens.map { |b| (b.nombre_bien_s || '').downcase }.flatten.uniq.join(" "),
	              dj.biens.map { |b| (b.descripcion || '').downcase }.flatten.uniq.join(" "),
	              dj.biens.map { |b| (b.provincia || '').downcase }.flatten.uniq.join(" "),
	              dj.biens.map { |b| (b.localidad || '').downcase }.flatten.uniq.join(" "),
	              dj.biens.map { |b| (b.destino || '').downcase }.flatten.uniq.join(" "),
	              dj.biens.map { |b| (b.entidad || '').downcase }.flatten.uniq.join(" "),
	              dj.biens.map { |b| (b.ramo || '').downcase }.flatten.uniq.join(" ")
	              ].join(" "),
	            :persona_str => p.nom_comp,
	            :ddjj_ano => dj.ano,
	            :ddjj_id => dj.id,
	            :ddjj_tipo => dj.tipo_ddjj_id,
	            :persona_id => p.id,
	            :poder_id => dj.poder_id
	            ).save
	          # Rails.logger.debug cont_dj.to_yaml
	        end # ddjjs
	        $stderr.puts
	      end # persona_cargos
	      $stderr.puts
	    end # personas
	end
end