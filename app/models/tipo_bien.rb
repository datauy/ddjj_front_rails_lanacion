class TipoBien < ActiveRecord::Base
  attr_accessible :nombre
  has_many :biens
  has_many :nombre_biens
  
end
