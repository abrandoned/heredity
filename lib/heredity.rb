require "heredity/core_ext/class"
require "heredity/inheritable_class_instance_variables"

require "heredity/version"

module Heredity
  def self.included(klass)
    klass.class_eval do
      include ::Heredity::InheritableClassInstanceVariables
    end
  end
end
