require 'java'
class java::util::Date
  def to_date
    t = to_time
    Date.civil(t.year, t.month, t.day)
  end

  def to_time
    Time.at(time / 1000)
  end

  def self.from_date(datetime)
    java.util.Date.new(datetime.to_time.to_i * 1000)
  end
end
