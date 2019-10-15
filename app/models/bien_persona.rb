# encoding: utf-8
require 'digest/md5'
class BienPersona < ActiveRecord::Base
  self.table_name = 'admin_ddjj_app_bienpersona'
  
  attr_accessible :porcentaje, :vinculo
  
  belongs_to :bien
  belongs_to :persona

end

