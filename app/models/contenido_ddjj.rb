class ContenidoDdjj < ActiveRecord::Base
  attr_accessible :cargo_id, :cargo_str, :contenido, :ddjj_ano, :ddjj_id, :ddjj_tipo, :persona_id, :persona_str, :poder_id

  scope :search, lambda {|str| {:conditions=>["contenido LIKE ?","%#{str}%"]}}
  	
end
