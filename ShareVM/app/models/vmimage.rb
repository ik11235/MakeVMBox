class Vmimage < ActiveRecord::Base
  acts_as_taggable  
  acts_as_taggable_on :skills, :interests
end
