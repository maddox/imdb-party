require 'spec_helper'

describe MovieSearcher do
  it "should return nil if the movie title is to long" do
    MovieSearcher.find("asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd").should be_nil
  end
end