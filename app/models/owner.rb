java_import org.springframework.samples.petclinic.Owner

class Owner
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include Spring

  validates_presence_of :first_name, :last_name, :address, :city, :telephone
  validates_format_of :telephone, :with => /[-0-9. ]+/, :message => "Only numbers, dash, dot (.), or spaces allowed"

  p _validators

  def self.find_by_name(name)
    clinic.findOwners(name)
  end

  def self.load(id)
    clinic.loadOwner(id.to_i)
  end

  def save
    clinic.storeOwner(self)
  end
end
