java_import org.springframework.samples.petclinic.Visit

class Visit
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include Spring

  def date
    getDate.to_date
  end

  def date=(date)
    setDate java.util.Date.from_date(date)
  end

  def save
    clinic.storeVisit(self)
  end
end
