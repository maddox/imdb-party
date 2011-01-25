# Some code borrowed from http://www.erikveen.dds.nl/levenshtein/doc/index.html
require 'hintable_levenshtein'

class Levenshtein
  def self.distance(s1, s2, threshold = nil)
    
    # If the arguments is nil
    s1 = s1.to_s unless s1
    s2 = s2.to_s unless s2
    
    s1, s2  = s2, s1  if s1.length > s2.length  # s1 is the short one; s2 is the long one.

    if s2.length == 0
      0.0 # Since s1.length < s2.length, s1 must be empty as well.
    else
      if threshold
        if (d = HintableLevenshtein.new.distance(s1, s2).to_f/s2.length) <= threshold
          d
        else
          nil
        end
      else
        HintableLevenshtein.new.distance(s1, s2).to_f/s2.length
      end
    end
  end
end