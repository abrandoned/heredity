require 'spec_helper'

describe Heredity do
  class HeredityTestClass
    include Heredity
  end

  context "when included" do
    it "includes the InhertiableClassInstanceVariables module" do
      HeredityTestClass.should respond_to :inheritable_attributes
    end
  end

  describe ".on_inherit" do
    it "captures a block and eval's it when the class is inherited" do
      HeredityTestClass.on_inherit do
        def self.hello_world!
        end
      end

      class Child < HeredityTestClass
      end

      Child.should respond_to(:hello_world!)
    end
  end
end
