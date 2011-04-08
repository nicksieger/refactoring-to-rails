java_import org.springframework.samples.petclinic.Owner

class Owner
  include Spring

  def self.find_by_name(name)
    clinic.findOwners(name)
  end
end
