module Heredity
  module InheritableClassInstanceVariables

    MUTEX_FOR_THREAD_EXCLUSIVE = Mutex.new

    def self.included(klass)
      return if klass.respond_to?(:_inheritable_class_instance_variables)

      MUTEX_FOR_THREAD_EXCLUSIVE.synchronize do
        klass.extend(::Heredity::InheritableClassInstanceVariables::ClassMethods)

        klass.class_eval do
          @_inheritable_class_instance_variables = [ :_inheritable_class_instance_variables ]

          class << self
            alias_method :inheritable_attribute, :inheritable_attributes
            alias_method :class_inheritable_attributes, :inheritable_attributes
            alias_method :class_inheritable_attribute, :inheritable_attributes
          end
        end
      end
    end

    module ClassMethods
      def _inheritable_class_instance_variables
        @_inheritable_class_instance_variables
      end

      def inheritable_attributes(*args)
        MUTEX_FOR_THREAD_EXCLUSIVE.synchronize do
          args.flatten.compact.uniq.each do |class_instance_variable|
            unless @_inheritable_class_instance_variables.include?(class_instance_variable)
              @_inheritable_class_instance_variables << class_instance_variable
            end
          end

          @_inheritable_class_instance_variables.each do |attr_symbol|
            unless self.respond_to?("#{attr_symbol}")
              class_eval %Q{
                class << self; attr_reader :#{attr_symbol}; end
              }
            end

            unless self.respond_to?("#{attr_symbol}=")
              class_eval %Q{
                class << self; attr_writer :#{attr_symbol}; end
              }
            end
          end

          @_inheritable_class_instance_variables
        end
      end

      def inherited(klass)
        super # ActiveRecord needs the inherited hook to setup fields

        MUTEX_FOR_THREAD_EXCLUSIVE.synchronize do
          @_inheritable_class_instance_variables.each do |attribute|
            attr_sym = :"@#{attribute}"
            klass.instance_variable_set(attr_sym, self.instance_variable_get(attr_sym))
          end
        end
      end
    end
  end
end
