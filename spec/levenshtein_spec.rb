require 'spec_helper'

describe Levenshtein do
  it "should return the right value when no threshold is being defined" do
    Levenshtein.distance("first", "last").should eq(0.6)
  end
  
  it "should return nil value when a threshold is being passed" do
    Levenshtein.distance("first", "last", 0.1).should be_nil
  end
  
  it "should not return nil value when a threshold is being passed" do
    Levenshtein.distance("first", "last", 0.8).should_not be_nil
  end
  
  it "should not change when a threshold is being passed" do
    Levenshtein.distance("first", "last", 0.8).should eq(0.6)
  end
  
  it "should be tested?" do
    Levenshtein.distance("first", "").should eq(1)
  end
  
  it "should return zero when to strings are equal" do
    Levenshtein.distance("abc123", "abc123").should eq(0)
  end
  
  it "should never return a value larger then 1" do
    Levenshtein.distance("asdasdasdasdasdasdasdasdasdasdasdasd", "a").should <= 1
  end
  
  it "should not crash if one if the arguments is nil" do
    lambda do
      Levenshtein.distance(nil, "")
      Levenshtein.distance(nil, nil)
      Levenshtein.distance("", nil)
    end.should_not raise_error
  end
  
  it "should return the same value using nil as an empty string" do
    Levenshtein.distance(nil, nil).should eq(Levenshtein.distance("", ""))
    Levenshtein.distance(nil, "Hello").should eq(Levenshtein.distance("", "Hell0"))
  end
end