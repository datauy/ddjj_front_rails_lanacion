class TiempoControlsController < ApplicationController
 # http_basic_authenticate_with :name => Ddjj2::Application.config.basic_user, :password => Ddjj2::Application.config.basic_pass
  def index
    
  	unless TiempoControl.first
  		t = TiempoControl.new(:dias=>"1")
  		t.save
  	end
    @tiempo = TiempoControl.first
  end

  # def show
  # 	@d = Ddjj.find(params[:id])
  #  	@d_b = @d.biens.order(:tipo_bien_s)
  # end
  def update
    t = TiempoControl.find(params[:id])
    if t.update_attributes(:dias => params[:dias])
        logger.debug t
        render json: t
    else
        render json: [:error=>"error"]
    end 
  end
  
  # def destroy
  #   @d = Ddjj.find(params[:id])
  #   @d.biens.destroy_all
  #   # if @d.persona_cargo
  #   #   @d.persona_cargo.destroy
  #   # end
  #   @d.destroy
    
  #   render json: [:status=>200]
  # end
end
