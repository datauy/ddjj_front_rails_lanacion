class Buscador < ActiveRecord::Base
  attr_accessible :nombre_bienes, :personas, :poder, :cargos
end
