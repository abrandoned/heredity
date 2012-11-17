require 'spec_helper'
require 'heredity/inheritable_class_instance_variables'

describe Heredity::InheritableClassInstanceVariables do

  class TestInheritTop
    include ::Heredity::InheritableClassInstanceVariables
    inheritable_attributes :first, :awesomeness, :bestest

    @first = {}
    @awesomeness = [:this, :that, :the_other]
    @bestest = "dirt apple (Po-ta-toes!)"
  end

  class TestSecondTier < TestInheritTop; end
  class TestThirdTier < TestSecondTier; end

  class TestEditSecondTier < TestInheritTop
    @first = "Songs are for Singing"
    @awesomeness = @first * 3
    @bestest = "SSSSSOOOOOOOOOONNNNNNNNGGGGGGGSSSSSS"
  end

  class TestEditThirdTier < TestEditSecondTier
    @first = []
    @awesomeness = []
    @bestest = []
  end

  class TestEditThirdTierWithoutEdit < TestEditSecondTier; end

  # API
  [TestInheritTop, TestSecondTier, TestThirdTier].each do |test_class|
    specify { test_class.should respond_to(:inheritable_attributes) }
    specify { test_class.should respond_to(:inheritable_attribute) }
    specify { test_class.should respond_to(:class_inheritable_attributes) }
    specify { test_class.should respond_to(:class_inheritable_attribute) }
  end

  context "when inheritable class instance variables is already included" do
    it "doesn't reset inheritable attributes" do
      TestInheritTop.__send__(:include, ::Heredity::InheritableClassInstanceVariables)
      TestInheritTop.inheritable_attributes.should include :first, :awesomeness, :bestest
    end
  end

  context "when overriding child class instance variables" do
    describe "single tier inheritance" do
      it "overrides the instance variables with the child defined values" do
        TestEditSecondTier.first.should eq("Songs are for Singing")
        TestEditSecondTier.awesomeness.should eq("Songs are for Singing" * 3)
        TestEditSecondTier.bestest.should eq("SSSSSOOOOOOOOOONNNNNNNNGGGGGGGSSSSSS")
      end
    end

    describe "second tier inheritance" do
      it "overrides the instance variables with the child defined values" do
        TestEditThirdTier.first.should eq([])
        TestEditThirdTier.awesomeness.should eq([])
        TestEditThirdTier.bestest.should eq([])
      end
    end

    describe "second tier inheritance without changing first override" do
      it "keeps instance variables the same as first override" do
        TestEditThirdTierWithoutEdit.first.should eq("Songs are for Singing")
        TestEditThirdTierWithoutEdit.awesomeness.should eq("Songs are for Singing" * 3)
        TestEditThirdTierWithoutEdit.bestest.should eq("SSSSSOOOOOOOOOONNNNNNNNGGGGGGGSSSSSS")
      end
    end
  end

  context "without overriding inherited values" do
    describe "single tier inheritance" do

      it "creates public attr_readers for inherited attributes" do
        TestSecondTier.should respond_to(:first)
        TestSecondTier.should respond_to(:awesomeness)
        TestSecondTier.should respond_to(:bestest)
      end

      it "inherits the values of hashes" do
        TestSecondTier.first.should eq({})
      end

      it "inherits the values of arrays" do
        TestSecondTier.awesomeness.should eq([:this, :that, :the_other])
      end

      it "inherits the values of Objects" do
        TestSecondTier.bestest.should eq("dirt apple (Po-ta-toes!)")
      end

    end

    describe "2nd tier inheritance" do

      it "creates public attr_readers for inherited attributes" do
        TestThirdTier.should respond_to(:first)
        TestThirdTier.should respond_to(:awesomeness)
        TestThirdTier.should respond_to(:bestest)
      end

      it "inherits the values of hashes" do
        TestThirdTier.first.should eq({})
      end

      it "inherits the values of arrays" do
        TestThirdTier.awesomeness.should eq([:this, :that, :the_other])
      end

      it "inherits the values of Objects" do
        TestThirdTier.bestest.should eq("dirt apple (Po-ta-toes!)")
      end

    end
  end
end
