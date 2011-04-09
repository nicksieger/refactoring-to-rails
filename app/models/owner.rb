java_import org.springframework.samples.petclinic.Owner

class Owner
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include Spring

  def self.find_by_name(name)
    clinic.findOwners(name)
  end

  def self.load(id)
    clinic.loadOwner(id.to_i)
  end
end
