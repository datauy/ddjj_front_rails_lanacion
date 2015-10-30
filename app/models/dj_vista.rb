class DjVista < ActiveRecord::Base
  attr_accessible :ddjj_id, :fecha, :visitas
  
  belongs_to :ddjj
end
