java_import org.springframework.samples.petclinic.PetType

class PetType
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include Spring

  def self.load(id)
    clinic.getPetTypes.detect {|pt| pt.id == id.to_i }
  end
end
