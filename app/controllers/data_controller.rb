# encoding: utf-8
require 'rubygems'
require 'roo'
require 'gattica'
include GeneraIndiceBuscador
class DataController < ApplicationController
 http_basic_authenticate_with :name => Ddjj2::Application.config.basic_user, :password => Ddjj2::Application.config.basic_pass
  def save
    @title = "ddjj"
    @key = Time.now.to_i
    @title = "Load test"
    @poder = Integer params[:poder] # Cargo::PODER
    @status = params[:status] # Cargo::PODER

    temp_path_file = params[:file].path
    content_type = params[:file].content_type
    def get_column c, s #las columnas empiezan desde 1
      if c
        if s
          i = c.index{ |e| e ? s.downcase.strip == e.downcase.strip : false}
          i = i ? i + 1 : i
        end
      end
    end
    def get_column_reverse c, s #las columnas empiezan desde 1
      if c
        if s     
          i = c.reverse.index{ |e| e ? s.downcase.strip == e.downcase.strip : false }
          i = i ? c.length - i : i
        end
      end
    end
      
    # oo = Excel.new("public/test.xlsx")
    # logger.debug "******************* Creando: @oo **************************"
    # @oo = Excelx.new(temp_path_file, nil, :ignore) if content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' 
    # @oo = Excel.new(temp_path_file, nil, :ignore) if content_type == 'application/vnd.ms-excel'
    
    @oo = Roo::Excelx.new(temp_path_file, nil, :ignore) if content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    @oo = Roo::Excel.new(temp_path_file, nil, :ignore) if content_type == 'application/vnd.ms-excel'
    @oo.default_sheet = @oo.sheets.first
    @cols = @oo.row 2
    logger.debug "******************* #{@cols.to_yaml} **************************"
    @dj = {
        # Ddjj
        :ano => (get_column @cols, "Año"),
        # :tipo_ddjj => (get_column @cols, "Tipo"),
        :tipo_ddjj => (get_column @cols, "TipoDecl"), # en poder judicial
        :funcionario => (get_column @cols,"Funcionario"),
        :clave => (get_column @cols, "Clave"),
        # :persona_cargo_id => "",
        # :url => (get_column @cols, "URL"), # en el excel poder judicial aparece -> "Document Cloud"
        :url => (get_column @cols, "Document Cloud"),
        
        # Datos personales
        :apellido => (get_column @cols, "Apellido"),
        :nombre => (get_column @cols, "Nombres"),
        :tipo_documento => (get_column @cols, "Doc.Tipo"),
        :documento => (get_column @cols, "Doc. Nro."),
        :legajo => (get_column @cols, "Legajo"),
        :cuit_cuil => (get_column @cols, "CUIT/CUIL"),
        :nacimento => (get_column @cols, "Fecha Nac."),
        :sexo => (get_column @cols, "Sexo"),
        :estado_civil =>(get_column @cols, "Est. Civil"),
        :vinculo => (get_column @cols, "Vínculo"),
        :vinculo_con_quien => (get_column @cols, "Vínculo con quien"),
        ###:legajo => (@oo.row 2).index(""),
        
        # Cargo
        :ingreso_apn => (get_column @cols, "Ingreso APN"),
        :jurisdiccion =>(get_column @cols, "Jurisdicción"),
        :cargo => (get_column @cols, "Cargo"),
        :poder_id => @poder, # set poder id, Cargo::PODER
        
       # Bien
       :tipo_bien => (get_column @cols, "Tipo de Bienes"), ## habia un espacio al final
       :nombre_bien =>  (get_column_reverse @cols, "Tipo"),    #(get_column @cols, "Tipo"),
       :descripcion => (get_column @cols, "Descripción"),
       :direccion => (get_column @cols, ""),
       :barrio => (get_column @cols, "Barrio/Zona"),
       :localidad => (get_column @cols, "Localidad"),
       :provincia => (get_column @cols, "Provincia"),
       :pais => (get_column @cols, "País"),
       :modelo => (get_column @cols, "Modelo"),
       :entidad => (get_column @cols, "Entidad"),
       :ramo => (get_column @cols, "Ramo"),
       :cant_acciones => (get_column @cols, "Cant. acciones"),
       :fecha_desde => (get_column @cols, "F.Desde"),
       :origen => (get_column @cols, "Origen"),
       :superficie => (get_column @cols, "Superficie"),
       :unidad_medida => (get_column @cols, "U. Medida"),
       :m_mejoras => (get_column @cols, "Moneda Mejoras"), #pesos x default
       :mejoras => (get_column @cols, "Mejoras"),
       :m_valor_fiscal => (get_column @cols, "Moneda"),
       :valor_fiscal => (get_column @cols, "Valor/Fiscal"),
       :m_valor_adq => (get_column_reverse @cols, "Moneda"), # agarra el ultimo
       :valor_adq => (get_column @cols, "Valor Adq."),
       :fecha_hasta => (get_column @cols, "F.Hasta"),
       :titular_dominio => (get_column @cols, "Titular del dominio"),
       :porcentaje => (get_column @cols, "Porcentaje"),
       :obs => (get_column @cols, "Obs"),
       :destino => (get_column @cols, "Destino"),
       :periodo => "",
       # :persona_id => "",
      } 
     if @poder == Cargo::PODER.index("Ejecutivo")
       
     end
  
 
  end

  def load
    @title = "Subir datos"
    @load = "active"
  end
  
  
  def gen_str_buscador # agrupa el contenido de las ddjj en una tabla para optimizar busquedas x texto 
    generar_str_buscador
  end
  
  def get_ganalytics
    
  end
  
  def reset_bd
      p "reset"
  end
  
  def correr_xapian
    
  end
  
  
  
  def dump_db
    
  end
end
