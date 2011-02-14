module ApplicationHelper
  def error_for(object, field)
    error_tag object.errors[field]
  end

  def error_tag(content)
    content_tag 'span', :class => 'errors' do
      content
    end
  end
end
