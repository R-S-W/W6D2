class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      name = name.to_s
      define_method(name) do 
        instance_variable_get("@"+name)
      end

      define_method("#{name}=") do |newval|
        instance_variable_set("@"+name,newval)
      end
    end
  end
end
