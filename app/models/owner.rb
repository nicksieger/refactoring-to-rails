java_import org.springframework.samples.petclinic.Owner

class Owner
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include Spring

  validates_presence_of :first_name, :last_name, :address, :city, :telephone
  validates_format_of :telephone, :with => /[-0-9.+ ]+/, :message => "can only have numbers, punctuation, or spaces"

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
