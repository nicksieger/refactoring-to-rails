module VetMethods
  module ClassMethods
    def all
      clinic.getVets
    end

    def model_name
      ActiveSupport::ModelName.new("vet")
    end

    def find(id)
      session_factory.with_session { |s| s.load(Vet, id.to_i.to_java(:int)) }
    end
  end

  module InstanceMethods
    def initialize(*args)
      super()
      assign_attributes(args.extract_options!)
    end

    def to_param
      get_id.to_s
    end

    def new_record?
      isNew
    end

    def errors
      []
    end

    def save
      session_factory.transaction do |session|
        if get_id.nil?
          session.save(self)
        else
          session.merge(self)
        end
      end
    end

    def update_attributes(hash)
      assign_attributes(hash)
      session_factory.transaction do |session|
        session.merge(self)
      end
    end

    def destroy
      session_factory.transaction do |session|
        session.delete(self)
      end
    end

    private
    def assign_attributes(hash)
      hash.each do |k,v|
        send("#{k}=", v)
      end
    end
  end
end

class org::springframework::samples::petclinic::Vet
  include Spring
  include VetMethods::InstanceMethods
  extend VetMethods::ClassMethods
end

Vet = org::springframework::samples::petclinic::Vet
