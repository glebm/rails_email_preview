module RailsEmailPreview
  class PreviewListPresenter
    attr_reader :previews

    def initialize(previews)
      @previews = previews
    end

    def columns(&block)
      return to_enum(:columns) unless block_given?
      split_in_halves(groups) { |_k, v| v.length }.each do |column_groups|
        block.yield(column_groups)
      end
    end

    def groups
      @groups ||= by_class_name.inject({}) do |h, (_class_name, previews)|
        h.update previews.first.group_name => previews
      end
    end

    private

    def split_in_halves(xs, &weight)
      xs    = xs.to_a
      ws    = xs.map(&weight)
      col_w = (ws.sum + 1) / 2
      cur_w = 0
      mid   = ws.find_index { |w| (cur_w += w) >= col_w + w } || [ws.length - 1, 0].max
      [xs.first(mid), xs.from(mid)]
    end

    def by_class_name
      @by_class_name ||= previews.group_by(&:preview_class_name)
    end
  end
end
