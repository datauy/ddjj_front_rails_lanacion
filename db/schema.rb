# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131122184829) do

  create_table "biens", :force => true do |t|
    t.integer  "tipo_bien_id"
    t.integer  "nombre_bien_id"
    t.string   "tipo_bien_s"
    t.string   "nombre_bien_s"
    t.string   "descripcion"
    t.string   "direccion"
    t.string   "barrio"
    t.string   "localidad"
    t.string   "provincia"
    t.string   "pais"
    t.integer  "modelo"
    t.string   "entidad"
    t.string   "ramo"
    t.string   "cant_acciones"
    t.date     "fecha_desde"
    t.string   "destino"
    t.string   "origen"
    t.decimal  "superficie",        :precision => 10, :scale => 2
    t.integer  "unidad_medida_id"
    t.integer  "m_mejoras_id"
    t.decimal  "mejoras",           :precision => 15, :scale => 2
    t.integer  "m_valor_fiscal_id"
    t.decimal  "valor_fiscal",      :precision => 15, :scale => 2
    t.integer  "m_valor_adq_id"
    t.decimal  "valor_adq",         :precision => 15, :scale => 2
    t.date     "fecha_hasta"
    t.string   "titular_dominio"
    t.decimal  "porcentaje",        :precision => 10, :scale => 2
    t.string   "vinculo"
    t.string   "periodo"
    t.string   "obs"
    t.integer  "persona_id"
    t.integer  "ddjj_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "buscadors", :force => true do |t|
    t.integer  "poder"
    t.text     "nombre_bienes"
    t.text     "personas"
    t.text     "cargos"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "cargos", :force => true do |t|
    t.string   "jurisdiccion"
    t.string   "cargo"
    t.integer  "poder_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "contenido_ddjjs", :force => true do |t|
    t.integer  "ddjj_id"
    t.string   "ddjj_ano"
    t.string   "ddjj_tipo"
    t.integer  "poder_id"
    t.string   "persona_str"
    t.integer  "persona_id"
    t.string   "cargo_str"
    t.integer  "cargo_id"
    t.text     "contenido"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "contenido_ddjjs", ["ddjj_id", "contenido"], :name => "index_contenido_ddjjs_on_ddjj_id_and_contenido", :length => {"ddjj_id"=>nil, "contenido"=>5}

  create_table "ddjjs", :force => true do |t|
    t.integer  "ano"
    t.integer  "tipo_ddjj_id"
    t.string   "funcionario"
    t.string   "url"
    t.integer  "persona_cargo_id"
    t.integer  "persona_id"
    t.integer  "key"
    t.integer  "poder_id"
    t.string   "clave"
    t.boolean  "flag_presenta"
    t.text     "obs"
    t.string   "flag_search"
    t.decimal  "visitas",          :precision => 10, :scale => 0
    t.boolean  "status"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "dj_vista", :force => true do |t|
    t.integer  "ddjj_id"
    t.decimal  "visitas",    :precision => 10, :scale => 0
    t.date     "fecha"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "jurisdiccions", :force => true do |t|
    t.string   "nombre"
    t.integer  "poder_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "nombre_biens", :force => true do |t|
    t.string   "nombre"
    t.integer  "tipo_bien_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "persona_cargos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "cargo_id"
    t.integer  "jurisdiccion_id"
    t.integer  "flag_ingreso"
    t.date     "ingreso"
    t.date     "egreso"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "personas", :force => true do |t|
    t.string   "apellido"
    t.string   "nombre"
    t.string   "legajo"
    t.integer  "tipo_documento_id"
    t.integer  "documento"
    t.string   "cuit_cuil"
    t.date     "nacimento"
    t.integer  "sexo_id"
    t.integer  "estado_civil_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "tag_id"
    t.string   "tag_img_id"
    t.string   "tag_descripcion"
    t.string   "ficha_d_l"
  end

  create_table "tiempo_controls", :force => true do |t|
    t.string   "dias"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tipo_biens", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "vinculos", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
