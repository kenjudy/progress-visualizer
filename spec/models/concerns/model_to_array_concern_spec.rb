require 'spec_helper'

describe ModelToArrayConcern, :type => :model do

  class TestModel
    include ModelToArrayConcern

    attr_accessor :attrib1, :attrib2
    
    def initialize(attrib1, attrib2)
      @attrib1 = attrib1
      @attrib2 = attrib2
    end
    
    def self.attribute_names
      %w(attrib1 attrib2)
    end
  end

  context "array_attributes" do
    subject { TestModel.array_attributes }
    it { is_expected.to eq(TestModel.attribute_names) }
  end

  context "to_array" do
    let(:model) { TestModel.new("Value1", "Value2") }
    subject { model.to_array }
    it { is_expected.to eq(["Value1", "Value2"]) }
  end
  
end
