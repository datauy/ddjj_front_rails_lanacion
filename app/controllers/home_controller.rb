# -*- coding: utf-8 -*-
include ExportarHelper
# require '../../script/genera_indice_buscador.rb'

class HomeController < ApplicationController
  layout "front_end"
  # require 'csv'
  def index

    @title = "Declaraciones Juradas"
    @CANTIDAD_DDJJS = Rails.cache.fetch("CANTIDAD_DDJJS", :expires_in => CANT_DJ_Y_ULT_ACT) do
              q = Ddjj.includes({:persona_cargo=>:cargo}).where("cargos.poder_id is not null").count
            end
    @last = Rails.cache.fetch("ULTIMA_ACTUALIZACION", :expires_in => CANT_DJ_Y_ULT_ACT) do
              q = Ddjj.order("updated_at desc").limit(1).first.updated_at
            end
    @count_ddjjs_0 = Rails.cache.fetch("count_ddjjs_0", :expires_in => CANT_DJ_Y_ULT_ACT) do
                  q = Ddjj.includes({:persona_cargo=>:cargo}).where("cargos.poder_id = ?", 0).count
            end
    @count_ddjjs_1 = Rails.cache.fetch("count_ddjjs_1", :expires_in => CANT_DJ_Y_ULT_ACT) do
                  q = Ddjj.includes({:persona_cargo=>:cargo}).where("cargos.poder_id = ?", 1).count
            end
    @count_ddjjs_2 = Rails.cache.fetch("count_ddjjs_2", :expires_in => CANT_DJ_Y_ULT_ACT) do
                  q = Ddjj.includes({:persona_cargo=>:cargo}).where("cargos.poder_id = ?", 2).count
            end
  end
  
  def get_filtros
    # expires_in TIME_CACHE_FILTROS, :public => true
    
    poder = params[:id].to_i
    if poder == 0 || poder == 1 || poder == 2
      @key_cache = "filtros_" + poder.to_s
      
    
      @q = Persona.get_personas.where("cargos.poder_id" => poder).order(:apellido, 'cargos.cargo')
      cc = @q.map { |p| (p.persona_cargos || '') }.flatten.uniq
      c = cc.map{ |c| (c.cargo || "")}.flatten.uniq
      @cargos = c.sort{|x,y| x.cargo <=> y.cargo}

      @tipo_bienes = TipoBien.all
      # @nombre_bien = NombreBien.includes(:biens => :ddjj ).where("ddjjs.poder_id" => poder).order(:nombre)
      @nombre_bien = NombreBien.joins( :biens => :ddjj ).where("ddjjs.poder_id" => poder).order(:nombre).flatten.uniq
      @anos = Ddjj.uniq.pluck(:ano).sort()

    end

    
     respond_to do |format|
      format.html { render :layout => false }
      # format.json {render :json => [:personas => @q, :cargos=> @cargos, :tipo_bienes=>@tipo_bienes, :nombre_bien=>@nombre_bien ]}
      # format.js
      # {render :json => [:personas => @q, :cargos=> @cargos, :tipo_bienes=>@tipo_bienes, :nombre_bien=>@nombre_bien ] }
      # format.xml  { send_data exportar.to_xml, :type => "text/xml", :filename => @p_act.generar_file_name+".xml",:dispostion=>'inline',:status=>'200 OK'}
      # format.csv  { send_data exportar_csv, :type => "text/csv", :filename => @p_act.generar_file_name+".csv",:dispostion=>'inline',:status=>'200 OK'}
    end
  end 

  def search
    @key_cache = "search_"
    @CANTIDAD_DDJJS = 0#Ddjj.count
    # params
      # :p / persona
      # :c / cargo
      # :tb / tipo bien
      # :nb / nombre bien
      # :v de los vienes
      # :a / año
      # :pd / poder
      # :ord / orden
    @q = Persona.with_ddjjs
    if params[:str]
      @key_cache += params[:str]
      
      if params[:str].length > 3
          # str = "%#{params[:str]}%"
          # personas = params[:str].split(", ")
        
         # @q = @q.where("ddjjs.id" => SEARCH_INDEX.search(params[:str]).map { |r|
         #              r.values[:dj_id]
         #            })
 
      @q = @q.where("ddjjs.id" => ContenidoDdjj.search(params[:str]).map { |r|
                      # $stderr.puts r.ddjj_id
                      r.ddjj_id
                    })
      else
        @query_muy_corta = true
      end                    
    else

      if params[:p]
         @key_cache += params[:p]
        @q = @q.where("personas.id" => params[:p].split("_"))
      end
      #cargos
      if params[:c]
        @key_cache += params[:c]
        @q = @q.where("persona_cargos.cargo_id" => params[:c].split("_"))
      end
      # Tipo bien
      if params[:tb]
        @key_cache += params[:tb]
        @q = @q.where("biens.tipo_bien_id"=> params[:tb].split("_"))
      end
      # nombre bien
      if params[:nb]
        @key_cache += params[:nb]
        @q = @q.where("biens.nombre_bien_id"=> params[:nb].split("_"))
      end
      # valor
      if params[:v]
        @key_cache += params[:v]
        valor = params[:v].split("-")
        @q = @q.where("biens.valor_fiscal > ? OR biens.valor_adq > ?", valor[0], valor[0])
        @q = @q.where("biens.valor_fiscal < ? OR biens.valor_adq < ?", valor[1], valor[1]) if valor[1] != "mas"
      end
      #año
      if params[:a]
        @key_cache += params[:a]
        @q = @q.where("ddjjs.ano" => params[:a].split("_"))
      end
      # if params[:rkg]
      #   @key_cache += params[:rkg]
      #   @q = @q.order("ddjjs.visitas desc", 'ddjjs.ano DESC', 'personas.apellido' )    
      # else
      #   if params[:ord] && params[:ord] == "desc"
      #     @key_cache += params[:ord]
      #     @q = @q.order("personas.apellido desc")
      #   else
      #     @key_cache += "_asc"
      #     @q = @q.order("personas.apellido asc")
      #   end
      # end
      
    end
    if params[:ord] && params[:ord] == "desc"
      @key_cache += params[:ord]
      @q = @q.order('personas.apellido desc', "ddjjs.ano DESC")
    else
      @key_cache += "_asc"
      @q = @q.order("personas.apellido asc", "ddjjs.ano DESC")
    end
    #poder
    if params[:pd]
      @key_cache += params[:pd]
      @q = @q.where("cargos.poder_id" => params[:pd].split("_"))
    end
    #personas
    
    
    if params[:page]
      @key_cache += "page_" + params[:page]
      # offset = per_page * params[:page].to_i
      @q = @q.page(params[:page])
    else
      @q = @q.page(1)
    end
    
     # render :html => @q
      # render :layout => false
      # render :json => @q, :callback => params[:callback]

    respond_to do |format|
      format.html {render :layout => false}
      format.json {send_data @q.to_json(:include=>[]),:type => "text/json", :filename => "result"+".json",:dispostion=>'inline',:status=>'200 OK' }
      # format.json {render :json => @q}
      # format.csv {render text: @q.to_csv}
    end
  end
  
  def get_ddjj
    @key_cache = "get_ddjj" + params[:id]
    # @ddjj = Ddjj.find(params[:id], {:include => [:biens, :persona]})
    # @ddjj = Ddjj.includes(:biens, {:persona_cargo=>[:persona, :cargo]}).order("biens.nombre_bien_id").find(params[:id])
    @ddjj = Ddjj.includes(:biens, {:persona_cargo=>[:persona, :cargo, :jurisdiccion]}).order(["biens.nombre_bien_id", "biens.valor_fiscal DESC", "biens.valor_adq DESC"] ).where(:flag_search => params[:id]).first 
    # @ddjj = Rails.cache.fetch(@key_cache, :expires_in => TIME_CACHE_VIEW_DDJJ) do
    #           q = Ddjj.includes(:biens, {:persona_cargo=>[:persona, :cargo, :jurisdiccion]}).order(["biens.nombre_bien_id", "biens.valor_fiscal DESC", "biens.valor_adq DESC"] ).where(:flag_search => params[:id]).first
    #         end
  
    unless @ddjj
      respond_to do |format|
        format.html {render(:file => "public/404.html", :layout => false, :status => 404)}
        format.json {send_data "not found 404",:type => "text/json", :filename => "404.json",:dispostion=>'inline',:status=>'404'}
      end
    else
      respond_to do |format|
        format.html
        format.json {send_data @ddjj.to_json(:include=>[:persona, :persona_cargo, :biens]),:type => "text/json", :filename => @ddjj.flag_search+".json",:dispostion=>'inline',:status=>'200 OK' }
        format.xml {send_data @ddjj.to_xml(:include=>[]),:type => "text/xml", :filename => @ddjj.flag_search+".xml",:dispostion=>'inline',:status=>'200 OK' }
        format.csv {send_data exportar_csv([@ddjj]),:type => "text/csv", :filename => @ddjj.flag_search+".csv",:dispostion=>'inline',:status=>'200 OK' }
      end
    end
  end

  def comparador
  end


  def data_bienes
    expires_in TIME_CACHE_DATA_JSON, :public => true
    @data = []
    @key_cache = "data_bienes"
    if params[:q]
      
      if params[:q].length > 2 
        @data = Rails.cache.fetch(params[:q], :expires_in => TIME_CACHE_DATA_JSON) do
            bienes = NombreBien.where("nombre_biens.nombre LIKE ?", "%#{params[:q]}%")
            bienes.map{|d| d.nombre}
        end
      end
    end
    
    headers['Access-Control-Allow-Origin'] = '*'
    render json: @data
  end
  def data_personas
    expires_in TIME_CACHE_DATA_JSON, :public => true
    @data = []
    @key_cache = "data_personas"
    if params[:q]
      @key_cache +=params[:q]
      if params[:q].length > 2
        @data = Rails.cache.fetch(@key_cache, :expires_in => TIME_CACHE_DATA_JSON) do
          # personas = Persona.get_personas.where("personas.nombre LIKE ? OR personas.apellido LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").order(:apellido)
          personas = ContenidoDdjj.where("persona_str LIKE ? ", "%#{params[:q]}%").order(:persona_str)
          # $stderr.puts personas.to_yaml
          personas.map{|d| d.persona_str}
        end
      end
    end
    headers['Access-Control-Allow-Origin'] = '*'
    render json: @data
  end

  def descargar_poder
    filename = "none"
    id = params[:id].to_i
    if id == 0 ||id == 1 ||id == 2
        # d = TiempoControl.first
        # dias = d ? d.dias.to_i : 0
        # # logger.debug "#{@q.length.to_s}"
        # key_cache = "descargar_" + Cargo::PODER[id] + "_#{dias.to_s}"
        # # chequear esto!!! la fecha de subida rompe la query para el legislativo
        
        # # @q = Ddjj.includes([:persona, {:persona_cargo=>[:cargo, :jurisdiccion]}, :biens]).where("cargos.poder_id = ? AND ddjjs.created_at < ?", id, dias.ago).where("persona_cargos.id IS NOT NULL")
        # @q = Ddjj.includes([:persona, {:persona_cargo=>[:cargo, :jurisdiccion]}, :biens]).where("cargos.poder_id = ?", id).where("persona_cargos.id IS NOT NULL")
      
      filename = "ddjj_poder_#{Cargo::PODER[id]}.csv"
    else
      filename = "ddjj_poder_#{Cargo::PODER[0]}.csv" # por default le pongo el ejecutivo
    end
      file_response = File.read("public/#{filename}")

    respond_to do |format|
      # format.json {send_data @q.to_json(:include=>[:persona, :persona_cargo, :biens]),:type => "text/json", :filename => Cargo::PODER[id]+".json",:dispostion=>'inline',:status=>'200 OK' }
      # format.xml {send_data @q.to_xml(:include=>[]),:type => "text/xml", :filename => Cargo::PODER[id]+".xml",:dispostion=>'inline',:status=>'200 OK' }
      format.csv  {send_data file_response, :type => "text/csv", :filename => filename, :dispostion=>'inline',:status=>'200 OK'}
    end
  end
  
  def lista_personas
    @p = Persona.get_personas

    respond_to do |format|
      format.html
      format.json {render :json => @p}
      # format.js
      # {render :json => [:personas => @q, :cargos=> @cargos, :tipo_bienes=>@tipo_bienes, :nombre_bien=>@nombre_bien ] }
      format.xml  { send_data @p.to_xml, :type => "text/xml", :filename => "listado_personas_sin_tag_nacion.xml",:dispostion=>'inline',:status=>'200 OK'}
      # format.csv  { send_data exportar_csv, :type => "text/csv", :filename => @p_act.generar_file_name+".csv",:dispostion=>'inline',:status=>'200 OK'}
    end
  end
end
