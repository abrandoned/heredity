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
end