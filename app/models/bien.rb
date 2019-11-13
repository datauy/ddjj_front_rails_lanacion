# encoding: utf-8
require 'digest/md5'
class Bien < ActiveRecord::Base
  attr_accessible :barrio, :cant_acciones, :descripcion, :destino, :direccion, :entidad, :fecha_desde, :fecha_hasta, :localidad, :m_mejoras_id, :m_valor_adq_id, :m_valor_fiscal_id, :mejoras, :modelo, :nombre_bien_id, :nombre_bien_s, :obs, :origen, :pais, :periodo, :persona_id, :porcentaje, :provincia, :ramo, :superficie, :tipo_bien_id, :tipo_bien_s, :titular_dominio, :unidad_medida_id, :valor_adq, :valor_fiscal, :ddjj_id, :vinculo

  belongs_to :tipo_bien
  belongs_to :nombre_bien
  belongs_to :ddjj
  belongs_to :persona
  has_many :bien_persona


  UNIDAD_MEDIDA = ["m2", "ha"].freeze
  TIPO_MONEDA = ["$", "$", "us$", "EUR", "COP", "Q", "$ Uruguayos", "£", "A"].freeze
  CURRENCY = ["ARS", "ARS", "USD", "EUR", "COP", "GTQ", "UYU", "£", "A"].freeze
  CURRENCY2USD = {
    1 => [29.27, 17.227, 15.359, 9.617, 8.448, 5.704],
    3 => [0.8495, 0.8495, 0.8495, 0.8495, 0.8495, 0.8495],
    4 => [2977, 3145, 3145, 3145, 3145, 3145],
    5 => [7.54, 7.54, 7.54, 7.54, 7.54, 5.704],
  }.freeze

  def valor_fiscal_usd
    if self.m_valor_fiscal_id == 2 || self.m_valor_fiscal_id > 5
      self.valor_fiscal
    else
      # 0 es 2018,...
      (self.valor_fiscal/CURRENCY2USD[self.m_valor_fiscal_id][0]).round(0)
    end
  end

  def u_medida
    if self.unidad_medida_id
      UNIDAD_MEDIDA[self.unidad_medida_id]
    end
  end

  def moneda id
    # recibe 1,2 ó 3. m_mejoras_id / m_valor_fiscal_id / m_valor_adq_id respectivamente
    if id
      if id == 1
        moneda_id = self.m_mejoras_id
        moneda_id = nil unless self.mejoras
      end
      if id == 2
        moneda_id = self.m_valor_fiscal_id
        moneda_id = nil unless self.valor_fiscal
      end
      if id == 3
        moneda_id = self.m_valor_adq_id
        moneda_id = nil unless self.valor_adq
      end

      TIPO_MONEDA[moneda_id] if moneda_id  else "no declara"
    end
  end

  def get_currency
    CURRENCY[self.m_valor_fiscal_id]
  end
  def get_moneda type
    moneda = false
    if type == "fiscal" && self.m_valor_fiscal_id
      moneda =TIPO_MONEDA[self.m_valor_fiscal_id]
    end
    if type == "adqisicion" && self.m_valor_adq_id
      moneda =TIPO_MONEDA[self.m_valor_adq_id]
    end
    if type == "mejoras" && self.m_mejoras_id
      moneda =TIPO_MONEDA[self.m_mejoras_id]
    end
    moneda ? moneda : ""
  end

  def monedas
    monedas =  {:valor_fiscal => get_moneda("fiscal"), :valor_adq=> get_moneda("adqisicion"), :mejoras=> get_moneda("mejoras") }
  end

  def css_class_name
    if self.nombre_bien_s
      self.nombre_bien_s.strip.gsub(" ", "_").downcase
    else
      "WARNING_css_class_name"
    end
  end

  def css_moneda_class_name
    str = "moneda_" + self.m_valor_fiscal_id.to_s
  end

  def as_json(options={})
    super( :except =>  [:updated_at, :created_at], :methods => [:monedas, :u_medida])
  end

  def serializable_hash(options = nil)
    super({
      :except =>  [:id, :ddjj_id, :updated_at, :created_at, :direccion, :m_mejoras_id, :m_valor_adq_id, :m_valor_fiscal_id, :nombre_bien_id, :persona_id, :tipo_bien_id],
      :methods => [:monedas, :u_medida],
      :include=>[]
    }.merge(options || {}))
  end

  def _hash
    (self.cant_acciones.to_s + self.entidad.to_s + self.localidad.to_s + self.m_valor_adq_id.to_s + self.m_valor_fiscal_id.to_s + self.mejoras.to_s + self.modelo.to_s + self.nombre_bien_id.to_s + self.pais.to_s + self.provincia.to_s + self.ramo.to_s + self.superficie.to_s + self.unidad_medida_id.to_s + self.valor_adq.to_s + self.valor_fiscal.to_s).strip
    # Digest::MD5.hexdigest(Marshal::dump(self))
  end
end
