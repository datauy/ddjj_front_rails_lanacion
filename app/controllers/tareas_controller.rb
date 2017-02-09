require 'rubygems'
require 'open-uri'

include ExportarHelper

class TareasController < ApplicationController

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
