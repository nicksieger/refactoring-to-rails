java_import org.springframework.samples.petclinic.Pet

class Pet
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include Spring

  Owner; Visit ; PetType # dev-mode: ensure child models are decorated

  def birth_date
    getBirthDate && getBirthDate.to_date
  end

  def birth_date=(date)
    setBirthDate java.util.Date.from_date(date)
  end

  def type=(t)
    setType PetType === t ? t : PetType.load(t.to_i)
  end

  def self.load(id)
    clinic.loadPet(id.to_i)
  end

  def save
    clinic.storePet(self)
  end

  def destroy
    clinic.deletePet(id)
  end
end
