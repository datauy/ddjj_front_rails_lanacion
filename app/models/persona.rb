# encoding: utf-8
class Persona < ActiveRecord::Base
  attr_accessible :apellido, :cuit_cuil, :documento, :estado_civil_id, :legajo, :nacimento, :nombre, :sexo_id, :tipo_documento_id, :email, :tag_id, :tag_img_id, :tag_descripcion, :ficha_d_l

  has_many :ddjjs
  has_many :persona_cargos
  has_many :cargos, :through => :persona_cargos
  has_many :biens

  TIPO_DOCUMENTO  = ["dni", "le", "lc", "pasaporte"].freeze
  SEXO  = ["M", "F"].freeze
  ESTADO_CIVIL  = ["Casado/a", "Cónyugue", "Divorciado/a", "Separado", "Soltero/a", "U. Hecho", "Viudo/a"].freeze

  self.per_page = 20
  def nom_comp
    self.apellido.to_s + ", " + self.nombre.to_s
  end
  def get_tag_nacion
    if self.tag_id
      http = "http://www.lanacion.com.ar/#{self.tag_descripcion ? self.tag_descripcion.gsub(' ', '-') : ""}-t#{self.tag_id}"
    end
    # self.apellido.to_s + ", " + self.nombre.to_s
  end

  def url_buscador_app
    "http://interactivos.lanacion.com.ar/declaraciones-juradas/#str=#{URI.escape(self.nom_comp)}"
  end

  def get_img_nacion width = nil
    if self.tag_img_id
      img = "http://bucket3.clanacion.com.ar/anexos/fotos/#{self.tag_img_id[-2..-1]}/#{self.tag_img_id}"
      img += width ? "w#{width}.jpg" : ".jpg"
    end
  end

  #scope :only_with_ddjjs, -> { includes({:ddjjs => [:id, :ano, :persona_cargo_id ]}).where('ddjjs.id is not null')}
  scope :with_ddjjs, -> { includes(:persona_cargos => [:cargo,
                                                      {:ddjjs => :biens }
                                                      # ]).where('ddjjs.id is not null').order('personas.apellido', 'ddjjs.ano DESC')}
                                                      # ]).where('ddjjs.id is not null').where("ddjjs.status = ?", true).order('ddjjs.ano DESC')}
                                                      # ]).where('ddjjs.id is not null').where("ddjjs.status = ?", 1)}
                                                      ]).where("ddjjs.status = ? AND ddjjs.id is not null", 1)}

  scope :all_people, -> { includes(:persona_cargos => [:cargo,
                                                    {:ddjjs => :biens }
                                                    # ]).where('ddjjs.id is not null').order('personas.apellido', 'ddjjs.ano DESC')}
                                                    # ]).where('ddjjs.id is not null').where("ddjjs.status = ?", true).order('ddjjs.ano DESC')}
                                                    # ]).where('ddjjs.id is not null').where("ddjjs.status = ?", 1)}
                                                    ]).where("personas.apellido is not null", 1).order(:apellido)}

  scope :get_personas, -> { includes({:persona_cargos => [:cargo]}, :ddjjs ).where("ddjjs.status = ? AND ddjjs.id is not null", 1).order(:apellido)}

  scope :get_personas_sin_tags, -> { includes(:ddjjs ).where("ddjjs.status = ? AND ddjjs.id is not null AND personas.tag_id is null", 1).order(:apellido)}

  def serializable_hash(options = nil)
    super({
      :only=>[:apellido, :nombre, :nacimento, :tag_id, :tag_img_id, :tag_descripcion, :ficha_d_l ],
      :methods =>[:get_tag_nacion, :url_buscador_app]
      # :include=>[:ddjjs]
    }.merge(options || {}))
  end

end

# las imagenes del buket de la nacion se forman de la siguiente manera:
# http://bucket3.clanacion.com.ar/anexos/fotos/18/1334418h167.jpg
# http://bucket3.clanacion.com.ar/anexos/fotos/{{ultimos dos numeros del img id}}/{{img id}}.jpg
# opciones de width y height:
# http://bucket3.clanacion.com.ar/anexos/fotos/{{ultimos dos numeros del img id}}/{{img id}}w{{300}}.jpg
