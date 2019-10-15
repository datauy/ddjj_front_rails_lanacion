class Jurisdiccion < ActiveRecord::Base
  attr_accessible :nombre, :poder_id
  
  has_many :persona_cargos
  has_many :personas, :through => :persona_cargos
  
  PODER = ["Otro", "Ejecutivo", "Legislativo", "Judicial"].freeze
  
  scope :todos, lambda{|poder| order("cargo").where("poder_id = ?", poder) }

  def poder
  	if self.poder_id
  		PODER[self.poder_id.to_i]
  	end
  end

  def serializable_hash(options = nil)
    super({
      :only=>[:nombre],
      :method =>[:poder],
      :include=>[]
    }.merge(options || {}))
  end
end
