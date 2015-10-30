# coding: utf-8
module HomeHelper
  def get_nombre_bien tipo_bien_id
    temp = @nombre_bien.map{|x| x if x.tipo_bien_id == tipo_bien_id && x.nombre}
  end
  
  def count_result q
    cont = 0
    q.map{|p| 
        p.persona_cargos.map{|pc| 
          cont += pc.ddjjs.length
          }
      }
      cont
  end

  def map_bienes biens, nomb_bien, no_chequear_repe=nil
    # recibe array de todos los bienes de la ddjj (biens) y el titpo de bien que se quiere extraer (nomb_bien)
    # 
    # para test, en la base de PRO:
    #   ddjj/basso-lorenzo-ricardo-2009-inicial 
    #   ddjj/rivara-raúl-alberto-2011-anual

      tmp = []
      
      bienes = biens.select{|x| x.tipo_bien_s.downcase == nomb_bien.downcase } # mapea x tipo de bienes
      
      unless no_chequear_repe
        tmp = bienes.select{|x| x.bien_persona.count > 0 }.map do |bien|
          bienes_personas = [bien]

          bien.bien_persona.each do |bien_persona|
            bien_dup = bien.dup
            bien_dup.vinculo = bien_persona.vinculo
            bien_dup.origen = nil
            bien_dup.valor_fiscal = nil
            bien_dup.valor_adq = nil
            bien_dup.porcentaje = bien_persona.porcentaje
            bien_dup.titular_dominio = bien_persona.vinculo
            bienes_personas << bien_dup
          end

          bienes_personas
        end
        
        bienes_without_bienpersona = bienes.select{|x| x.bien_persona.count == 0 }
        bienes_without_bienpersona.group_by{ |x| (x.porcentaje == 100)} # agrupa si es 100% titular o no
          .each{|key, value|
            
            if key # bienes que es 100% titular
              
              value.each{|item| tmp << [item]}

            else # bienes que NO es 100% titular
              
              value.group_by{ |x| (x._hash)}.each { |k, v| # cada bien agrupado por iguales
            
                  v.group_by{| bp | bp.persona_id}.values # lo agrupo por persona id
                    .group_by {| bp | bp.length > 1 } # los agrupo por si tiene mas de un bien con el mismo id de persona
                      .each{| bp_key, bp_value|
                        
                        if bp_key #si es el mismo titular del bien ingresar como bienes separados
                              bp_value.map{|xx|
                                xx.map{|xxx| tmp << [xxx]} # ingreso como bienes separados
                            }
                        else
                          t = []
                          bp_value.map{|xx|
                             xx.map{|xxx| t << xxx} # ingreso como mismo bien
                          }

                          tmp << t

                        end
                      }
              }

            end
          }
      else # para las tablas no agrupa bienes
        
        tmp = bienes
        logger.debug tmp
      end
  
      return tmp 
  end
  
  # def map_bienes__ biens, nomb_bien, no_chequear_repe=nil # **** deprecate!!!!!!
  #     # logger.debug "*////////////////////////////////* #{ nomb_bien } ///////////////////////////////////////////////////////////////////****"
  #     data = [] # almacena los bienes a retornar
  #     bienes = biens.select{|x| x.tipo_bien_s.downcase == nomb_bien.downcase } # mapea los tipos de bienes
        
  #     repetidos = Array.new # almacena los indices que estan repetidos
  #     bienes.each_with_index do |x, i|  
  #       # if x
  #         if x.porcentaje != 100 && !no_chequear_repe # si no es 100% titular && si no pide saltear la validacion de repetidos
  #           i_repe = false 
  #           (i+1).upto(bienes.length) do |ii| # recorre los bienes desde la posicion actual para ver si hay coincidencia
  #             if bienes[ii]
  #               if bienes[ii].persona_id != x.persona_id && bienes[ii].cant_acciones == x.cant_acciones && bienes[ii].entidad == x.entidad &&  bienes[ii].localidad == x.localidad && bienes[ii].m_valor_adq_id == x.m_valor_adq_id && bienes[ii].m_valor_fiscal_id == x.m_valor_fiscal_id && bienes[ii].mejoras == x.mejoras && bienes[ii].modelo == x.modelo && bienes[ii].nombre_bien_id == x.nombre_bien_id && bienes[ii].pais == x.pais &&  bienes[ii].provincia == x.provincia && bienes[ii].ramo == x.ramo && bienes[ii].superficie == x.superficie && bienes[ii].unidad_medida_id == x.unidad_medida_id && bienes[ii].valor_adq == x.valor_adq && bienes[ii].valor_fiscal == x.valor_fiscal
  #                 # logger.debug "***** #{ bienes[ii].to_yaml }"
  #                 # logger.debug "***** #{ x.to_yaml }"
  #                 repetidos << ii # si hay coincidencia, guarda el indice en este array para luego al pasar por la posicion no ingresarlo en el front
  #                 i_repe = ii
  #               end
  #             end
  #           end
           
  #           unless repetidos.index {|j| j == i } # si la posicion actual ya fue relacionada a otro objeto retorna true 
  #             if i_repe  
  #               data << [x, bienes[i_repe]]  
  #             else  
  #               data << x 
  #             end
  #           end
  #         else
  #           data << x
  #         end
           
  #       # end          
  #     end
  #     # logger.debug "***** #{ data.to_yaml }"
      
  #     return data
  # end
  
end



