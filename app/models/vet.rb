java_import org.springframework.samples.petclinic.Vet

class Vet
  include ActiveModel::Serializers::Xml
  include ActiveModel::Serializers::JSON
  include Spring

  def serializable_hash(*)
    {
      "id" => id,
      "first_name" => first_name, "last_name" => last_name,
      "specialties" => specialties.map{|s| s.name}.join(', '),
      "nr_of_specialties" => nr_of_specialties
    }
  end
  alias attributes serializable_hash

  def self.all
    clinic.getVets
  end
end
