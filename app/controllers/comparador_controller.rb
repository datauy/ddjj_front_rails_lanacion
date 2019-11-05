# -*- coding: utf-8 -*-
include ExportarHelper

class ComparadorController < ApplicationController
  layout "front_end"
  # require 'csv'
  def index
    @personas = Persona.get_personas
    @options = []
  end

  def currency_transformation
    country_currency = {
      'ARS' => [29.27, 17.227, 15.359, 9.617, 8.448, 5.704],
      'COP' => [2977, 3145, 3145, 3145, 3145, 3145],
      'GTQ' => [7.54, 7.54, 7.54, 7.54, 7.54, 5.704]
    }
    # se considera 2018 como año 0
    #https://es.investing.com/currencies/usd-cop-historical-data
    @from = params[:from]
    @value = params[:amount].to_f/country_currency[@from][0]
    respond_to do |format|
      format.json do
        render json: {amount: @value}.to_json()
      end
    end
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
    @currency = params[:currency]
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
