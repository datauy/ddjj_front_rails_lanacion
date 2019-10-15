class Cargo < ActiveRecord::Base
  attr_accessible :cargo, :jurisdiccion, :poder_id
  has_many :persona_cargos
  has_many :personas, :through => :persona_cargos
  
  PODER = ["Otro", "Ejecutivo", "Legislativo", "Judicial"].freeze
  
  
  scope :todos, lambda{|poder| order("cargo").where("poder_id = ?", poder) }
  # scope :todos,-> {order("cargo").where("cargos.poder_id = 1")}
  
  def poder
  	if self.poder_id
  		PODER[self.poder_id.to_i]
  	end
  end

  def serializable_hash(options = nil)
    super({
      :only=>[:cargo],
      :method =>[:poder],
      :include=>[]
    }.merge(options || {}))
  end
end
