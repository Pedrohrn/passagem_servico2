# coding: utf-8
class Hash

  def deep_transform_values
    # {a: 1, b: {x: :hello, z: [1, 2, :bye, {go: :now}]}}.deep_transform_values { |v| v.to_s }
    return enum_for(:deep_transform_values) { size } unless block_given?
    return {} if empty?
    result = {}
    each do |k, v|
      result[k] = if v.is_a?(::Hash) || v.is_a?(::Array)
                    v.deep_transform_values{ |_v| yield(_v) }
                  else
                    yield(v)
                  end
    end
    result
  end

end