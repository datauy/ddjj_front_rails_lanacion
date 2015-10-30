class AdminController < ApplicationController
 http_basic_authenticate_with :name => Ddjj2::Application.config.basic_user, :password => Ddjj2::Application.config.basic_pass
  def index
    @title="Admin"
    @admin = "active"
  end

  def declaraciones_juradas
    
    p = params[:poder]
    @poder = Cargo::PODER[params[:poder].to_i]
    
    @title="DDJJ del poder #{@poder}"
     #buscar los titulares de ddjjs
    @d = Ddjj.includes([:persona, :persona_cargo => [:persona, :cargo] ]).where("cargos.poder_id" => p)
  end

  def ddjj
   @q = Persona.with_ddjjs 
   @d = Ddjj.find(params[:id])
   @d_b = @d.biens.order(:tipo_bien_s)  
  end
end
