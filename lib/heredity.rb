require "heredity/inheritable_class_instance_variables"

require "heredity/version"

module Heredity
  def self.included(klass)
    klass.__send__(:include, ::Heredity::InheritableClassInstanceVariables)
  end
end
