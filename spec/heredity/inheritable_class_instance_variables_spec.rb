require 'spec_helper'

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
    specify { expect(test_class).to respond_to(:inheritable_attributes) }
    specify { expect(test_class).to respond_to(:inheritable_attribute) }
    specify { expect(test_class).to respond_to(:class_inheritable_attributes) }
    specify { expect(test_class).to respond_to(:class_inheritable_attribute) }
  end

  context "when inheritable class instance variables is already included" do
    it "doesn't reset inheritable attributes" do
      TestInheritTop.__send__(:include, ::Heredity::InheritableClassInstanceVariables)
      expect(TestInheritTop.inheritable_attributes).to include :first, :awesomeness, :bestest
    end
  end

  context "when overriding child class instance variables" do
    describe "single tier inheritance" do
      it "overrides the instance variables with the child defined values" do
        expect(TestEditSecondTier.first).to eq("Songs are for Singing")
        expect(TestEditSecondTier.awesomeness).to eq("Songs are for Singing" * 3)
        expect(TestEditSecondTier.bestest).to eq("SSSSSOOOOOOOOOONNNNNNNNGGGGGGGSSSSSS")
      end
    end

    describe "second tier inheritance" do
      it "overrides the instance variables with the child defined values" do
        expect(TestEditThirdTier.first).to eq([])
        expect(TestEditThirdTier.awesomeness).to eq([])
        expect(TestEditThirdTier.bestest).to eq([])
      end
    end

    describe "second tier inheritance without changing first override" do
      it "keeps instance variables the same as first override" do
        expect(TestEditThirdTierWithoutEdit.first).to eq("Songs are for Singing")
        expect(TestEditThirdTierWithoutEdit.awesomeness).to eq("Songs are for Singing" * 3)
        expect(TestEditThirdTierWithoutEdit.bestest).to eq("SSSSSOOOOOOOOOONNNNNNNNGGGGGGGSSSSSS")
      end
    end
  end

  context "without overriding inherited values" do
    describe "single tier inheritance" do

      it "creates public attr_readers for inherited attributes" do
        expect(TestSecondTier).to respond_to(:first)
        expect(TestSecondTier).to respond_to(:awesomeness)
        expect(TestSecondTier).to respond_to(:bestest)
      end

      it "inherits the values of hashes" do
        expect(TestSecondTier.first).to eq({})
      end

      it "inherits the values of arrays" do
        expect(TestSecondTier.awesomeness).to eq([:this, :that, :the_other])
      end

      it "inherits the values of Objects" do
        expect(TestSecondTier.bestest).to eq("dirt apple (Po-ta-toes!)")
      end

    end

    describe "2nd tier inheritance" do

      it "creates public attr_readers for inherited attributes" do
        expect(TestThirdTier).to respond_to(:first)
        expect(TestThirdTier).to respond_to(:awesomeness)
        expect(TestThirdTier).to respond_to(:bestest)
      end

      it "inherits the values of hashes" do
        expect(TestThirdTier.first).to eq({})
      end

      it "inherits the values of arrays" do
        expect(TestThirdTier.awesomeness).to eq([:this, :that, :the_other])
      end

      it "inherits the values of Objects" do
        expect(TestThirdTier.bestest).to eq("dirt apple (Po-ta-toes!)")
      end

    end
  end
end
