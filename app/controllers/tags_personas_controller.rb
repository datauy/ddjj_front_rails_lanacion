# encoding: utf-8
require 'rubygems'
require 'roo'

class TagsPersonasController < ApplicationController
  def index
    def get_column c, s #las columnas empiezan desde 1
      if c
        if s
          i = c.index{ |e| e ? s.downcase.strip == e.downcase.strip : false}
          i = i ? i + 1 : i
        end
      end
    end
  	# https://docs.google.com/spreadsheet/ccc?key=0Aqs9oO5wQKY6dF9oTHNxQkh0OUlCaHNEcW41cnNMQkE&usp=drive_web#gid=0
  	# @oo = Roo::Google.new('0Aqs9oO5wQKY6dF9oTHNxQkh0OUlCaHNEcW41cnNMQkE')
  	@oo =  Roo::Excel.new('/home/cbertelegni/proyectos/ddjj2/tags/Tags_Nacion.xls', nil, :ignore)
  	@oo.default_sheet = @oo.sheets.first
  	@cabeza = @oo.row 1

  	@cols ={ 
  		:apellido=> get_column(@cabeza, "Apellido"),
  		:nombre=>get_column(@cabeza, "Nombre"),
  		:tag_id =>get_column(@cabeza, "tag_id"),
  		:tag_img_id =>get_column(@cabeza, "tag_imagen_id")
  		# :tag_descripcion =>get_column(@cabeza, "tag_descripcion")
  		#:ficha_d_l =>get_column(@cabeza, "Ficha Directorio Legislativo")
  	  	}

  	 # - tag_descripcion - tag_id -  - Url al tag 

  end


  def save_tags
    
    @csv = CSV.read("/home/cbertelegni/proyectos/ddjj2/tags/Tags_Nación.csv", "r", {:col_sep => ";"});
    
    @cols ={ 
        :apellido=>  @csv[0].index("apellido"),
        :nombre=> @csv[0].index("nombre"),
        :tag_id => @csv[0].index("tag_id"),
        :tag_img_id =>@csv[0].index("tag_imagen_id")
        # :tag_descripcion =>get_column(@cabeza, "tag_descripcion")
        #:ficha_d_l =>get_column(@cabeza, "Ficha Directorio Legislativo")
      }
  end
  
  def personas_sin_tags
    @p = Persona.get_personas_sin_tags

    respond_to do |format|
      # format.html
      format.json {render :json => @p}
      # format.js
      # {render :json => [:personas => @q, :cargos=> @cargos, :tipo_bienes=>@tipo_bienes, :nombre_bien=>@nombre_bien ] }
      format.xml  { send_data @p.to_xml, :type => "text/xml", :filename => "listado_personas_sin_tag_nacion.xml",:dispostion=>'inline', :status=>'200 OK'}
      # format.csv  { send_data exportar_csv, :type => "text/csv", :filename => @p_act.generar_file_name+".csv",:dispostion=>'inline',:status=>'200 OK'}
    end
  end

end
