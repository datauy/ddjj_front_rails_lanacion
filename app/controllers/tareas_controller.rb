require 'rubygems'
require 'open-uri'
require 'gattica'

include ExportarHelper

class TareasController < ApplicationController
  def get_ganalytics
# el modelo para las visitas es DjVista
# https://github.com/chrisle/gattica
	ga = Gattica.new({:email => 'lanacioncom@gmail.com', 
   		 :password => 'Bouchard557'})
	
	accounts = ga.accounts
	
	# ga.profile_id = accounts.first.profile_id
	ga.profile_id = 75328627 
	
	# start_date = end_date - (60*60*24) 
# 	
	t = Time.now
	# start_date = t.year.to_s+'-01-01'
	start_date = '2013-08-01'
	data = ga.get({ 
	  :start_date => start_date,
	  :end_date => (t.strftime "%Y-%m-%d"),
	  # :dimensions => ['pagePath', 'year'],
	  :dimensions => ['pagePath'],
	  :metrics => ['visits', 'pageviews'],
	  :sort => ['-pageviews'], 
	  :filters => ['pagePath =~ ^/declaraciones-juradas/ddjj/']
	  })
		# url =~ /\/declaraciones-juradas\/ddjj\/(.+)/
		# if url =~ /\/declaraciones-juradas\/ddjj\/(.+)/
			# $1
		# end
	data.points.each do |x|
		path = x.dimensions
		metrics = x.metrics
		url = path[0][:pagePath]
		if url =~ /\/declaraciones-juradas\/ddjj\/(.+)/	
			dj_flag = $1
			pagesViews = metrics[1][:pageviews]
			
			if dj = Ddjj.where("flag_search"  => dj_flag).first
				# if (pagesViews - dj.visitas) != 0
					# vista = DjVista.new(
						# :ddjj_id => dj.id, 
						# :fecha => (t.strftime "%Y-%m-%d"),
						# :visitas => (pagesViews - dj.visitas)
					# )
					# vista.save
				# end
				dj.visitas = pagesViews
				dj.save
			else
				error = ""
			end
		end
	end
	
  end

  def borrar_cache

  end 

  def crear_csv_poderes
  	# poderes = {0: "ddjj_poder_ejecutivo", 1: "ddjj_poder_le"}
  	Cargo::PODER.each_with_index do |poder, index|
	  	ddjjs_poder = Ddjj.includes([:persona, {:persona_cargo=>[:cargo, :jurisdiccion]}, :biens]).where("cargos.poder_id = ?", index).where("persona_cargos.id IS NOT NULL")
	  	File.open("public/ddjj_poder_#{poder}.csv", 'w') {|f| f.write(exportar_csv(ddjjs_poder)) }
  	end
  	flash[:notice] = 'Los archivos se crearon exitosamente!'
	redirect_to :controller=>'admin', :action => 'index'
  	# id = 0
  end

  def load_dnis  	
	ap = 0
	nom = 1
	cuil = 2
	dni= 3
	cuit = 4
	# es un archivo que manda gabriela con los dni actualizados
  	no_ingresados = []
  	data_csv = CSV.read("public/dni_personas.csv")
  	data_csv.each_with_index do |row, index|
		if index != 0
			pe = Persona.where("nombre = ? AND apellido = ?", row[nom], row[ap]).first
			
			if pe 
				pe = Persona.update(pe, 
					:cuit_cuil => row[cuit] ? row[cuit] : row[cuil],
					:documento => row[dni]
					)
			else
				no_ingresados.push(index)
			end
		end
	end

  	flash[:notice] = "Los DNI se cargaron correctamente! Estos Index de filas no se ingresaron: #{no_ingresados}"
	redirect_to :controller=>'admin', :action => 'index'
  end
end
