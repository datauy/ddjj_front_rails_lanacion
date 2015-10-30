require 'open-uri'
require 'json'
class Ddjj < ActiveRecord::Base
  attr_accessible :ano, :funcionario, :persona_cargo_id, :tipo_ddjj_id, :url, :persona_id, :key, :clave, :flag_presenta, :obs, :flag_search, :visitas, :status, :poder_id
  # :status - indica si fue o no revisada
  belongs_to :persona
  belongs_to :persona_cargo
  has_many :biens
  has_many :dj_visitas

  # ddjj :dependent => :destroy
  TIPO_DDJJ = ["alta", "baja", "inicial", "anual"].freeze
  
  def otras_ddjjs
    # Ddjj.where("persona_id" => self.persona_id).where("id != ?", self.id ).order("ano desc")
    self.persona.ddjjs.where("id != ?", self.id ).order("ano desc")
  end
  
  def tipo_ddjj
    if self.tipo_ddjj_id
      TIPO_DDJJ[self.tipo_ddjj_id]
    end
  end
  
  def tipo_ddjj_short
    short = ""
    if self.tipo_ddjj_id
      case self.tipo_ddjj_id
      when 0 # alta
          short = self.ano.to_s + "-A"      
        when 1 #baja
          short = self.ano.to_s + "-B"      
        when 2 # inicial
          short = self.ano.to_s + "-I"      
        when 3 # anual
          short = self.ano.to_s
      end
      # TIPO_DDJJ[self.tipo_ddjj_id]
    end
    short
  end
  
  def get_imgs_of_documentcloud # devuelve las imagenes de documentcloud
    images= Array.new
    if self.url      
      cloud_object = JSON.parse(open(self.url.gsub("html", "json")).read)
      if cloud_object["pages"]
        cloud_object["pages"].times do | i |
          url = cloud_object["resources"]["page"]["image"].gsub("{size}", "normal")
          images << url.gsub("{page}", (i + 1).to_s)
        end
      end
    end
    images
  end
  
  def get_pdf_of_documentcloud # devuelve las imagenes de documentcloud
    images= Array.new
    if self.url      
      cloud_object = JSON.parse(open(self.url.gsub("html", "json")).read)
      url_pdf = cloud_object["resources"]["pdf"]
      # if cloud_object["pages"]
        # cloud_object["pages"].times do | i |
          # images << url.gsub("{page}", (i + 1).to_s)
        # end
      # end
    end
    url_pdf
  end
  
  def serializable_hash(options = nil)
    super({
      :only=>[:ano, :url],
      :methods =>[:tipo_ddjj],
      :include=>[ :persona_cargo, :biens, :persona]
    }.merge(options || {}))
  end

  def self.as_csv
    # CSV.generate do |csv|
    #   csv << "pepe"
    #   # all.each do |item|
    #   #   csv << item.attributes.values_at(*column_names)
    #   # end
    # end
  end

end
