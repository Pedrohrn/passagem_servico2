# coding: utf-8
# nodoc
module ObjectHelpers

  module ClassMethods
    def set(*opts)
      opts = opts.extract_options!
      cattr_accessor(*opts.keys)
      opts.each { |attr, value| send("#{attr}=", value) }
    end
  end

  module InstanceMethods
  end

  module ClassAndInstanceMethods

    def params_to_hash(val)
      # angular envia params por GET em string invés de HASH
      # aqui convertemos se necessário e fazemos recursive_symbolize
      json_parse = lambda { |item|
        return item unless item.is_a?(::String) && (item.is_hash? || item.is_array?)
        JSON.parse(item)
      }

      resp = val
      if resp.is_a?(::String) && (resp.is_hash? || resp.is_array?)
        resp = json_parse.call(resp)
      elsif resp.is_a?(Hash)
        resp = resp.deep_transform_values(&json_parse)
      elsif resp.is_a?(Array)
        resp.map!{ |item| params_to_hash(item) }
      end

      resp.is_a?(Hash) ? resp.deep_symbolize_keys : resp
    end

  end

end

Object.send :include, ObjectHelpers::ClassAndInstanceMethods
Object.send :extend,  ObjectHelpers::ClassAndInstanceMethods

Object.send :extend,  ObjectHelpers::ClassMethods
Object.send :include, ObjectHelpers::InstanceMethods