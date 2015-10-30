# -*- coding: utf-8 -*-
require 'xapian-fu'

namespace :ddjj do

  desc "borrar el indice existente"
  task :remove_index => :environment do
    $stderr.puts "Borrando el indice existente"
    FileUtils.rm_rf Rails.root.join('ddjjs.db').to_s
  end

  desc "Cargar el indice de búsqueda de texto"
  task :load_index => [:environment, :remove_index] do
    FIELDS = [
              :persona_id => { :type => Fixnum, :store => true, },
              :persona_nom_comp => { :type => String, :store => false},
              :persona_cargo_id => { :type => Fixnum, :store => true},
              :cargo_nombre => { :type => String, :store => false },
              :cargo_ingreso => { :type => Time, :store => false},
              :cargo_egreso => { :type => Time, :store => false},
              :dj_id => { :type => Fixnum, :store => true },
              :dj_nombres_bienes => { :type => String, :store => false},
              :dj_descripciones_bienes => { :type => String, :store => false}
             ]
    Rails.logger.info "*****LOAD INDEX*****"
    $stderr.puts "Cargando el índice de búsqueda"
    $stderr.puts
    db = XapianFu::XapianDb.new(:dir => Rails.root.join('ddjjs.db').to_s,
                                :language => :spanish,
                                :create => true,
                                :store => [:persona_id, :dj_id])

    Persona.with_ddjjs.each do |p|
      $stderr.puts "\t#{p.nom_comp}"
      p.persona_cargos.each do |pc|
        $stderr.puts "\t\t#{pc.cargo.cargo}"
        pc.ddjjs.each do |dj|
          $stderr.write "DDJJ#{dj.ano} "
          r = {
            :persona_id => p.id,
            :persona_nom_comp => p.nom_comp.downcase,
            :persona_cargo_id => pc.id,
            :cargo_nombre => pc.cargo.cargo.downcase,
            :cargo_ingreso => pc.ingreso,
            :cargo_egreso => pc.egreso,
            :dj_id => dj.id,
            :dj_nombres_bienes => dj.biens.map { |b| (b.nombre_bien_s || '').downcase }.flatten.uniq.join(" "),
            :dj_descripciones_bienes => dj.biens.map { |b| (b.descripcion || '').downcase }.flatten.uniq.join(" "),
          }
          
          db << r
          Rails.logger.debug r.to_yaml
        end # ddjjs
        $stderr.puts
      end # persona_cargos
      $stderr.puts
    end # personas
  end
end
