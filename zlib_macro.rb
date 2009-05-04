require 'zlib'

class Bar
  class << self
    def compress(*args)
      args.each do |id|
        module_eval <<-"end;"
          alias_method :__#{id.to_i}__, :#{id.to_s}
          private :__#{id.to_i}__
          def #{id.to_s}(*args, &block)
            Zlib::Deflate.deflate(__#{id.to_i}__(*args, &block), Zlib::BEST_COMPRESSION )
          end
        end;
      end
      nil # let's not return anything
    end
  end
end


class Foo < Bar
  
  def output
    ('a'..'z').to_a.join * 500
  end
  compress :output # how to put these declarations at the top?
    
end


module Compressor 
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def compress(*args)
      args.each do |id|
        module_eval <<-"end;"
          alias_method :__#{id.to_i}__, :#{id.to_s}
          private :__#{id.to_i}__
          def #{id.to_s}(*args, &block)
            ::Zlib::Deflate.deflate(__#{id.to_i}__(*args, &block), ::Zlib::BEST_COMPRESSION )
          end
        end;
      end
      nil # let's not return anything
    end
  end
end

class A
  include Compressor
end

class B < A
  
  def output
    ('a'..'z').to_a.join * 500
  end
  compress :output
end
  