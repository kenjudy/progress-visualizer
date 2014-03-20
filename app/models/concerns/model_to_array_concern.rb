module ModelToArrayConcern

  def to_array
    arr = self.class.array_attributes.map{ |attr| self.send(attr.to_sym)}
  end

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
   def array_attributes
     attribute_names
   end
  end

end