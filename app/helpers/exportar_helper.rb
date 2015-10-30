module ExportarHelper
 def exportar_csv q #recibe array de ddjjs
      CSV.generate do |csv|
        # con obs
        # csv << ["ano", "tipo-ddjj", "url", "poder",  "apellido", "nombre", "nacimento", "egreso", "ingreso", "cargo", "jurisdiccion", "barrio", "cant-acciones",
        # "descripcion", "destino", "entidad", "fecha-desde", "fecha-hasta", "localidad", "modelo", "nombre-bien-s", "obs", "origen", "pais", "periodo", "porcentaje",
        # "provincia", "ramo", "superficie", "unidad-medida-id", "tipo-bien-s", "titular-dominio", "moneda-mejoras", "mejoras", "moneda-valor-adq", "valor-adq", "moneda-valor-fiscal", "valor-fiscal", 
        # "u-medida", "vinculo"]

        # SIN con obs
        csv << ["ddjj_id", "ano", "tipo_ddjj", "url_document_cloud", "poder",  "persona_dni",  "persona_id","nombre", "nacimento", "egreso", "ingreso", "cargo", "jurisdiccion", "barrio", "cant_acciones",
        "descripcion_del_bien", "destino", "entidad", "fecha_desde_cargo", "fecha_hasta_cargo", "localidad", "modelo", "nombre_bien_s", "origen", "pais", "periodo", "porcentaje",
        "provincia", "ramo", "superficie", "unidad_medida_id", "tipo_bien_s", "titular_dominio", "moneda_mejoras", "mejoras", "moneda_valor_adq", "valor_adq", "moneda_valor_fiscal", "valor_fiscal", 
        "u_medida", "vinculo"]
        q.each do |x| 
          x.biens.each do |b|
            if x.persona_cargo
                tmp = []
                tmp << x.id
                tmp << x.ano
                tmp << x.tipo_ddjj
                tmp << x.url
                tmp << x.persona_cargo.cargo.poder
                tmp << x.persona.documento
                tmp << x.persona.id
                tmp << "#{x.persona.apellido} , #{x.persona.nombre}"
                tmp << x.persona.nacimento
                tmp << x.persona_cargo.egreso
                tmp << x.persona_cargo.ingreso
                tmp << x.persona_cargo.cargo.cargo
                tmp << (x.persona_cargo.jurisdiccion ? x.persona_cargo.jurisdiccion.nombre : "")
                tmp << b.barrio
                tmp << b.cant_acciones
                tmp << b.descripcion
                tmp << b.destino
                tmp << b.entidad
                tmp << b.fecha_desde
                tmp << b.fecha_hasta
                tmp << b.localidad
                tmp << b.modelo
                tmp << b.nombre_bien_s
                # tmp << b.obs
                tmp << b.origen
                tmp << b.pais
                tmp << b.periodo
                tmp << b.porcentaje
                tmp << b.provincia
                tmp << b.ramo
                tmp << b.superficie
                tmp << b.unidad_medida_id
                tmp << b.tipo_bien_s
                tmp << b.titular_dominio
                tmp << (b.get_moneda "mejoras")
                tmp << b.mejoras
                tmp <<( b.get_moneda "adqisicion")
                tmp << b.valor_adq
                tmp << (b.get_moneda "fiscal")
                tmp << b.valor_fiscal
                tmp << b.u_medida
                tmp << b.vinculo
                # return bien
                csv << tmp
            else
                logger.debug "Error al exportar: #{x.flag_search}"      
            end
          end

        end      
      end
    end
 end
