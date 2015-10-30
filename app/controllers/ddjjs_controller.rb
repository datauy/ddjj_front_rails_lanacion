class DdjjsController < ApplicationController
 http_basic_authenticate_with :name => Ddjj2::Application.config.basic_user, :password => Ddjj2::Application.config.basic_pass
  def index
  	p = params[:poder]
    @poder = Cargo::PODER[params[:poder].to_i]
    
    @title="DDJJ del poder #{@poder}"
     #buscar los titulares de ddjjs
    @d = Ddjj.includes([:persona, :persona_cargo => [:persona, :cargo] ]).where("cargos.poder_id" => p)
  end

  def show
  	@d = Ddjj.find(params[:id])
   	@d_b = @d.biens.order(:tipo_bien_s)
  end
  def update
    @d = Ddjj.find(params[:id])
    if @d.update_attributes(:status => params[:status])
        logger.debug @d
        render json: @d
    else
        render json: [:error=>"error"]
    end 
  end
  
  def destroy
    @d = Ddjj.find(params[:id])
    @d.biens.destroy_all
    # if @d.persona_cargo
    #   @d.persona_cargo.destroy
    # end
    @d.destroy
    
    render json: [:status=>200]
  end
end
