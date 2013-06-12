module RailsEmailPreview::EmailsHelper
  def format_header(value)
    if value.is_a?(Array)
      value.map(&:to_s) * ', '
    else
      value.to_s
    end
  end
end
