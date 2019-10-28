# -*- coding: utf-8 -*-
include ExportarHelper

class ComparadorController < ApplicationController
  layout "front_end"
  # require 'csv'
  def index
    @personas = Persona.get_personas
    @options = []
  end

  def get_personas_ddjj
    if params[:pid]
      persona = Persona.find(params[:pid])
      @col = params[:col]
      @options = [{id: -1, text: "Seleccione una DJ"}]
      persona.ddjjs.each do |d|
        @options <<  { id: d.id, text: "DDJJ del #{d.ano}" }
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def ddjj2compare
    @key_cache = "get_ddjj" + params[:id]
    @col = params[:col]
    Rails.logger.info { "\n\nCOL:"+params[:col] }
    @ddjj = Ddjj.includes(:biens, {:persona_cargo=>[:persona, :cargo, :jurisdiccion]}).order(["biens.nombre_bien_id", "biens.valor_fiscal DESC", "biens.valor_adq DESC"] ).where(:id => params[:id]).first
    respond_to do |format|
      format.js
    end
  end

end

def get_ddjj
  respond_to do |format|
    format.json {send_data @ddjj.to_json(:include=>[:persona, :persona_cargo, :biens]),:type => "text/json", :filename => @ddjj.flag_search+".json",:dispostion=>'inline',:status=>'200 OK' }
  end
end
