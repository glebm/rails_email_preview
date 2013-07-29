module RailsEmailPreview::EmailsHelper
  def format_header(value)
    if value.is_a?(Array)
      value.map(&:to_s) * ', '
    else
      value.to_s
    end
  end

  def email_methods(m)
    m.constantize.instance_methods(false).map(&:to_s).sort
  end

  def split_in_halves(elements, &weight)
    tot_w = elements.map(&weight).sum
    cols = [elements.dup, []]
    col2_w = 0
    cols[0].reverse_each do |cl|
      n = weight.call(cl)
      break if col2_w + n > tot_w / 2
      col2_w += n
      cols[1] << cols[0].pop
    end
    cols[1].reverse!
    cols
  end
end
