module ActiveRecord::AttrHidden
  
  def self.included(base)
    
    base.instance_variable_set("@hidden_attributes", [])
    
    class << base
      
      #
      # Hide any number of attributes in a model.
      # This is expecially useful for Single Table Inheritance.
      #
      # Subclasses of the model in which attr_hidden is called will
      # hide the attributes too (which is a desiderable behaviour in an
      # object hierarchy), and can hide further attributes.
      #
      # usage:
      #
      # attr_hidden :attr1, :attr2, ...
      #
      def attr_hidden(*attrs)
        @hidden_attributes += attrs.map(&:to_s)
      end
      
      #
      # If you want to show attributes in a subclass and you have hidden
      # them in its superclass, you can unhide it using:
      #
      # attr_not_hidden :attr1, :attr2, ...
      #
      def attr_not_hidden(*attrs)
        @hidden_attributes -= attrs.map(&:to_s)
      end
      
      # list of attribute hidden in a model
      attr_reader :hidden_attributes
      
      def columns_with_attr_hidden
        columns_without_attr_hidden.delete_if{|c|@hidden_attributes.include?(c.name)}
      end
      alias_method_chain :columns, :attr_hidden
      
      private
      
      def instantiate_with_attr_hidden(record)
        instantiate_without_attr_hidden(record.delete_if{|k,v|@hidden_attributes.include?(k)})
      end
      alias_method_chain :instantiate, :attr_hidden
      
      # allow subclasses to inherit the attr_hidden of their superclass
      def inherited_with_attr_hidden(subclass)
        subclass.instance_variable_set("@hidden_attributes", @hidden_attributes)
      end
      alias_method_chain :inherited, :attr_hidden
      
    end
    
  end
  
end

