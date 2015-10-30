class NombreBien < ActiveRecord::Base
  attr_accessible :nombre, :nombre_bien_id
  
  has_many :biens
  belongs_to :tipo_bien
end
