require 'xapian-fu'

SEARCH_INDEX = XapianFu::XapianDb.new(:dir => 'ddjjs.db',
                                      :language => :spanish,
                                      :store => [:persona_id, :dj_id])
