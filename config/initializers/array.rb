# coding: utf-8
class Array

  def deep_symbolize_keys
    self.map{ |i|
      next i.deep_symbolize_keys if i.is_a?(::Hash)
      i.try(:to_sym)
    }
  end

  def deep_transform_values
    # [1, 2, [:x, 9, [10, :bye]]].deep_transform_values { |v| v.to_s }
    return enum_for(:deep_transform_values) { size } unless block_given?
    return [] if empty?
    map do |v|
      if v.is_a?(::Hash) || v.is_a?(::Array)
        v.deep_transform_values{ |_v| yield(_v) }
      else
        yield(v)
      end
    end
  end
end