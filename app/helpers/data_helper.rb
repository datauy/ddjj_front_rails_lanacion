# encoding: utf-8
module DataHelper
  # Cargo::PODER = ["Ejecutivo", "Legislativo", "Judicial"] 
  def get_indice arr, str #
    if (str) 
      r = arr.index { |x| x.downcase == str.strip.to_s.downcase }
    end
    r ? r : nil
  end
  
  def get_ddjj l, p
    ###### LOGER ###########
      # logger.debug "*****Linea #{ l }"
      # logger.debug @dj.to_yaml
      # logger.debug @oo.row(l).to_yaml
    ###### LOGER ###########
    # logger.debug "*****persona #{ p.to_yaml }"
    ano =  Integer @oo.cell(l,@dj[:ano])
    dj_tipo = @oo.cell(l,@dj[:tipo_ddjj]).strip
    funcionario = @oo.cell(l,@dj[:funcionario])
    url = @oo.cell(l,@dj[:url])
    clave = @oo.cell(l,@dj[:clave]) ############################# ver la clave como va a ser por el tema de los tags de lanacion
    vinculo_con_quien = @oo.cell(l,@dj[:vinculo_con_quien])
    
    
    #validar si es titular de la ddjj
    if vinculo_con_quien
      clave = vinculo_con_quien
    end
      # validar si la key es distinta borrar todos los bienes.
    unless ddjj = Ddjj.where("clave=?", clave).first
      ddjj = Ddjj.new(
      ano: ano,
      tipo_ddjj_id: (get_indice Ddjj::TIPO_DDJJ, dj_tipo),
      funcionario: funcionario,
      url: url,
      clave: clave,
      key: @key,
      poder_id: @poder,
      status: @status ? true : false
      )
      
      ddjj.persona = p
      ddjj.flag_presenta = true
      
      if @oo.cell(l, @dj[:tipo_bien]).strip.downcase == "Aclaración".downcase
        ddjj.flag_presenta = false 
        ddjj.obs = @oo.cell(l, @dj[:obs])
      else
        # ddjj.flag_presenta = true
      end
      # para las busquedas
      identificador = p.apellido.gsub(" ", "-") 
      identificador += "-" + p.nombre.gsub(" ", "-") 
      identificador += "-" + ddjj.ano.to_s + "-" + dj_tipo
      ddjj.flag_search = identificador.downcase
      
      ddjj.save
    end
      
    if ddjj.key != @key
      begin
        ddjj.biens.destroy_all
        # ddjj.persona_cargo.destroy
        # logger.debug "**NOERROR*** #{ddjj.to_yaml}"    
      rescue Exception=>e
       logger.debug "**ERROR***: #{ e } #{ddjj.to_yaml}"    
      end      
      ddjj.update_attributes( :key => @key, :status =>(@status ? true : false), :url=> url, :poder_id=> @poder, :persona_cargo_id => nil)
      # logger.debug "**REESCRIBIENDO DDJJ ***Linea #{ l } #{ddjj.to_yaml}"
      # $stderr.puts "**REESCRIBIENDO DDJJ ***Linea #{ l } #{ddjj.to_yaml}"
    end
      
    if @oo.cell(l, @dj[:tipo_bien])
      if @oo.cell(l, @dj[:tipo_bien]).strip.downcase == "Observación".downcase
        ddjj.obs = @oo.cell(l, @dj[:obs])
        ddjj.save
      end
    else
       logger.debug "**ERROR***Linea #{ l } en la ddjj"
    end
    
    ddjj
  end
  
  def get_persona l
    if @poder == 0 # legislativo
      q = "nombre=? AND apellido=? AND documento=?", @oo.cell(l,@dj[:nombre]).strip, @oo.cell(l,@dj[:apellido]).strip, @oo.cell(l,@dj[:documento])
    else # legislativo o judicia
      q = "nombre=? AND apellido=?", @oo.cell(l,@dj[:nombre]).strip, @oo.cell(l,@dj[:apellido]).strip
    end
    
    unless p = Persona.where(q).first
      p = Persona.new( 
        nombre: @oo.cell(l,@dj[:nombre]).strip,
        apellido: @oo.cell(l,@dj[:apellido]).strip,
        cuit_cuil: @oo.cell(l,@dj[:cuit_cuil]),
        documento: @oo.cell(l,@dj[:documento]),
        estado_civil_id: (get_indice Persona::ESTADO_CIVIL, @oo.cell(l,@dj[:estado_civil])),
        legajo: @oo.cell(l,@dj[:legajo]),
        nacimento:@oo.cell(l,@dj[:nacimiento]),
        sexo_id: (get_indice Persona::SEXO, @oo.cell(l,@dj[:sexo])),
        tipo_documento_id: (get_indice Persona::TIPO_DOCUMENTO, @oo.cell(l,@dj[:tipo_documento]))
        # vinculo_id: (get_indice Persona::VINCULO, @oo.cell(l,@dj[:vinculo]))
      )
      p.save      
    end
    p
  end
  
  def get_cargo l, p, ddjj #, actualizar=false
    
    if @oo.cell(l,@dj[:cargo]) # && @oo.cell(l,@dj[:jurisdiccion])
      # unless c = Cargo.where("cargo=? AND jurisdiccion=? AND poder_id=?", @oo.cell(l,@dj[:cargo]).strip, @oo.cell(l,@dj[:jurisdiccion]).strip, @poder ).first
      unless c = Cargo.where("cargo=?", @oo.cell(l,@dj[:cargo])).first
        c = Cargo.new(
          cargo: @oo.cell(l,@dj[:cargo])
          # jurisdiccion: @oo.cell(l,@dj[:jurisdiccion]).strip,
          # poder_id: @poder
        )
        if p.id == ddjj.persona.id
          c.poder_id =  @poder
        end
        c.save
      end
      jur = @oo.cell(l,@dj[:jurisdiccion]) ? @oo.cell(l,@dj[:jurisdiccion]).strip : nil #la jurisdiccion puede ser nula
      if jur
        unless j = Jurisdiccion.where("nombre=?", jur ).first
          j = Jurisdiccion.new(
            nombre: jur,
            # jurisdiccion: @oo.cell(l,@dj[:jurisdiccion]).strip,
            poder_id: @poder
          )
          j.save
        end
      else
        j = jur
      end

      unless p_c = PersonaCargo.where("persona_id=? AND cargo_id=?", p, c).first
        p_c = PersonaCargo.new(persona_id:p.id, cargo_id: c.id, ingreso: @oo.cell(l,@dj[:ingreso_apn]))
        p_c.jurisdiccion_id = j.id if j
        # if @oo.cell(l,@dj[:ingreso_apn]).year
          # p_c.flag_ingreso = @oo.cell(l,@dj[:ingreso_apn]).year if @oo.cell(l,@dj[:ingreso_apn])
        # end
        p_c.save
      end
      
      unless ddjj.persona_cargo
        c.update_attributes(:poder_id => @poder) ## actualiza el poder del cargo
        ddjj.update_attributes(:persona_cargo_id => p_c.id)
        # logger.debug "#{l} actualizó persona_cargo = #{p_c.id.to_s}"
        # $stderr.puts "#{l} actualizó persona_cargo = #{p_c.id.to_s}"
      end

      p_c
    end
  end
  
  def get_bien l, p, ddjj
    # logger.debug "#{ l }"
    # logger.debug "#{ p }"
    # logger.debug "#{ ddjj }"
    
    if @oo.cell(l, @dj[:tipo_bien])
      if ddjj.flag_presenta && (@oo.cell(l, @dj[:tipo_bien]).strip != "Observación".strip) # si presento ddjj y si no es una observación de la ddjj, busca el bien
        
         # logger.debug "*****get_bien LINEA " +  (l ? l.to_s : "") 
         t_b = @oo.cell(l, @dj[:tipo_bien]) ? @oo.cell(l, @dj[:tipo_bien]).strip : @oo.cell(l, @dj[:tipo_bien])
         unless tipo_bien = TipoBien.where("nombre=?", t_b).first 
          tipo_bien = TipoBien.new(nombre: t_b)
          tipo_bien.save
         end
         
         n_b = @oo.cell(l, @dj[:nombre_bien]) ? @oo.cell(l, @dj[:nombre_bien]).strip : @oo.cell(l, @dj[:nombre_bien])
         unless nombre_bien = NombreBien.where("nombre=?", n_b).first
          nombre_bien = NombreBien.new(nombre: n_b)
          nombre_bien.tipo_bien_id = tipo_bien.id
          nombre_bien.save
         end
         
         b = Bien.new( # comun para todos los poderes
           :ddjj_id => ddjj.id,
           :persona_id => p.id,
           :tipo_bien_id => tipo_bien.id,
           :nombre_bien_id => nombre_bien.id,
           :tipo_bien_s => tipo_bien.nombre,
           :nombre_bien_s => nombre_bien.nombre,
           :descripcion => @oo.cell(l, @dj[:descripcion]),
           :barrio => @oo.cell(l, @dj[:barrio]),
           :localidad => @oo.cell(l, @dj[:localidad]),
           :provincia => @oo.cell(l, @dj[:provincia]),
           :pais => @oo.cell(l, @dj[:pais]),
           :modelo => @oo.cell(l, @dj[:modelo]),
           :ramo => @oo.cell(l, @dj[:ramo]),
           :cant_acciones => @oo.cell(l, @dj[:cant_acciones]),
           :fecha_desde => @oo.cell(l, @dj[:fecha_desde]),
           :origen => @oo.cell(l, @dj[:origen]),
           :superficie => @oo.cell(l, @dj[:superficie]),
           :unidad_medida_id => (get_indice Bien::UNIDAD_MEDIDA, @oo.cell(l, @dj[:unidad_medida])),
           :m_mejoras_id => (get_indice Bien::TIPO_MONEDA, @oo.cell(l, @dj[:m_mejoras])), 
           :mejoras => @oo.cell(l, @dj[:mejoras]),
           :m_valor_fiscal_id => (get_indice Bien::TIPO_MONEDA, @oo.cell(l, @dj[:m_valor_fiscal])),
           :valor_fiscal => @oo.cell(l, @dj[:valor_fiscal]),
           :m_valor_adq_id => (get_indice Bien::TIPO_MONEDA, @oo.cell(l, @dj[:m_valor_adq])),
           :valor_adq => @oo.cell(l, @dj[:valor_adq]),
           :fecha_hasta => @oo.cell(l, @dj[:fecha_hasta]),
           :porcentaje => @oo.cell(l, @dj[:porcentaje]),
           # :obs => @oo.cell(l, @dj[:obs]),
           :vinculo => ddjj.persona.id == p.id ? "Titular" : @oo.cell(l, @dj[:vinculo]), 
           :titular_dominio => @oo.cell(l, @dj[:titular_dominio])
         )
         
         if @poder == 0 || @poder == 2
           b.entidad = @oo.cell(l, @dj[:entidad]) 
         end
         # validar las observaciones
          #las obs solo se guardarán en pre.
         if @poder == 0 || @poder == 1 
           if Rails.env == "pre"
              b.obs = @oo.cell(l, @dj[:obs])
           else
              b.obs = nil
           end
         else
           b.obs = @oo.cell(l, @dj[:obs])
         end
         
         # /validar las observaciones
         
         if @poder == 1
           b.destino = @oo.cell(l, @dj[:destino])
         end
  
           # :direccion => "",
           # :periodo => "",
         b.save
         b
      end         
    end         
  end
  

  
end
