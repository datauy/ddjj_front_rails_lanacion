class PersonaCargo < ActiveRecord::Base
  attr_accessible :cargo_id, :egreso, :ingreso, :persona_id, :flag_ingreso, :jurisdiccion_id
  
  belongs_to :persona
  belongs_to :jurisdiccion
  belongs_to :cargo
  has_many :ddjjs

  def serializable_hash(options = nil)
    super({
      :only=>[:egreso, :ingreso],
      :method =>[],
      :include=>[:cargo, :jurisdiccion]
    }.merge(options || {}))
  end

end

# q = Persona.includes(:persona_cargos => [:cargo, :ddjjs] )
# q = Persona.includes(:persona_cargos => [:cargo, :ddjjs] ).where('persona_cargo.id=?', 3)