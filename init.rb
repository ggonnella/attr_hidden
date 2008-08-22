require "#{File.dirname(__FILE__)}/lib/active_record/attr_hidden"
ActiveRecord::Base.class_eval { include ActiveRecord::AttrHidden }
