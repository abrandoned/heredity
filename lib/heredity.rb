require "heredity/inheritable_class_instance_variables"

require "heredity/version"

module Heredity
  def self.included(klass)
    klass.class_eval do
      extend ::Heredity::ClassMethods
      include ::Heredity::InheritableClassInstanceVariables

      class << self
        alias_method :inheritance_eval, :on_inherit
        alias_method :inherited_eval, :on_inherit
        alias_method :when_inherited, :on_inherit
      end
    end
  end

  module ClassMethods
    def _heredity_inherited_hooks
      @_heredity_inherited_hooks ||= []
    end

    def inherited(klass)
      super

      _heredity_inherited_hooks.each do |block|
        klass.class_eval(&block)
      end
    end

    def on_inherit(&block)
      _heredity_inherited_hooks << block
    end
  end
end
