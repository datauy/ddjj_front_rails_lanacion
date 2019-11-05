Ddjj2::Application.routes.draw do

  get "tags_personas/index"

  get "ddjj/index"

  get "ddjj/show"

  get "tareas/get_ganalytics"

  match "index" => "home#index"
  match "search" => "home#search"

  match "comparador/index"
  match "ddjj2compare/:id" => "comparador#ddjj2compare"
  match "personas/ddjj" => "comparador#get_personas_ddjj"
  match "get_ddjj/:id" => "comparador#get_ddjj"
  match "currency-exchange" => "comparador#currency_transformation"

  match "ddjj/:id" => "home#get_ddjj"
  match "filtros/:id" => "home#get_filtros"
  match "data_bienes" => "home#data_bienes"
  match "data_personas" => "home#data_personas"
  match "descargar_poder/:id" => "home#descargar_poder"
  match "personas" => "home#lista_personas"

  match "data/save" => "data#save", :as=> :gurdar
  get "data/load"
  get "data/reset_bd"
  get "data/correr_xapian"
  get "data/dump_db"
  get "data/gen_str_buscador"
  # get "data/get_ganalytics"

  get "tareas/get_ganalytics"
  get "tareas/borrar_cache"
  get "tareas/crear_csv_poderes" => "tareas#crear_csv_poderes"
  get "tareas/load_dnis" => "tareas#load_dnis" # guarda dnis para personas desde un csv
  # get "tareas/lista_personas"


  ## ADMIN***
  get "admin" => "admin#index"
  match "admin/declaraciones_juradas/:poder" => "admin#declaraciones_juradas"
  match "admin/:id" => "admin#ddjj"

  resources :ddjjs
  match "ddjjs/:id" => "ddjjs#update"

  resources :tiempo_controls
  match "tiempo_controls/:id" => "tiempo_controls#update"

  # tags personas
  get "tags_personas/index"
  get "tags_personas/save_tags"
  get "tags_personas/personas_sin_tags"


  root :to => 'home#index'

end
